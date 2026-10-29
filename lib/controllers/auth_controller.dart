import 'package:flutter/material.dart';

class AuthController {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final buildingNumbercontroller = TextEditingController();
  final roomNumbercontroller = TextEditingController();

  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    namecontroller.dispose();
    buildingNumbercontroller.dispose();
    roomNumbercontroller.dispose();
  }
}
