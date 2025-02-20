import 'package:ct312h_project/views/login.dart';
import 'package:flutter/material.dart';
import '../components/colors.dart';
import '../components/textField.dart';
import '../components/button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers
  final fullname = TextEditingController();
  final email = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Register New Account",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 45,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InputField(
                    hint: "Full Name",
                    icon: Icons.person,
                    controller: fullname),
                InputField(hint: "Email", icon: Icons.email, controller: email),
                InputField(
                    hint: "User Name",
                    icon: Icons.account_circle,
                    controller: username),
                InputField(
                    hint: "Password", icon: Icons.lock, controller: password),
                InputField(
                    hint: "Re-enter Password",
                    icon: Icons.lock,
                    controller: confirmPassword),
                const SizedBox(
                  height: 10,
                ),
                Button(
                  label: "SIGN UP",
                  press: () {},
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Color.fromARGB(255, 93, 92, 92)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text(
                        "LOG IN",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
