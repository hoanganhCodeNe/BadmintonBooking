import 'package:flutter/material.dart';
import '../models/user.dart';
import 'court/court_list_screen.dart';
import 'history_screen.dart';
import 'admin_user_screen.dart';
import 'owner_court_screen.dart';
import 'owner_booking_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;
  late final List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    final role = widget.user.role;

    _pages = [
      CourtListScreen(user: widget.user),
      HistoryScreen(user: widget.user),
      if (role == 'owner') OwnerCourtScreen(user: widget.user),
      if (role == 'owner') OwnerBookingScreen(user: widget.user),
      if (role == 'admin') AdminUserScreen(currentUser: widget.user),
    ];

    _navItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.sports_tennis),
        label: "Sân cầu",
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: "Lịch sử",
      ),
      if (role == 'owner')
        const BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: "Sân của tôi",
        ),
      if (role == 'owner')
        const BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: "Đơn đặt",
        ),
      if (role == 'admin')
        const BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings),
          label: "Quản lý",
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xin chào, ${widget.user.name}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: _navItems,
      ),
    );
  }
}