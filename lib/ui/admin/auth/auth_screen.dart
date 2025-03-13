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
                // Background Image
                SizedBox(
                  width: size.width,
                  height: size.height / 5, // Reduce height to bring the image closer to the top
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.contain, // Prevent image stretching
                  ),
                ),
                // Back Button
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10), // Reduce top padding
                  child: IconButton(
                    color: color4,
                    iconSize: 28,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
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
