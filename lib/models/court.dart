class Court {
  final int? id;
  final String name;
  final String address;
  final int ownerId;

  Court({
    this.id,
    required this.name,
    required this.address,
    required this.ownerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'ownerId': ownerId,
    };
  }

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      ownerId: json['ownerId'],
    );
  }
}