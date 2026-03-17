import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiService {
  // Đổi URL này theo địa chỉ server của bạn
  // Android Emulator: http://10.0.2.2:5000
  // iOS Simulator / Web: http://localhost:5000
  // Thiết bị thật: http://<IP_MÁY_TÍNH>:5000
  // Current LAN IP of development machine for physical device testing.
  static const String baseUrl = 'http://192.168.12.100:5000/api';
  static const Duration _requestTimeout = Duration(seconds: 12);

  // ==================== USER ====================

  static Future<Map<String, dynamic>> login(String phone, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    ).timeout(_requestTimeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Sai số điện thoại hoặc mật khẩu');
    }

    throw Exception('Lỗi server: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>?> register(String name, String phone, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'phone': phone, 'password': password}),
    ).timeout(_requestTimeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 400) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Đăng ký thất bại');
    }

    throw Exception('Lỗi server: ${response.statusCode}');
  }

  // ==================== ADMIN - USER MANAGEMENT ====================

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static Future<bool> updateUserRole(int userId, String role) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId/role'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'role': role}),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteUser(int userId) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$userId'));
    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>> updateProfile(int userId, String name, String phone) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId/profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'phone': phone}),
    ).timeout(_requestTimeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    if (response.statusCode == 400 || response.statusCode == 404) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Cập nhật thông tin thất bại');
    }

    throw Exception('Lỗi server: ${response.statusCode}');
  }

  static Future<void> changePassword(int userId, String currentPassword, String newPassword) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId/password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    ).timeout(_requestTimeout);

    if (response.statusCode == 200) {
      return;
    }

    if (response.statusCode == 400 || response.statusCode == 404) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Đổi mật khẩu thất bại');
    }

    throw Exception('Lỗi server: ${response.statusCode}');
  }

  // ==================== COURT ====================

  static Future<List<Map<String, dynamic>>> getAllCourts() async {
    final response = await http.get(Uri.parse('$baseUrl/courts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> getCourtsByOwner(int ownerId) async {
    final response = await http.get(Uri.parse('$baseUrl/courts/owner/$ownerId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static Future<bool> createCourt(String name, String address, int ownerId) async {
    final createdCourt = await createCourtDetail(name, address, ownerId);
    return createdCourt != null;
  }

  static Future<Map<String, dynamic>?> createCourtDetail(
    String name,
    String address,
    int ownerId, {
    double morningPrice = 20000,
    double afternoonPrice = 50000,
    double eveningPrice = 80000,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'address': address,
        'ownerId': ownerId,
        'morningPrice': morningPrice,
        'afternoonPrice': afternoonPrice,
        'eveningPrice': eveningPrice,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    return null;
  }

  static Future<List<String>> uploadCourtImages(int courtId, List<String> imagePaths) async {
    if (imagePaths.isEmpty) return [];

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/courts/$courtId/images'),
    );

    for (final imagePath in imagePaths.take(5)) {
      request.files.add(await http.MultipartFile.fromPath('images', imagePath));
    }

    final response = await request.send().timeout(_requestTimeout);
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody) as List<dynamic>;
      return data.map((item) => item.toString()).toList();
    }

    throw Exception('Upload ảnh thất bại: ${response.statusCode}');
  }

  static Future<bool> updateCourt(
    int courtId,
    String name,
    String address, {
    String? imageUrl,
    List<String>? imageUrls,
    double morningPrice = 20000,
    double afternoonPrice = 50000,
    double eveningPrice = 80000,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/courts/$courtId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'address': address,
        'imageUrl': imageUrl,
        'imageUrls': imageUrls,
        'morningPrice': morningPrice,
        'afternoonPrice': afternoonPrice,
        'eveningPrice': eveningPrice,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteCourt(int courtId) async {
    final response = await http.delete(Uri.parse('$baseUrl/courts/$courtId'));
    return response.statusCode == 200;
  }

  // ==================== SUBCOURT ====================

  static Future<List<Map<String, dynamic>>> getSubCourts(int courtId) async {
    final response = await http.get(Uri.parse('$baseUrl/subcourts?courtId=$courtId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static Future<bool> createSubCourt(String name, int courtId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/subcourts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'courtId': courtId}),
    );
    return response.statusCode == 200;
  }

  static Future<bool> updateSubCourt(int subCourtId, String name, int courtId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/subcourts/$subCourtId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'courtId': courtId}),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteSubCourt(int subCourtId) async {
    final response = await http.delete(Uri.parse('$baseUrl/subcourts/$subCourtId'));
    return response.statusCode == 200;
  }

  // ==================== TIMESLOT ====================

  static Future<List<Map<String, dynamic>>> getTimeSlots(int subCourtId, String date) async {
    final response = await http.get(
      Uri.parse('$baseUrl/timeslots?subCourtId=$subCourtId&date=$date'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static Future<void> generateTimeSlots(int subCourtId, String date) async {
    await http.post(
      Uri.parse('$baseUrl/timeslots/generate?subCourtId=$subCourtId&date=$date'),
    );
  }

  // ==================== BOOKING ====================

  static Future<bool> bookCourt(int userId, int timeSlotId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'timeSlotId': timeSlotId}),
    );

    if (response.statusCode == 200) {
      return true;
    }

    if (response.statusCode == 400 || response.statusCode == 404) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Đặt sân thất bại');
    }

    throw Exception('Lỗi server: ${response.statusCode}');
  }

  static Future<List<Map<String, dynamic>>> getBookingHistory(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings/history/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> getOwnerBookings(int ownerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings/owner/$ownerId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static Future<bool> cancelBooking(int bookingId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/bookings/$bookingId/cancel'),
    );
    return response.statusCode == 200;
  }

  static Future<bool> approveBooking(int bookingId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/bookings/$bookingId/approve'),
    );
    return response.statusCode == 200;
  }

  static Future<bool> rejectBooking(int bookingId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/bookings/$bookingId/reject'),
    );
    return response.statusCode == 200;
  }
}
