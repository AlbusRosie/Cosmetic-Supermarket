import 'package:flutter/material.dart';
import '../../screens.dart';


class WelcomeScreen extends StatelessWidget {
  static const routeName = '/welcome';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 40),
            decoration: BoxDecoration(
              color: color2.withAlpha((0.6 * 255).toInt()), 
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Larana",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: color4,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  '"Discover the beauty within."',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: color7,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  child: Button(
                    label: "Register",
                    press: () {
                      Navigator.pushNamed(context, RegisterScreen.routeName);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 250,
                  child: Button(
                    label: "Login",
                    press: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
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
