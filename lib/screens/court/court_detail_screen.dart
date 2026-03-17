import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/court.dart';
import '../../models/user.dart';
import '../../models/sub_court.dart';
import '../../models/timeslot.dart';
import '../../core/api/api_service.dart';
import '../../repositories/timeslot_repository.dart';
import '../../repositories/booking_repository.dart';

class CourtDetailScreen extends StatefulWidget {

  final Court court;
  final User user;

  const CourtDetailScreen({super.key, required this.court, required this.user});

  @override
  State<CourtDetailScreen> createState() => _CourtDetailScreenState();
}

class _CourtDetailScreenState extends State<CourtDetailScreen> with SingleTickerProviderStateMixin {

  final TimeslotRepository timeslotRepository = TimeslotRepository();
  final BookingRepository bookingRepository = BookingRepository();

  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  List<SubCourt> _subCourts = [];
  TabController? _tabController;
  Map<int, List<TimeSlot>> _timeslotsMap = {};
  bool _isLoadingSubCourts = true;
  bool _isLoadingSlots = false;

  @override
  void initState() {
    super.initState();
    _loadSubCourts();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _loadSubCourts() async {
    setState(() => _isLoadingSubCourts = true);
    try {
      final data = await ApiService.getSubCourts(widget.court.id!);
      final subCourts = data.map((e) => SubCourt.fromJson(e)).toList();

      if (!mounted) return;
      _tabController?.dispose();
      _tabController = TabController(length: subCourts.length, vsync: this);
      _tabController!.addListener(() {
        if (!_tabController!.indexIsChanging) {
          setState(() {});
        }
      });

      setState(() {
        _subCourts = subCourts;
        _isLoadingSubCourts = false;
      });

      _loadAllTimeslots();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingSubCourts = false);
    }
  }

