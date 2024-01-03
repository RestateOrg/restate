import 'package:flutter/material.dart';
import 'package:restate/screens/signIn.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Stack(
        // Use Stack for layering widgets
        children: [
          Container(
              // Your background content goes here
              ),
          Positioned(
            bottom: height * 0.005,
            child: SizedBox(
              width: width,
              height: height * 0.5,
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
            top: height * 0.27,
            left: width * 0.1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(
                'assets/images/mainBack.png',
                width: width * 0.8,
                height: height * 0.35,
              ),
            ),
          ),
          Positioned(
            bottom: height * 0.20,
            left: width * 0.2,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size(
                  width * 0.6,
                  height * 0.1,
                ),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.06,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
