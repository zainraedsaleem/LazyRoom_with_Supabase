import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final bool isInt;
  final TextEditingController controller;
  final IconData? icon;

  const LoginTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.isInt = false,
    this.icon,
  });

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 50,
        child: TextFormField(
          controller: widget.controller,

          keyboardType: widget.isInt
              ? TextInputType.number
              : TextInputType.text,

          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
          ),

          decoration: InputDecoration(
            filled: true,

            fillColor: isDark
                ? Theme.of(context).colorScheme.surface
                : Colors.white,

            prefixIcon: widget.icon != null
                ? Icon(widget.icon, color: Colors.orange.shade400)
                : null,

            labelText: widget.labelText,

            labelStyle: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),

            floatingLabelStyle: TextStyle(
              color: Colors.orange.shade400,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),

            hintText: widget.hintText,

            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),

            contentPadding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),

              borderSide: BorderSide(
                color: isDark ? Colors.white.withOpacity(0.08) : Colors.black12,
                width: 1.2,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),

              borderSide: BorderSide(color: Colors.orange.shade400, width: 1.8),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),

              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),

              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
