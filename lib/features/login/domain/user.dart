class User {
  String userId;
  String username;
  String email;

  User(this.userId, this.username, this.email);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['user_id'],
      json['username'],
      json['email'],
    );
  }
}
