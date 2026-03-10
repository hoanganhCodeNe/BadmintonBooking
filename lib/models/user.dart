class User {
  final int? id;
  final String name;
  final String phone;
  final String role;

  User({
    this.id,
    required this.name,
    required this.phone,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'role': role,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
    );
  }
}