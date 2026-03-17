import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';

class SessionManager {
  static const String _userKey = 'logged_in_user';

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final rawUser = prefs.getString(_userKey);
    if (rawUser == null || rawUser.isEmpty) {
      return null;
    }

    try {
      final data = jsonDecode(rawUser) as Map<String, dynamic>;
      return User.fromJson(data);
    } catch (_) {
      await clearSession();
      return null;
    }
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}