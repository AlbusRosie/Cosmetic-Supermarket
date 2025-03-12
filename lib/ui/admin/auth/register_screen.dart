import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens.dart';
import '../shared/dialog_utils.dart';
import 'auth_manager.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}


class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitRegister(BuildContext context) async {
  if (passwordController.text != confirmpasswordController.text) {
    showErrorDialog(context, "Passwords do not match!");
    return;
  }

  final authManager = context.read<AuthManager>();
  try {
    await authManager.signup(
      usernameController.text,
      emailController.text,
      phoneController.text,
      passwordController.text,
    );

    if (!context.mounted) return;

    // Hiển thị thông báo đăng ký thành công
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration successful! Please login.')),
    );

    await Future.delayed(const Duration(seconds: 1));

    if (!context.mounted) return;

    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  } catch (error) {
    if (!context.mounted) return;

    // Nếu lỗi là số điện thoại trùng, hiển thị Snackbar
    String errorMessage = error.toString();
    if (errorMessage.contains("Phone number is existed!")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number is existed!')),
      );
    } else {
      showErrorDialog(context, errorMessage);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: color17,
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                const UpsideRegister(
                  imgUrl: "assets/images/logo.png",
                ),
                const PageTitleBarRegister(title: "Register new account!"),
                Padding(
                  padding: const EdgeInsets.only(top: 310.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        RoundedInputField(
                          hintText: "User Name",
                          icon: Icons.person,
                          controller: usernameController,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 10),
                        RoundedInputField(
                          hintText: "Email",
                          icon: Icons.email,
                          controller: emailController,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 10),
                        RoundedInputField(
                          hintText: "Phone",
                          icon: Icons.phone,
                          controller: phoneController,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 10),
                        RoundedInputField(
                          hintText: "Password",
                          icon: Icons.lock,
                          controller: passwordController,
                          passwordInvisible: true,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 10),
                        RoundedInputField(
                          hintText: "Confirm Password",
                          icon: Icons.lock_reset,
                          controller: confirmpasswordController,
                          confirmpasswordInvisible: true,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 10),
                        Button(
                          label: "Register",
                          press: () => _submitRegister(context),
                        ),
                        const SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            text: "Already have an account?   ",
                            style: const TextStyle(
                              color: color4,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: "Login here",
                                style: const TextStyle(
                                  color:
                                      color4, 
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
