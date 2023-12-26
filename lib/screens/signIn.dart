// ignore: file_names
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.amber,
      body: Stack(
        children: [
          Positioned(
              left: 20,
              top: 20,
              right: 20,
              bottom: 20,
              child: SizedBox(
                width: 500,
                height: 600,
                child: ColoredBox(color: Colors.black),
              ))
        ],
      ),
    );
  }
}
