import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatelessWidget {
  final String hint;
  final bool isPassword;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const CustomInputField({
    Key? key,
    required this.hint,
    this.isPassword = false,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      controller: controller,
      onChanged: onChanged,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.white60, fontSize: 14),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? Icon(Icons.visibility_off, color: Colors.white60)
            : null,
      ),
    );
  }
}