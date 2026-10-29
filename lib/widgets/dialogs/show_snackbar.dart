import 'package:flutter/material.dart';

class ShowSnackbar {
  static showSnackbar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 10),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        content: Text(
          content,
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
