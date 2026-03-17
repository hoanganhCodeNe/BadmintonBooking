import 'dart:convert';

class Court {
  final int? id;
  final String name;
  final String address;
  final int ownerId;
  final int subCourtCount;
  final String? imageUrl;
  final List<String> imageUrls;
  final double morningPrice;    // 6h - 11h
  final double afternoonPrice;  // 11h - 17h
  final double eveningPrice;    // 17h - 23h

  Court({
    this.id,
    required this.name,
    required this.address,
    required this.ownerId,
    this.subCourtCount = 0,
    this.imageUrl,
    this.imageUrls = const [],
    this.morningPrice = 20000,
    this.afternoonPrice = 50000,
    this.eveningPrice = 80000,
  });

  List<String> get gallery {
    if (imageUrls.isNotEmpty) return imageUrls;
    if (imageUrl == null || imageUrl!.trim().isEmpty) return const [];

    final raw = imageUrl!.trim();
    if (!raw.startsWith('[')) return [raw];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((item) => item.toString()).where((item) => item.isNotEmpty).toList();
    } catch (_) {
      return const [];
    }
  }

  String? get coverImage => gallery.isEmpty ? imageUrl : gallery.first;

  /// Tính giá cho 1 khung giờ dựa theo giờ bắt đầu.
  double priceForHour(int startHour) {
    if (startHour < 11) return morningPrice;
    if (startHour < 17) return afternoonPrice;
    return eveningPrice;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'ownerId': ownerId,
      'subCourtCount': subCourtCount,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'morningPrice': morningPrice,
      'afternoonPrice': afternoonPrice,
      'eveningPrice': eveningPrice,
    };
  }

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      ownerId: json['ownerId'],
      subCourtCount: json['subCourtCount'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .where((item) => item.isNotEmpty)
              .toList() ??
          const [],
      morningPrice: (json['morningPrice'] as num?)?.toDouble() ?? 20000,
      afternoonPrice: (json['afternoonPrice'] as num?)?.toDouble() ?? 50000,
      eveningPrice: (json['eveningPrice'] as num?)?.toDouble() ?? 80000,
    );
  }
}
