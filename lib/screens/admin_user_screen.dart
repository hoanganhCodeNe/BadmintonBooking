import 'package:flutter/material.dart';
import '../models/user.dart';
import '../core/api/api_service.dart';

class AdminUserScreen extends StatefulWidget {
  final User currentUser;

  const AdminUserScreen({super.key, required this.currentUser});

  @override
  State<AdminUserScreen> createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends State<AdminUserScreen> {
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getAllUsers();
      if (!mounted) return;
      setState(() {
        _users = data.map((e) => User.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi tải dữ liệu: $e")),
      );
    }
  }

  String _roleName(String role) {
    switch (role) {
      case 'admin': return 'Admin';
      case 'owner': return 'Chủ sân';
      default: return 'Người chơi';
    }
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'admin': return Colors.red;
      case 'owner': return Colors.orange;
      default: return Colors.green;
    }
  }

  IconData _roleIcon(String role) {
    switch (role) {
      case 'admin': return Icons.admin_panel_settings;
      case 'owner': return Icons.store;
      default: return Icons.person;
    }
  }

  void _changeRole(User user) {
    final roles = ['player', 'owner', 'admin'].where((r) => r != user.role).toList();

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text('Đổi vai trò "${user.name}"'),
        children: roles.map((r) {
          return SimpleDialogOption(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ApiService.updateUserRole(user.id!, r);
              if (!mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Đã đổi thành ${_roleName(r)}")),
                );
                _loadUsers();
              }
            },
            child: Row(
              children: [
                Icon(_roleIcon(r), color: _roleColor(r)),
                const SizedBox(width: 12),
                Text(_roleName(r)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _deleteUser(User user) {
    if (user.id == widget.currentUser.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không thể xóa chính mình")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: Text('Bạn muốn xóa người dùng "${user.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ApiService.deleteUser(user.id!);
              if (!mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã xóa người dùng")),
                );
                _loadUsers();
              }
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
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

    if (_users.isEmpty) {
      return const Center(child: Text("Không có người dùng nào"));
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Text(
            "Tổng: ${_users.length} người dùng",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => _loadUsers(),
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                final isCurrentUser = user.id == widget.currentUser.id;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _roleColor(user.role).withValues(alpha: 0.15),
                      child: Icon(
                        _roleIcon(user.role),
                        color: _roleColor(user.role),
                      ),
                    ),
                    title: Row(
                      children: [
                        Flexible(child: Text(user.name, overflow: TextOverflow.ellipsis)),
                        if (isCurrentUser)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text("Bạn", style: TextStyle(fontSize: 10, color: Colors.blue)),
                          ),
                      ],
                    ),
                    subtitle: Text(
                      "${user.phone}  •  ${_roleName(user.role)}",
                    ),
                    trailing: isCurrentUser
                        ? null
                        : PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'role') _changeRole(user);
                              if (value == 'delete') _deleteUser(user);
                            },
                            itemBuilder: (ctx) => [
                              const PopupMenuItem(
                                value: 'role',
                                child: Row(
                                  children: [
                                    Icon(Icons.swap_horiz, color: Colors.orange, size: 20),
                                    SizedBox(width: 8),
                                    Text('Đổi vai trò'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red, size: 20),
                                    SizedBox(width: 8),
                                    Text('Xóa người dùng', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
