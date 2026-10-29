class UserModel {
  final String token;
  final String name;
  final String email;
  final String role;
  String balance;
  final String building;
  final String room_number;
  final bool isBanned;

  UserModel({
    required this.token,
    required this.name,
    required this.email,
    required this.role,
    required this.balance,
    required this.building,
    required this.room_number,
    this.isBanned = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String email = ''}) {
    return UserModel(
      token: json['id'],
      name: json['name'],
      email: email,
      role: json['role'],
      balance: json['balance'].toString(),
      building: json['building'] ?? '',
      room_number: json['room_number'] ?? '',
      isBanned: json['is_banned'] == true,
    );
  }
}
