import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool passwordInvisible;
  final TextEditingController controller;

  const InputField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.passwordInvisible = false,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      width: size.width*.9,
      height: 55,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 183, 209, 205),
        borderRadius: BorderRadius.circular(8),
      ),

    child: Center(
      child: TextFormField(
        obscureText: passwordInvisible,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          icon: Icon(icon)
        ),
      ),
    ),

    );
  }
}

