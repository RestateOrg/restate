// ignore: file_names
import 'package:flutter/material.dart';
import 'package:restate/screens/chooseUserType.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Stack(
        children: [
          Positioned(
            left: 20,
            top: 50,
            right: 20,
            bottom: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 75,
            child: SizedBox(
              width: 250,
              height: 400,
              child: Image.asset(
                'assets/images/mainBack.png',
              ),
            ),
          ),
          const Positioned(
            bottom: 90,
            left: 50,
            child: Text(
              "Don't have an account?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          Positioned(
            bottom: 82,
            left: 255,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChooseUser()),
                );
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
