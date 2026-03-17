import 'package:flutter/material.dart';
import 'core/storage/session_manager.dart';
import 'models/user.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<User?> _restoreSession() {
    return SessionManager.getSavedUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Badminton Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),

      home: FutureBuilder<User?>(
        future: _restoreSession(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final user = snapshot.data;
          if (user != null) {
            return HomeScreen(user: user);
          }

          return const LoginScreen();
        },
      ),
    );
  }
}