  void _loadAllTimeslots() async {
    if (_subCourts.isEmpty) return;
    setState(() => _isLoadingSlots = true);
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

    try {
      Map<int, List<TimeSlot>> newMap = {};
      for (var sc in _subCourts) {
        await timeslotRepository.generateTimeslots(sc.id!, dateStr);
        final slots = await timeslotRepository.getTimeslots(sc.id!, dateStr);
        newMap[sc.id!] = slots;
      }

      if (!mounted) return;
      setState(() {
        _timeslotsMap = newMap;
        _isLoadingSlots = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingSlots = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi tải dữ liệu: $e")),
      );
    }
  }

  void _bookSlot(int slotId) async {
    try {
      final success = await bookingRepository.bookCourt(widget.user.id!, slotId);
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đã gửi yêu cầu đặt sân, chờ duyệt!")),
        );
        _loadAllTimeslots();
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
    _loadAllTimeslots();
  }

  void _changeMonth(int delta) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + delta);
    });
  }

  Future<void> _openMapByAddress(String address) async {
    final encoded = Uri.encodeComponent(address);
    final mapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');

    final launched = await launchUrl(
      mapsUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không thể mở Google Maps")),
      );
    }
  }

  void _openImageViewer(List<String> gallery, int initialIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (_) {
        final pageController = PageController(initialPage: initialIndex);
        var currentIndex = initialIndex;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: pageController,
                      itemCount: gallery.length,
                      onPageChanged: (index) => setDialogState(() => currentIndex = index),
                      itemBuilder: (context, index) {
                        return InteractiveViewer(
                          minScale: 1,
                          maxScale: 4,
                          child: Center(
                            child: Image.network(
                              gallery[index],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.broken_image,
                                size: 72,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      ),
                    ),
                    Positioned(
                      bottom: 18,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${currentIndex + 1}/${gallery.length}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCourtInfoSection(List<String> gallery) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.green.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.court.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (gallery.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ảnh sân',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                Text(
                  '${gallery.length} ảnh',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: gallery.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _openImageViewer(gallery, index),
                    child: Hero(
                      tag: 'court-image-$index-${widget.court.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          gallery[index],
                          width: 220,
                          height: 140,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              width: 220,
                              height: 140,
                              color: Colors.green.shade100,
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 220,
                            height: 140,
                            color: Colors.green.shade100,
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.court.address,
                  style: const TextStyle(color: Color(0xFF4E6458), height: 1.35),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPriceTag('Sáng\n6h-11h', widget.court.morningPrice, Colors.blue.shade700),
                Container(width: 1, height: 32, color: Colors.green.shade100),
                _buildPriceTag('Chiều\n11h-17h', widget.court.afternoonPrice, Colors.orange.shade700),
                Container(width: 1, height: 32, color: Colors.green.shade100),
                _buildPriceTag('Tối\n17h+', widget.court.eveningPrice, Colors.purple.shade700),
              ],
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _openMapByAddress(widget.court.address),
            icon: const Icon(Icons.map_outlined, size: 18),
            label: const Text('Mở Google Maps'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green.shade800,
              side: BorderSide(color: Colors.green.shade200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gallery = widget.court.gallery;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.court.name),
      ),
      body: _isLoadingSubCourts
          ? const Center(child: CircularProgressIndicator())
          : _subCourts.isEmpty
              ? const Center(child: Text("Chưa có sân con nào"))
              : NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(child: _buildCourtInfoSection(gallery)),
                      SliverToBoxAdapter(child: _buildCalendar()),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 18, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat('EEEE, dd/MM/yyyy', 'vi').format(_selectedDate),
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _TabBarHeaderDelegate(
                          TabBar(
                            controller: _tabController,
                            isScrollable: _subCourts.length > 3,
                            labelColor: Colors.green.shade800,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Colors.green,
                            tabs: _subCourts.map((sc) {
                              final slots = _timeslotsMap[sc.id] ?? [];
                              final sortedSlots = _sortSlots(slots);
                              final freeCount = sortedSlots.where((s) => !s.isBooked && !_isSlotPast(s)).length;
                              return Tab(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(sc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text('$freeCount trống', style: const TextStyle(fontSize: 10)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: _isLoadingSlots
                      ? const Center(child: CircularProgressIndicator())
                      : TabBarView(
                          controller: _tabController,
                          children: _subCourts.map((sc) {
                            final slots = _sortSlots(_timeslotsMap[sc.id] ?? []);
                            if (slots.isEmpty) {
                              return const Center(child: Text('Không có khung giờ'));
                            }
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final crossAxisCount = constraints.maxWidth < 380 ? 2 : 3;
                                  final childAspectRatio = crossAxisCount == 2 ? 1.85 : 1.55;

                                  return GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: childAspectRatio,
                                    ),
                                    itemCount: slots.length,
                                    itemBuilder: (context, index) => _buildSlotTile(slots[index]),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),
                ),
    );
  }

  // ==================== CALENDAR ====================

  Widget _buildCalendar() {
    final year = _focusedMonth.year;
    final month = _focusedMonth.month;
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startWeekday = firstDay.weekday; // 1=Mon

    final dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return Container(
      color: Colors.white,
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
          _buildDayGrid(startWeekday, daysInMonth, year, month),
        ],
      ),
    );
  }

  Widget _buildDayGrid(int startWeekday, int daysInMonth, int year, int month) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final cells = <Widget>[];

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

    while (cells.length % 7 != 0) {
      cells.add(const SizedBox());
    }

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

  // ==================== HELPERS ====================

  Widget _buildPriceTag(String label, double price, Color color) {
    final formatted = _formatPrice(price);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 2),
        Text(
          formatted,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}k/h';
    }
    return '${price.toStringAsFixed(0)}/h';
  }

  int _parseTimeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  bool get _isToday {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  List<TimeSlot> _sortSlots(List<TimeSlot> slots) {
    final sorted = List<TimeSlot>.from(slots)
      ..sort((a, b) => _parseTimeToMinutes(a.startTime).compareTo(_parseTimeToMinutes(b.startTime)));
    return sorted;
  }

  bool _isSlotPast(TimeSlot slot) {
    if (!_isToday) return false;
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    return _parseTimeToMinutes(slot.endTime) <= nowMinutes;
  }

  bool _isSlotCurrent(TimeSlot slot) {
    if (!_isToday) return false;
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    return _parseTimeToMinutes(slot.startTime) <= nowMinutes &&
        nowMinutes < _parseTimeToMinutes(slot.endTime);
  }

  // ==================== SLOT TILE ====================

  Widget _buildSlotTile(TimeSlot slot) {
    final isPast = _isSlotPast(slot);
    final isCurrent = _isSlotCurrent(slot);
    final canBook = !slot.isBooked && !isPast && !isCurrent;

    Color bgColor;
    Color borderColor;
    Color textColor;
    String label;

    if (isPast) {
      bgColor = Colors.grey.shade200;
      borderColor = Colors.grey.shade400;
      textColor = Colors.grey;
      label = "Đã qua";
    } else if (slot.isBooked) {
      bgColor = Colors.red.shade50;
      borderColor = Colors.red.shade200;
      textColor = Colors.red;
      label = "Đã đặt";
    } else if (isCurrent) {
      bgColor = Colors.orange.shade50;
      borderColor = Colors.orange;
      textColor = Colors.orange.shade800;
      label = "Đang diễn ra";
    } else {
      bgColor = Colors.green.shade50;
      borderColor = Colors.green;
      textColor = Colors.green.shade800;
      label = "Trống";
    }

    return GestureDetector(
      onTap: canBook
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
          : () {
              String msg;
              if (isPast) {
                msg = "Khung giờ ${slot.startTime} - ${slot.endTime} đã qua, không thể đặt!";
              } else if (isCurrent) {
                msg = "Khung giờ ${slot.startTime} - ${slot.endTime} đang diễn ra, không thể đặt!";
              } else {
                msg = "Khung giờ ${slot.startTime} - ${slot.endTime} đã có người đặt!";
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: Colors.orange),
              );
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${slot.startTime} - ${slot.endTime}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textColor,
                decoration: isPast ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, color: textColor)),
            if (!isPast) ...[
              const SizedBox(height: 4),
              Text(
                _formatPrice(
                  widget.court.priceForHour(
                    int.parse(slot.startTime.split(':')[0]),
                  ),
                ),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarHeaderDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Colors.white,
      elevation: overlapsContent ? 1 : 0,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarHeaderDelegate oldDelegate) => oldDelegate.tabBar != tabBar;
}