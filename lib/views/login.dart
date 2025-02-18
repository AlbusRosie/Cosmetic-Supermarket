import 'package:flutter/material.dart';
import '../components/colors.dart';
import '../components/textField.dart';
import '../components/button.dart';
import '../views/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
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
              leading: Checkbox( activeColor: primaryColor, value: isChecked, onChanged: (value){
                setState(() {
                  isChecked = !isChecked;
                });
              }),
            ),

            Button(label: "LOGIN", press: (){},),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?", style: TextStyle(color: Color.fromARGB(255, 93, 92, 92)),),
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                  }, 
                  child: Text(
                    "SIGN UP", 
                    style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
