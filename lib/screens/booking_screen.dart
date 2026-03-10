import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../models/court.dart';
import '../models/timeslot.dart';
import '../repositories/court_repository.dart';
import '../repositories/timeslot_repository.dart';
import '../repositories/booking_repository.dart';

class BookingScreen extends StatefulWidget {
  final User user;

  const BookingScreen({super.key, required this.user});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final CourtRepository _courtRepo = CourtRepository();
  final TimeslotRepository _timeslotRepo = TimeslotRepository();
  final BookingRepository _bookingRepo = BookingRepository();

  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  List<Court> _courts = [];
  // courtId -> list of timeslots
  Map<int, List<TimeSlot>> _courtTimeslots = {};
  bool _isLoadingCourts = true;
  bool _isLoadingSlots = false;

  @override
  void initState() {
    super.initState();
    _loadCourts();
  }

  void _loadCourts() async {
    try {
      final courts = await _courtRepo.getAllCourts();
      if (!mounted) return;
      setState(() {
        _courts = courts;
        _isLoadingCourts = false;
      });
      _loadTimeslotsForDate();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingCourts = false);
    }
  }

  void _loadTimeslotsForDate() async {
    if (_courts.isEmpty) return;

    setState(() => _isLoadingSlots = true);
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    Map<int, List<TimeSlot>> map = {};

    try {
      for (final court in _courts) {
        await _timeslotRepo.generateTimeslots(court.id!, dateStr);
        final slots = await _timeslotRepo.getTimeslots(court.id!, dateStr);
        map[court.id!] = slots;
      }
      if (!mounted) return;
      setState(() {
        _courtTimeslots = map;
        _isLoadingSlots = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingSlots = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi tải khung giờ: $e")),
      );
    }
  }

  void _bookSlot(int slotId) async {
    try {
      final success = await _bookingRepo.bookCourt(widget.user.id!, slotId);
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đặt sân thành công!")),
        );
        _loadTimeslotsForDate();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đặt sân thất bại")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
    _loadTimeslotsForDate();
  }

  void _changeMonth(int delta) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingCourts) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // ===== CALENDAR =====
        _buildCalendar(),
        const Divider(height: 1),

        // ===== SELECTED DATE HEADER =====
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, size: 18, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                DateFormat('EEEE, dd/MM/yyyy', 'vi').format(_selectedDate),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // ===== COURTS + TIMESLOTS =====
        Expanded(
          child: _isLoadingSlots
              ? const Center(child: CircularProgressIndicator())
              : _courts.isEmpty
                  ? const Center(child: Text("Chưa có sân nào"))
                  : ListView.builder(
                      itemCount: _courts.length,
                      itemBuilder: (context, index) {
                        final court = _courts[index];
                        final slots = _courtTimeslots[court.id] ?? [];
                        final freeSlots = slots.where((s) => !s.isBooked).toList();

                        return _buildCourtCard(court, slots, freeSlots);
                      },
                    ),
        ),
      ],
    );
  }

  // ==================== CALENDAR WIDGET ====================

  Widget _buildCalendar() {
    final year = _focusedMonth.year;
    final month = _focusedMonth.month;
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    // Monday = 1 ... Sunday = 7
    final startWeekday = firstDay.weekday; // 1=Mon

    final dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return Container(
      color: Colors.green.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _changeMonth(-1),
              ),
              Text(
                DateFormat('MMMM yyyy', 'vi').format(_focusedMonth),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),

          // Day labels
          Row(
            children: dayLabels
                .map((d) => Expanded(
                      child: Center(
                        child: Text(d,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: d == 'CN' ? Colors.red : Colors.grey.shade700,
                            )),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 4),

          // Day grid
          _buildDayGrid(startWeekday, daysInMonth, year, month),
        ],
      ),
    );
  }

  Widget _buildDayGrid(int startWeekday, int daysInMonth, int year, int month) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final cells = <Widget>[];

    // Empty cells before first day
    for (int i = 1; i < startWeekday; i++) {
      cells.add(const SizedBox());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final isSelected = date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;
      final isToday = date == todayDate;
      final isPast = date.isBefore(todayDate);

      cells.add(
        GestureDetector(
          onTap: isPast ? null : () => _onDateSelected(date),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.green
                  : isToday
                      ? Colors.green.shade100
                      : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                  color: isPast
                      ? Colors.grey.shade400
                      : isSelected
                          ? Colors.white
                          : Colors.black87,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Fill remaining cells to complete the last row
    while (cells.length % 7 != 0) {
      cells.add(const SizedBox());
    }

    // Build rows
    final rows = <Widget>[];
    for (int i = 0; i < cells.length; i += 7) {
      rows.add(
        SizedBox(
          height: 36,
          child: Row(
            children: cells.sublist(i, i + 7).map((c) => Expanded(child: c)).toList(),
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  // ==================== COURT CARD ====================

  Widget _buildCourtCard(Court court, List<TimeSlot> allSlots, List<TimeSlot> freeSlots) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        leading: const Icon(Icons.sports_tennis, color: Colors.green),
        title: Text(court.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${court.address}\n"
          "${freeSlots.length}/${allSlots.length} khung giờ trống",
        ),
        children: allSlots.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Không có khung giờ"),
                )
              ]
            : [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: allSlots.map((slot) {
                      return _buildSlotChip(slot);
                    }).toList(),
                  ),
                ),
              ],
      ),
    );
  }

  Widget _buildSlotChip(TimeSlot slot) {
    final isFree = !slot.isBooked;
    return GestureDetector(
      onTap: isFree
          ? () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Xác nhận đặt sân"),
                  content: Text("Đặt khung giờ ${slot.startTime} - ${slot.endTime}?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Hủy"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _bookSlot(slot.id!);
                      },
                      child: const Text("Đặt"),
                    ),
                  ],
                ),
              );
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isFree ? Colors.green.shade50 : Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isFree ? Colors.green : Colors.red.shade200,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${slot.startTime} - ${slot.endTime}",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isFree ? Colors.green.shade800 : Colors.red,
              ),
            ),
            Text(
              isFree ? "Trống" : "Đã đặt",
              style: TextStyle(
                fontSize: 11,
                color: isFree ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
