import 'package:flutter/material.dart';
import '../../../components/colors.dart';
import 'auth_card.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Background Image with Padding
                Padding(
                  padding: const EdgeInsets.only(top: 40), // Cách top 40px
                  child: SizedBox(
                    width: size.width,
                    height: size.height / 3.5, // Điều chỉnh chiều cao logo
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // Back Button
                Positioned(
                  top: 50, // Điều chỉnh vị trí nút back
                  left: 10,
                  child: IconButton(
                    color: color4,
                    iconSize: 28,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            const AuthCard(),
          ],
        ),
      ),
    );
  }
}
