import 'package:flutter/material.dart';
import 'package:restate/screens/signIn.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Stack(
        // Use Stack for layering widgets
        children: [
          Container(
              // Your background content goes here
              ),
          Positioned(
            bottom: 20,
            child: SizedBox(
              width: 420,
              height: 430,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.amber.withOpacity(0.5),
                  BlendMode.dstATop,
                ),
                child: Image.asset(
                  'assets/images/backMat.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
              top: 140,
              left: 55,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  'assets/images/mainBack.png',
                  width: 300,
                  height: 280,
                ),
              )),
          Positioned(
            bottom: 170,
            left: 87,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(250, 70)),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white,
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
