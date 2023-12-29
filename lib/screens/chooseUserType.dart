// ignore: file_names
import 'package:flutter/material.dart';
import 'package:restate/screens/builderRegistration.dart';
import 'package:restate/screens/machinaryRegistration.dart';
import 'package:restate/screens/materialsRegistation.dart';
import 'package:restate/screens/signIn.dart';
import 'hexcolor.dart';

class ChooseUser extends StatefulWidget {
  const ChooseUser({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChooseUserState createState() => _ChooseUserState();
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class _ChooseUserState extends State<ChooseUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Stack(
        children: [
          Positioned(
            left: 20,
            top: 40,
            right: 20,
            bottom: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: HexColor('#2A2828'),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            left: 50,
            top: 370,
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BuilderRegistration(),
                    ),
                  );
                },
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(90), // Make it a circle
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        15), // Center the image within the box
                    child: Image.asset(
                      'assets/images/Builder.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                )),
          ),
          Positioned(
            left: 53,
            top: 460, // Adjusted the top position of the TextButton
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BuilderRegistration(),
                  ),
                );
              },
              child: const Text(
                'Builder',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Positioned(
            left: 160,
            top: 370,
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MachinaryRegistration(),
                    ),
                  );
                },
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(90), // Make it a circle
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        15), // Center the image within the box
                    child: Image.asset(
                      'assets/images/Machine.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                )),
          ),
          Positioned(
            left: 160,
            top: 460, // Adjusted the top position of the TextButton
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BuilderRegistration(),
                  ),
                );
              },
              child: const Text(
                'Owners',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Positioned(
            right: 50,
            top: 370,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MachinaryRegistration(),
                  ),
                );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Image.asset(
                  'assets/images/Materials.png',
                  width: 90,
                  height: 90,
                ),
              ),
            ),
          ),
          Positioned(
            right: 40,
            top: 460, // Adjusted the top position of the TextButton
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MaterialRegistration(),
                  ),
                );
              },
              child: const Text(
                'Materials',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const Positioned(
            top: 270,
            left: 55,
            child: Text(
              'Select User Type',
              style: TextStyle(
                fontSize: 39,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Positioned(
            bottom: 280,
            left: 90,
            child: Text(
              "Already have an account",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          Positioned(
            bottom: 266,
            right: 94,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginView(),
                  ),
                );
              },
              child: const Text(
                'Log in',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
