class AccountModel {
  final String id; // uuid
  final String name;
  final String email;
  final String role;
  double balance;
  bool isBanned;

  AccountModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.balance,
    required this.isBanned,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: (json['email'] ?? '') as String,
      role: json['role'] as String,
      balance: (json['balance'] as num).toDouble(),
      isBanned: json['is_banned'] == true,
    );
  }
}
