class UserModel {
  final String userName;
  final String uid;
  final String email;
  final String password;
  final String phone;
  UserModel({
    required this.userName,
    required this.uid,
    required this.email,
    required this.password,
    required this.phone,
  });
  Map<String, dynamic> toJason() => {
        "userName": userName,
        "uid": uid,
        "email": email,
        "password": password,
        "phone": phone
      };
}
