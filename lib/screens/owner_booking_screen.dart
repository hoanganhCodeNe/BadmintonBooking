import 'package:flutter/material.dart';
import '../models/user.dart';
import '../core/api/api_service.dart';

class OwnerBookingScreen extends StatefulWidget {
  final User user;

  const OwnerBookingScreen({super.key, required this.user});

  @override
  State<OwnerBookingScreen> createState() => _OwnerBookingScreenState();
}

class _OwnerBookingScreenState extends State<OwnerBookingScreen> {
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
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

  void _cancelBooking(int bookingId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hủy đơn đặt sân"),
        content: const Text("Bạn muốn hủy đơn đặt sân này?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Không"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ApiService.cancelBooking(bookingId);
              if (!mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã hủy đơn đặt sân")),
                );
                _loadBookings();
              }
            },
            child: const Text("Hủy đơn", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
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
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Không"),
          ),
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_bookings.isEmpty) {
      return const Center(child: Text("Chưa có đơn đặt sân nào"));
    }

    return RefreshIndicator(
      onRefresh: () async => _loadBookings(),
      child: ListView.builder(
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          final b = _bookings[index];
          final status = b['status'] ?? 'pending';
          final isPending = status == 'pending';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Player info + status
                  Row(
                    children: [
                      const Icon(Icons.person, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${b['playerName']}  •  ${b['playerPhone']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      _buildStatusChip(status),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Court info
                  Row(
                    children: [
                      const Icon(Icons.sports_tennis, size: 16, color: Colors.green),
                      const SizedBox(width: 6),
                      Text("${b['courtName']} - ${b['subCourtName']}"),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Time info
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.orange),
                      const SizedBox(width: 6),
                      Text("${b['date']}  |  ${b['startTime']} - ${b['endTime']}"),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Created at
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        "Đặt lúc: ${b['createdAt']}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  // Action buttons for pending bookings
                  if (isPending) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _approveBooking(b['id']),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text("Duyệt"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => _rejectBooking(b['id']),
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text("Từ chối"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
