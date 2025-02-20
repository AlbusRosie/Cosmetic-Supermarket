import 'package:flutter/material.dart';
import 'colors.dart';

class Button extends StatelessWidget{
  final String label;
  final VoidCallback press;
  const Button({
    super.key,
    required this.label,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
  
    // Query width and height  of device for being fit in responsive
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: size.width *.9,
      height: 55,

      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10)
      ),

      child: TextButton(
        onPressed: press, 
        child: Text(label, style: TextStyle(color: buttonText, fontSize: 18),)
      ),
    );
  }
}