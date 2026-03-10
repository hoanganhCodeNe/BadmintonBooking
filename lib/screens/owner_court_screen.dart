import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/court.dart';
import '../core/api/api_service.dart';

class OwnerCourtScreen extends StatefulWidget {
  final User user;

  const OwnerCourtScreen({super.key, required this.user});

  @override
  State<OwnerCourtScreen> createState() => _OwnerCourtScreenState();
}

class _OwnerCourtScreenState extends State<OwnerCourtScreen> {
  List<Court> _courts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourts();
  }

  void _loadCourts() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getCourtsByOwner(widget.user.id!);
      if (!mounted) return;
      setState(() {
        _courts = data.map((e) => Court.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _editCourt(Court court) {
    final nameCtrl = TextEditingController(text: court.name);
    final addressCtrl = TextEditingController(text: court.address);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Sửa thông tin sân"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Tên sân"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressCtrl,
              decoration: const InputDecoration(labelText: "Địa chỉ"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              final address = addressCtrl.text.trim();
              if (name.isEmpty || address.isEmpty) return;

              Navigator.pop(ctx);
              final success = await ApiService.updateCourt(court.id!, name, address);
              if (!mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã cập nhật thông tin sân")),
                );
                _loadCourts();
              }
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  void _addCourt() {
    final nameCtrl = TextEditingController();
    final addressCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Thêm sân mới"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Tên sân"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressCtrl,
              decoration: const InputDecoration(labelText: "Địa chỉ"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              final address = addressCtrl.text.trim();
              if (name.isEmpty || address.isEmpty) return;

              Navigator.pop(ctx);
              final success = await ApiService.createCourt(name, address, widget.user.id!);
              if (!mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã thêm sân mới")),
                );
                _loadCourts();
              }
            },
            child: const Text("Thêm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: _courts.isEmpty
          ? const Center(child: Text("Bạn chưa có sân nào"))
          : RefreshIndicator(
              onRefresh: () async => _loadCourts(),
              child: ListView.builder(
                itemCount: _courts.length,
                itemBuilder: (context, index) {
                  final court = _courts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        child: const Icon(Icons.sports_tennis, color: Colors.green),
                      ),
                      title: Text(court.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(child: Text(court.address, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange.shade700),
                        onPressed: () => _editCourt(court),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCourt,
        child: const Icon(Icons.add),
      ),
    );
  }
}
