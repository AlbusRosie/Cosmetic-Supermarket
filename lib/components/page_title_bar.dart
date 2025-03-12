import 'package:flutter/material.dart';
import '../ui/screens.dart';

class PageTitleBarLogin extends StatelessWidget{
  const PageTitleBarLogin({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 300.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 4,
        decoration: const BoxDecoration(
          color: color17,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              color: color4,
            ),
          ),
        ),
      ),
    );
  }
}

class PageTitleBarRegister extends StatelessWidget {
  const PageTitleBarRegister({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 250.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 4,
        decoration: const BoxDecoration(
          color: color17,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              color: color4,
            ),
          ),
        ),
      ),
    );
  }
}
