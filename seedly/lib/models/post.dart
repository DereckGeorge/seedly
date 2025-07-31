class Post {
  final String id;
  final String customerId;
  final String customerName;
  final String title;
  final String description;
  final PostStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? selectedOfferId;

  Post({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.selectedOfferId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      title: json['title'],
      description: json['description'],
      status: PostStatus.values.firstWhere(
        (e) => e.toString() == 'PostStatus.${json['status']}',
      ),
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      selectedOfferId: json['selectedOfferId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'title': title,
      'description': description,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'selectedOfferId': selectedOfferId,
    };
  }

  Post copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? title,
    String? description,
    PostStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
    String? selectedOfferId,
  }) {
    return Post(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      selectedOfferId: selectedOfferId ?? this.selectedOfferId,
    );
  }
}

enum PostStatus { active, completed }
