class User {
  final String id;
  final String phone;
  final String username;
  final String password;
  final UserType userType;
  final DateTime createdAt;

  User({
    required this.id,
    required this.phone,
    required this.username,
    required this.password,
    required this.userType,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phone: json['phone'],
      username: json['username'],
      password: json['password'],
      userType: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${json['userType']}',
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'username': username,
      'password': password,
      'userType': userType.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? phone,
    String? username,
    String? password,
    UserType? userType,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      password: password ?? this.password,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum UserType { customer, seller }
