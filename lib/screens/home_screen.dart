import 'package:flutter/material.dart';
import '../core/storage/session_manager.dart';
import '../models/user.dart';
import 'court/court_list_screen.dart';
import 'history_screen.dart';
import 'admin_user_screen.dart';
import 'owner_court_screen.dart';
import 'owner_booking_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  List<Widget> get _pages {
    final role = _currentUser.role;
    return [
      CourtListScreen(user: _currentUser),
      HistoryScreen(user: _currentUser),
      if (role == 'owner') OwnerCourtScreen(user: _currentUser),
      if (role == 'owner') OwnerBookingScreen(user: _currentUser),
      if (role == 'owner' || role == 'player')
        ProfileScreen(
          user: _currentUser,
          onUserUpdated: (updatedUser) {
            if (!mounted) return;
            setState(() => _currentUser = updatedUser);
          },
        ),
      if (role == 'admin') AdminUserScreen(currentUser: _currentUser),
    ];
  }

  List<BottomNavigationBarItem> get _navItems {
    final role = _currentUser.role;
    return [
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
      if (role == 'owner' || role == 'player')
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Bạn",
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
        title: Text("Xin chào, ${_currentUser.name}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SessionManager.clearSession();
              if (!context.mounted) return;
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