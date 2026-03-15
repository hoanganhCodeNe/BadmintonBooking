class BookingHistory {
  final int id;
  final String courtName;
  final String subCourtName;
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final String rejectReason;
  final String createdAt;

  BookingHistory({
    required this.id,
    required this.courtName,
    required this.subCourtName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.rejectReason,
    required this.createdAt,
  });

  factory BookingHistory.fromJson(Map<String, dynamic> json) {
    return BookingHistory(
      id: json['id'],
      courtName: json['courtName'],
      subCourtName: json['subCourtName'] ?? '',
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      status: json['status'] ?? 'pending',
      rejectReason: json['rejectReason'] ?? '',
      createdAt: json['createdAt'],
    );
  }
}
