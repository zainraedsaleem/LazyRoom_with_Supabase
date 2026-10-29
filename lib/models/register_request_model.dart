class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String buildingNumber;
  final String roomNumber;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.buildingNumber,
    required this.roomNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'room_number': roomNumber,
      'building': buildingNumber,
    };
  }
}
