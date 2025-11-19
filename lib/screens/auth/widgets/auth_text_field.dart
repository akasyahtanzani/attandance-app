import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
final TextEditingController controller;
final String label;
final IconData icon;
final bool obscuretext;
final Widget? suffixicon;
final TextInputType? keyboardType;
final String? Function (String?)? validator;

  const AuthTextField({super.key, required this.controller, required this.label, required this.icon, required this.obscuretext, this.suffixicon, this.keyboardType, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscuretext,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[600]),
        suffixIcon: suffixicon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12)
        ),
        filled: true,
        fillColor: Colors.grey[50]
      ),
      validator: validator,
    );
  }
}