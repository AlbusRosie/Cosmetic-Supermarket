class User {
  final String id;
  final String username;
  final String email;
  final String? name;
  final String? avatar;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.name,
    this.avatar,
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? name,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'avatar': avatar,
    };
  }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );
  } 
}
