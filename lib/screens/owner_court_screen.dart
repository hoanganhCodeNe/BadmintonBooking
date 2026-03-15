import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user.dart';
import '../models/court.dart';
import '../models/sub_court.dart';
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

  void _editCourt(Court court) {
    final nameCtrl = TextEditingController(text: court.name);
    final addressCtrl = TextEditingController(text: court.address);
    nameCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: nameCtrl.text.length),
    );
    addressCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: addressCtrl.text.length),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Sửa thông tin sân"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(labelText: "Tên sân"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressCtrl,
              keyboardType: TextInputType.streetAddress,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              enableSuggestions: false,
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
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(labelText: "Tên sân"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressCtrl,
              keyboardType: TextInputType.streetAddress,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              enableSuggestions: false,
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

  Future<void> _openSubCourtManager(Court court) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _OwnerSubCourtScreen(court: court)),
    );
    _loadCourts();
  }

  Future<void> _deleteCourt(Court court) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xóa sân"),
        content: Text("Bạn có chắc muốn xóa ${court.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Không"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await ApiService.deleteCourt(court.id!);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã xóa sân")),
      );
      _loadCourts();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không thể xóa sân này")),
      );
    }
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
                          Expanded(
                            child: InkWell(
                              onTap: () => _openMapByAddress(court.address),
                              child: Text(
                                court.address,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: "Quản lý sân con",
                            icon: Icon(Icons.tune, color: Colors.blue.shade700),
                            onPressed: () => _openSubCourtManager(court),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.orange.shade700),
                            onPressed: () => _editCourt(court),
                          ),
                          IconButton(
                            tooltip: "Xóa sân",
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCourt(court),
                          ),
                        ],
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

class _OwnerSubCourtScreen extends StatefulWidget {
  final Court court;

  const _OwnerSubCourtScreen({required this.court});

  @override
  State<_OwnerSubCourtScreen> createState() => _OwnerSubCourtScreenState();
}

class _OwnerSubCourtScreenState extends State<_OwnerSubCourtScreen> {
  List<SubCourt> _subCourts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubCourts();
  }

  Future<void> _loadSubCourts() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getSubCourts(widget.court.id!);
      if (!mounted) return;
      setState(() {
        _subCourts = data.map((e) => SubCourt.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showSubCourtDialog({SubCourt? subCourt}) async {
    final nameCtrl = TextEditingController(text: subCourt?.name ?? "");
    final isEdit = subCourt != null;
    nameCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: nameCtrl.text.length),
    );

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? "Sửa sân con" : "Thêm sân con"),
        content: TextField(
          controller: nameCtrl,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
          enableSuggestions: false,
          decoration: const InputDecoration(labelText: "Tên sân con (vd: Sân 1)"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;

              Navigator.pop(ctx);
              bool success;
              if (isEdit) {
                success = await ApiService.updateSubCourt(subCourt.id!, name, widget.court.id!);
              } else {
                success = await ApiService.createSubCourt(name, widget.court.id!);
              }

              if (!mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEdit ? "Đã cập nhật sân con" : "Đã thêm sân con"),
                  ),
                );
                _loadSubCourts();
              }
            },
            child: Text(isEdit ? "Lưu" : "Thêm"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSubCourt(SubCourt subCourt) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xóa sân con"),
        content: Text("Bạn có chắc muốn xóa ${subCourt.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Không"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await ApiService.deleteSubCourt(subCourt.id!);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã xóa sân con")),
      );
      _loadSubCourts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sân con - ${widget.court.name}")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _subCourts.isEmpty
              ? const Center(child: Text("Chưa có sân con nào"))
              : RefreshIndicator(
                  onRefresh: _loadSubCourts,
                  child: ListView.builder(
                    itemCount: _subCourts.length,
                    itemBuilder: (context, index) {
                      final subCourt = _subCourts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            child: const Icon(Icons.sports, color: Colors.blue),
                          ),
                          title: Text(
                            subCourt.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.orange.shade700),
                                onPressed: () => _showSubCourtDialog(subCourt: subCourt),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteSubCourt(subCourt),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSubCourtDialog(),
        icon: const Icon(Icons.add),
        label: const Text("Thêm sân con"),
      ),
    );
  }
}
