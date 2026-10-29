import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PasswordTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;

  const PasswordTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Container(
        height: 50,
        child: TextFormField(
          controller: widget.controller,

          obscureText: isHidden,

          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
          ),

          decoration: InputDecoration(
            filled: true,

            fillColor: isDark
                ? Theme.of(context).colorScheme.surface
                : Colors.white,

            prefixIcon: Icon(Icons.lock_outline, color: Colors.orange.shade400),

            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isHidden = !isHidden;
                });
              },

              icon: Icon(
                isHidden ? PhosphorIconsBold.eyeClosed : PhosphorIconsBold.eye,
                color: isDark ? Colors.grey.shade400 : Colors.black54,
              ),
            ),

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
