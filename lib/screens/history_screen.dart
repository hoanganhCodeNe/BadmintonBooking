import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/booking_history.dart';
import '../repositories/booking_repository.dart';

class HistoryScreen extends StatefulWidget {
  final User user;

  const HistoryScreen({super.key, required this.user});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final BookingRepository _bookingRepo = BookingRepository();
  final TextEditingController _searchController = TextEditingController();

  List<BookingHistory> _bookings = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _statusFilter = 'all';
  String _dateFilter = 'all';

  static const _statusOptions = [
    ('all', 'Tất cả'),
    ('pending', 'Chờ duyệt'),
    ('approved', 'Đã duyệt'),
    ('rejected', 'Từ chối'),
    ('cancelled', 'Đã hủy'),
  ];

  static const _dateOptions = [
    ('all', 'Toàn bộ'),
    ('today', 'Hôm nay'),
    ('7d', '7 ngày'),
    ('30d', '30 ngày'),
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadHistory() async {
    try {
      final data = await _bookingRepo.getHistory(widget.user.id!);
      if (!mounted) return;
      setState(() {
        _bookings = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }
  }

  void _cancelBooking(int bookingId) async {
    try {
      final success = await _bookingRepo.cancelBooking(bookingId);
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đã hủy đặt sân")),
        );
        _loadHistory();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }
  }

  bool _matchDateFilter(BookingHistory booking) {
    if (_dateFilter == 'all') return true;

    final bookingDate = DateTime.tryParse(booking.date);
    if (bookingDate == null) return true;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bookingDay = DateTime(bookingDate.year, bookingDate.month, bookingDate.day);

    if (_dateFilter == 'today') {
      return bookingDay == today;
    }

    if (_dateFilter == '7d') {
      final diff = today.difference(bookingDay).inDays;
      return diff >= 0 && diff <= 7;
    }

    if (_dateFilter == '30d') {
      final diff = today.difference(bookingDay).inDays;
      return diff >= 0 && diff <= 30;
    }

    return true;
  }

  List<BookingHistory> get _filteredBookings {
    final keyword = _searchQuery.trim().toLowerCase();
    final filtered = _bookings.where((booking) {
      if (_statusFilter != 'all' && booking.status != _statusFilter) {
        return false;
      }

      if (!_matchDateFilter(booking)) {
        return false;
      }

      if (keyword.isEmpty) {
        return true;
      }

      final haystack =
          '${booking.courtName} ${booking.subCourtName} ${booking.date} ${booking.startTime} ${booking.endTime}'
              .toLowerCase();
      return haystack.contains(keyword);
    }).toList();

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filtered = _filteredBookings;

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF7),
      body: RefreshIndicator(
        onRefresh: () async => _loadHistory(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 12),
            _buildSearchBar(),
            const SizedBox(height: 8),
            _buildStatusFilterRow(),
            const SizedBox(height: 8),
            _buildDateFilterRow(),
            const SizedBox(height: 8),
            if (_bookings.isEmpty)
              _buildEmptyState('Chưa có lịch sử đặt sân')
            else if (filtered.isEmpty)
              _buildEmptyState('Không tìm thấy đơn phù hợp bộ lọc')
            else
              ...filtered.map(_buildBookingCard),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF0E7C4D), Color(0xFF2A9F6B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x231B8E5A),
            blurRadius: 24,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.history, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lịch sử đặt sân',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_bookings.length} đơn • Lọc nhanh theo trạng thái và ngày',
                  style: const TextStyle(fontSize: 12, color: Color(0xDEFFFFFF)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _searchQuery = value),
      decoration: InputDecoration(
        hintText: 'Tìm theo tên sân, ngày, khung giờ…',
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                icon: const Icon(Icons.close, size: 18),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildStatusFilterRow() {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _statusOptions.map((option) {
          final value = option.$1;
          final label = option.$2;
          final selected = _statusFilter == value;

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              selected: selected,
              onSelected: (_) => setState(() => _statusFilter = value),
              selectedColor: const Color(0xFF1B8E5A),
              backgroundColor: Colors.white,
              checkmarkColor: Colors.white,
              side: BorderSide.none,
              showCheckmark: false,
              visualDensity: VisualDensity.compact,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateFilterRow() {
    return SizedBox(
      height: 34,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _dateOptions.map((option) {
          final value = option.$1;
          final label = option.$2;
          final selected = _dateFilter == value;

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(
              label: Text(label, style: const TextStyle(fontSize: 12)),
              selected: selected,
              onSelected: (_) => setState(() => _dateFilter = value),
              selectedColor: const Color(0xFFD7F1E2),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: selected ? const Color(0xFF0F7A4B) : Colors.black87,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
              side: BorderSide(
                color: selected ? const Color(0xFF97D7B7) : Colors.transparent,
              ),
              visualDensity: VisualDensity.compact,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    switch (status) {
      case 'approved':
        color = Colors.green;
        label = 'Đã duyệt';
        break;
      case 'rejected':
        color = Colors.red;
        label = 'Từ chối';
        break;
      case 'cancelled':
        color = Colors.grey;
        label = 'Đã hủy';
        break;
      default:
        color = Colors.orange;
        label = 'Chờ duyệt';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 44, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BookingHistory booking) {
    final canCancel = booking.status == 'pending' || booking.status == 'approved';

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F7EF),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.sports_tennis, color: Color(0xFF1B8E5A), size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${booking.courtName} - ${booking.subCourtName}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                ),
                _buildStatusChip(booking.status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  booking.date,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF37474F)),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  '${booking.startTime} - ${booking.endTime}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if (booking.status == 'rejected' && booking.rejectReason.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Lý do: ${booking.rejectReason}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFFCC3D3D), fontStyle: FontStyle.italic),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đặt lúc: ${booking.createdAt}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (canCancel)
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Xác nhận'),
                          content: const Text('Bạn muốn hủy đặt sân này?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Không'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                _cancelBooking(booking.id);
                              },
                              child: const Text('Hủy đặt'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.cancel_outlined, size: 18, color: Colors.red),
                    label: const Text('Hủy', style: TextStyle(color: Colors.red)),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
