class User {
  final int? userId;
  final String? userName;
  final String userEmail;
  final String? userPassword;

  User(
      {this.userId,
      this.userName,
      required this.userEmail,
      this.userPassword});

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'user_password': userPassword,
    };
  }

  User.fromJson(Map<String, dynamic> jsonData)
      : userId = jsonData['user_id'],
        userName = jsonData['user_name'],
        userEmail = jsonData['user_email'],
        userPassword = jsonData['user_password'];
}
