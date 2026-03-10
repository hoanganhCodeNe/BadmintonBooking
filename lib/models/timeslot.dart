class TimeSlot {
  final int? id;
  final int subCourtId;
  final String date;
  final String startTime;
  final String endTime;
  final bool isBooked;

  TimeSlot({
    this.id,
    required this.subCourtId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subCourtId': subCourtId,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'isBooked': isBooked,
    };
  }

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'],
      subCourtId: json['subCourtId'],
      date: json['date'] ?? '',
      startTime: json['startTime'],
      endTime: json['endTime'],
      isBooked: json['isBooked'] ?? false,
    );
  }
}