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
      width: size.width *.8,
      height: 55,

      decoration: BoxDecoration(
        color: color4,
        borderRadius: BorderRadius.circular(50)
      ),

      child: TextButton(
        onPressed: press, 
        child: Text(label, style: TextStyle(color: color13, fontSize: 18),)
      ),
    );
  }
}