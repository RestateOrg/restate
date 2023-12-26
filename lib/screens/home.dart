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
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              width: 100,
              height: 100,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(70.0),
              child: Image.asset(
                'assets/images/mainBack.png',
                width: 250,
                height: 280,
              ),
            ),
            const SizedBox(
              width: 50,
              height: 60,
            ),
            SizedBox(
              width: 500,
              height: 450,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.amber.withOpacity(0.5),
                  BlendMode.dstATop,
                ),
                child: Image.asset(
                  'assets/images/backMat.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            /* Positioned(
              top: 15,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the next page on button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignIn()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
