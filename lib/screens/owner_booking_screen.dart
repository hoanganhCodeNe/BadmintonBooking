import 'package:flutter/material.dart';
import '../models/user.dart';
import '../core/api/api_service.dart';

const Color _kGreen = Color(0xFF1B8E5A);

class OwnerBookingScreen extends StatefulWidget {
  final User user;

  const OwnerBookingScreen({super.key, required this.user});

  @override
  State<OwnerBookingScreen> createState() => _OwnerBookingScreenState();
}

class _OwnerBookingScreenState extends State<OwnerBookingScreen> {
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true;

  // ------ filter / search state ------
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _statusFilter = 'all';
  DateTime _selectedDate = DateTime.now();

  static const _statusOptions = [
    ('all', 'Tất cả'),
    ('pending', 'Chờ duyệt'),
    ('approved', 'Đã duyệt'),
    ('rejected', 'Từ chối'),
    ('cancelled', 'Đã hủy'),
  ];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadBookings() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getOwnerBookings(widget.user.id!);
      if (!mounted) return;
      setState(() {
        _bookings = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final dateStr = _isoDate(_selectedDate);
    final keyword = _searchQuery.trim().toLowerCase();

    final result = _bookings.where((b) {
      final bookingDate = (b['date'] ?? '').toString();
      if (!bookingDate.startsWith(dateStr)) return false;
      if (_statusFilter != 'all' && (b['status'] ?? '') != _statusFilter) return false;
      if (keyword.isNotEmpty) {
        final hay = [b['playerName'], b['playerPhone'], b['courtName'], b['subCourtName']]
            .map((v) => (v ?? '').toString().toLowerCase())
            .join(' ');
        if (!hay.contains(keyword)) return false;
      }
      return true;
    }).toList();

    result.sort((a, b) {
      final at = (a['startTime'] ?? '').toString();
      final bt = (b['startTime'] ?? '').toString();
      return at.compareTo(bt);
    });
    return result;
  }

  int _countForStatus(String status) {
    final dateStr = _isoDate(_selectedDate);
    return _bookings.where((b) {
      if (!(b['date'] ?? '').toString().startsWith(dateStr)) return false;
      if (status == 'all') return true;
      return (b['status'] ?? '') == status;
    }).length;
  }

  String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  String _displayDate(DateTime d) {
    const wd = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    final isToday = _isoDate(d) == _isoDate(DateTime.now());
    final dayLabel = isToday ? 'Hôm nay' : wd[d.weekday % 7];
    return '$dayLabel, ${d.day}/${d.month}/${d.year}';
  }

  void _shiftDate(int days) =>
      setState(() => _selectedDate = _selectedDate.add(Duration(days: days)));

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _approveBooking(int bookingId) async {
    final success = await ApiService.approveBooking(bookingId);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã duyệt đơn đặt sân")),
      );
      _loadBookings();
    }
  }

  void _rejectBooking(int bookingId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Từ chối đơn đặt sân"),
        content: const Text("Bạn muốn từ chối đơn đặt sân này?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Không")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ApiService.rejectBooking(bookingId);
              if (!mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã từ chối đơn đặt sân")),
                );
                _loadBookings();
              }
            },
            child: const Text("Từ chối", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final Color color;
    final String label;
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDateBar() {
    final isToday = _isoDate(_selectedDate) == _isoDate(DateTime.now());
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _shiftDate(-1),
            visualDensity: VisualDensity.compact,
          ),
          Expanded(
            child: GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today, size: 15, color: _kGreen),
                    const SizedBox(width: 6),
                    Text(
                      _displayDate(_selectedDate),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isToday ? _kGreen : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _shiftDate(1),
            visualDensity: VisualDensity.compact,
          ),
          if (!isToday)
            TextButton(
              onPressed: () => setState(() => _selectedDate = DateTime.now()),
              style: TextButton.styleFrom(
                foregroundColor: _kGreen,
                visualDensity: VisualDensity.compact,
              ),
              child: const Text("Hôm nay", style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: 'Tìm theo tên, SĐT, tên sân…',
          hintStyle: const TextStyle(fontSize: 13),
          prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: _statusOptions.map((opt) {
          final value = opt.$1;
          final label = opt.$2;
          final isSelected = _statusFilter == value;
          final count = _countForStatus(value);
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: Text(
                count > 0 ? '$label ($count)' : label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => setState(() => _statusFilter = value),
              selectedColor: _kGreen,
              backgroundColor: Colors.grey.shade100,
              showCheckmark: false,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> b) {
    final status = (b['status'] ?? 'pending').toString();
    final isPending = status == 'pending';
    final createdAt = (b['createdAt'] ?? '').toString();
    final timeOnly = createdAt.length > 11 ? createdAt.substring(11) : createdAt;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 15,
                  backgroundColor: Color(0xFFE3F2FD),
                  child: Icon(Icons.person, size: 16, color: Colors.blue),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b['playerName'] ?? '—',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(b['playerPhone'] ?? '',
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                _buildStatusBadge(status),
              ],
            ),
            const Divider(height: 14, thickness: 0.6),
            Row(
              children: [
                const Icon(Icons.sports_tennis, size: 15, color: _kGreen),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${b['courtName']} — ${b['subCourtName']}',
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 15, color: Colors.orange),
                const SizedBox(width: 6),
                Text(
                  '${b['startTime']} - ${b['endTime']}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                const Icon(Icons.schedule, size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Đặt lúc $timeOnly',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            if (isPending) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _rejectBooking(b['id']),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text("Từ chối"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _approveBooking(b['id']),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text("Duyệt"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Column(
      children: [
        _buildDateBar(),
        _buildSearchBar(),
        _buildStatusFilter(),
        const SizedBox(height: 2),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async => _loadBookings(),
                  child: filtered.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2),
                            Center(
                              child: Column(
                                children: [
                                  Icon(Icons.inbox_outlined,
                                      size: 56, color: Colors.grey.shade400),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Không có đơn đặt sân nào\ncho ngày ${_displayDate(_selectedDate)}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: filtered.length,
                          padding:
                              const EdgeInsets.only(bottom: 16, top: 4),
                          itemBuilder: (context, index) =>
                              _buildBookingCard(filtered[index]),
                        ),
                ),
        ),
      ],
    );
  }
}
