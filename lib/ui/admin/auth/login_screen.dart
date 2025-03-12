import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens.dart';
import '../shared/dialog_utils.dart';
import 'auth_manager.dart';


class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isRememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin(BuildContext context) async {
    final authManager = context.read<AuthManager>();
    try {
      await authManager.login(
        emailController.text,
        passwordController.text,
      );

      // Kiểm tra widget có còn mounted không trước khi dùng context
      if (!context.mounted) return;

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Chuyển đến màn hình chính sau khi đăng nhập
      Navigator.of(context).pushReplacementNamed(Sidebar.routeName);
    } catch (error) {
      // Kiểm tra widget có còn mounted không trước khi hiển thị dialog
      if (!context.mounted) return;
      showErrorDialog(context, error.toString());
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
                const UpsideLogin(
                  imgUrl: "assets/images/logo.png",
                ),
                const PageTitleBarLogin(title: "Login to your account!"),
                Padding(
                  padding: const EdgeInsets.only(top: 360.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        RoundedInputField(
                          hintText: "Email",
                          icon: Icons.email,
                          controller: emailController,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Container(
                            width: size.width * 0.8,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Remember me",
                                  style: TextStyle(fontSize: 15, color: color4),
                                ),
                                Transform.scale(
                                  scale: 0.7, 
                                  child: Switch(
                                    activeColor: color1,
                                    value: isRememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        isRememberMe = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Button(
                          label: "Login",
                          press: () => _submitLogin(context),
                        ),
                        const SizedBox(height: 30),
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account?   ",
                            style: const TextStyle(
                              color: color4,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: "Register here",
                                style: const TextStyle(
                                  color: color4, // Màu nâu cho chữ bấm được
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushReplacementNamed(RegisterScreen.routeName);
                                  },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          "Forget Password?",
                          style: const TextStyle(
                            color: color4, // Màu nâu cho chữ bấm được
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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
