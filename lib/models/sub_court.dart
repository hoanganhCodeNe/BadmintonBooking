class SubCourt {
  final int? id;
  final String name;
  final int courtId;

  SubCourt({
    this.id,
    required this.name,
    required this.courtId,
  });

  factory SubCourt.fromJson(Map<String, dynamic> json) {
    return SubCourt(
      id: json['id'],
      name: json['name'],
      courtId: json['courtId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'courtId': courtId,
    };
  }
}
