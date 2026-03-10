import '../core/api/api_service.dart';
import '../models/court.dart';

class CourtRepository {
  Future<List<Court>> getAllCourts() async {
    final result = await ApiService.getAllCourts();
    return result.map((e) => Court.fromJson(e)).toList();
  }

  Future<bool> insertCourt(String name, String address, int ownerId) async {
    return await ApiService.createCourt(name, address, ownerId);
  }
}