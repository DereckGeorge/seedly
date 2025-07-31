class Offer {
  final String id;
  final String postId;
  final String sellerId;
  final String sellerName;
  final String sellerPhone;
  final double price;
  final String description;
  final List<String> images;
  final DateTime createdAt;
  final bool isSelected;

  Offer({
    required this.id,
    required this.postId,
    required this.sellerId,
    required this.sellerName,
    required this.sellerPhone,
    required this.price,
    required this.description,
    required this.images,
    required this.createdAt,
    this.isSelected = false,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      postId: json['postId'],
      sellerId: json['sellerId'],
      sellerName: json['sellerName'],
      sellerPhone: json['sellerPhone'],
      price: json['price'].toDouble(),
      description: json['description'],
      images: List<String>.from(json['images']),
      createdAt: DateTime.parse(json['createdAt']),
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerPhone': sellerPhone,
      'price': price,
      'description': description,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
      'isSelected': isSelected,
    };
  }

  Offer copyWith({
    String? id,
    String? postId,
    String? sellerId,
    String? sellerName,
    String? sellerPhone,
    double? price,
    String? description,
    List<String>? images,
    DateTime? createdAt,
    bool? isSelected,
  }) {
    return Offer(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerPhone: sellerPhone ?? this.sellerPhone,
      price: price ?? this.price,
      description: description ?? this.description,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
