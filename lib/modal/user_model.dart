class UserModel {
  String id;
  String name;
  String email;
  String password;
  String token;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.token});

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      name: data['name'] ?? 'Unknown',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      token: data['token'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'token': token,
    };
  }
}
