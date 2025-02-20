import 'package:flutter/material.dart';
import '../components/colors.dart';
import '../components/textField.dart';
import '../components/button.dart';
import '../SQLite/database_helper.dart';
import '../views/login.dart';
import '../JSON/users.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers
  final username = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final db = DatabaseHelper();
  // void initState() {
  //   super.initState();
  //   // Delete existing database when the signup screen initializes
  //   _cleanDatabase();
  // }

  // Future<void> _cleanDatabase() async {
  //   await db.deleteDatabase();
  // }
  signUp() async {
    if (username.text.isEmpty ||
        phone.text.isEmpty ||
        address.text.isEmpty ||
        password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    try {
      // Create new user with all required fields
      var newUser = Users(
          uname: username.text.trim(),
          phone: phone.text.trim(),
          password: password.text.trim(),
          address: address.text.trim(),
          urole: "2", // Explicitly set role to "2" for regular users
          avt: "assets/no_user.jpg" // Set default avatar
          );

      var res = await db.createUser(newUser);
      if (!mounted) return;
      if (password.text != confirmPassword.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match!")),
        ); return;}
      if (res > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration successful!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration failed. Try again!")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

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
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: 
                    Text(
                      "SIGN UP",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ), 
                ),
                SizedBox(height: 5), // Small spacing
                Text(
                  "Please fill in this form to create an Account",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),textAlign: TextAlign.center,),
                const SizedBox(
                  height: 20,
                ),
                InputField(
                    hint: "User Name",
                    icon: Icons.person,
                    controller: username),
                InputField(
                    hint: "Phone Number",
                    icon: Icons.phone,
                    controller: phone),
                InputField(hint: "Address", icon: Icons.location_pin, controller: address),
                InputField(
                    hint: "Password", icon: Icons.lock, controller: password, passwordInvisible: true,),
                InputField(
                    hint: "Re-enter Password",
                    icon: Icons.lock,
                    controller: confirmPassword, passwordInvisible: true,),
                const SizedBox(
                  height: 10,
                ),
                Button(
                  label: "SIGN UP",
                  press: () {
                    signUp();
                  },
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
