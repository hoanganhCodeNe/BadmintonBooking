import '../core/api/api_service.dart';
import '../models/timeslot.dart';

class TimeslotRepository {
  Future<void> generateTimeslots(int subCourtId, String date) async {
    await ApiService.generateTimeSlots(subCourtId, date);
  }

  Future<List<TimeSlot>> getTimeslots(int subCourtId, String date) async {
    final result = await ApiService.getTimeSlots(subCourtId, date);
    return result.map((e) => TimeSlot.fromJson(e)).toList();
  }
}
