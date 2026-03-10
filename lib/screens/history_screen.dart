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
  List<BookingHistory> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_bookings.isEmpty) {
      return const Center(child: Text("Chưa có lịch sử đặt sân"));
    }

    return RefreshIndicator(
      onRefresh: () async => _loadHistory(),
      child: _buildList(),
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

  Widget _buildList() {
    return ListView.builder(
      itemCount: _bookings.length,
      itemBuilder: (context, index) {
        final booking = _bookings[index];
        final canCancel = booking.status == 'pending' || booking.status == 'approved';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.sports_tennis, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${booking.courtName} - ${booking.subCourtName}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    _buildStatusChip(booking.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "${booking.date}  |  ${booking.startTime} - ${booking.endTime}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Đặt lúc: ${booking.createdAt}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (canCancel)
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Xác nhận"),
                              content: const Text("Bạn muốn hủy đặt sân này?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text("Không"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    _cancelBooking(booking.id);
                                  },
                                  child: const Text("Hủy đặt"),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.cancel, size: 18, color: Colors.red),
                        label: const Text("Hủy", style: TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
