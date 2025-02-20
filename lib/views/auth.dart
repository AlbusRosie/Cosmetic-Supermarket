import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/colors.dart';
import './login.dart';
import './signup.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFdfebe9),
      body: SafeArea(
        child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
              const Text(
                "Authentication",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              const Text(
                "Authentication to access your vital information",
                style: TextStyle(color: Colors.grey),
              ),
              Expanded(
                child: Image.asset(
                  "assets/auth.png", 
              )),
              Button(
                label: "LOGIN",
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
              ),
              Button(
                label: "SIGN UP",
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                },
              ),
                        ],
                      ),
            )),
      ),
    );
  }
}
