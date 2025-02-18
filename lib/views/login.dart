import 'package:flutter/material.dart';
import '../components/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("LOGIN", style: TextStyle(color: primaryColor, fontSize: 40, fontWeight: FontWeight.bold),),
            Image.asset("assets/market.png")
          ],
        ),
      ),
    );
  }
}