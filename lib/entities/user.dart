class User {
  final int id;
  final String name;
  final String email;
  User(this.id, this.name, this.email);

  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return User(
      json['id'] as int,
      json['name'] as String,
      json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}