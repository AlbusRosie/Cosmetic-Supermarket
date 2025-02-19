import 'package:flutter/material.dart';
import '../components/colors.dart';
import '../components/textField.dart';
import '../components/button.dart';
import '../views/signup.dart';
import '../views/profile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();

  bool isChecked = false;
  bool isLoginTrue = false;

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
                const Text(
                  "LOGIN",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),

                Image.asset(
                  "assets/login.png",
                  width: 250,
                  height: 250,
                ),

                InputField(
                    hint: "Username",
                    icon: Icons.account_circle,
                    controller: username),
                InputField(
                  hint: "Password",
                  icon: Icons.lock,
                  controller: password,
                  passwordInvisible: true,
                ),

                ListTile(
                  horizontalTitleGap: 2,
                  title: const Text("Remember me"),
                  leading: Checkbox(
                      activeColor: primaryColor,
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      }),
                ),

                Button(
                  label: "LOGIN",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()));
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Color.fromARGB(255, 93, 92, 92)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()
                          )
                        );
                      },
                      child: const Text(
                        "SIGN UP",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                // Access denied message in case when your username and password is incorrect
                // When login is not true then display the message
                isLoginTrue
                    ? Text(
                        "Username or Password is incorrect",
                        style: TextStyle(color: Colors.red.shade800),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
