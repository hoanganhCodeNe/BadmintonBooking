import '../core/api/api_service.dart';
import '../models/booking_history.dart';

class BookingRepository {
  Future<bool> bookCourt(int userId, int timeslotId) async {
    return await ApiService.bookCourt(userId, timeslotId);
  }

  Future<List<BookingHistory>> getHistory(int userId) async {
    final data = await ApiService.getBookingHistory(userId);
    return data.map((e) => BookingHistory.fromJson(e)).toList();
  }

  Future<bool> cancelBooking(int bookingId) async {
    return await ApiService.cancelBooking(bookingId);
  }
}