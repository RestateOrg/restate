import 'package:flutter/material.dart';
import 'package:restate/screens/builderRegistration.dart';
import 'package:restate/screens/machinaryRegistration.dart';
import 'package:restate/screens/materialsRegistation.dart';
import 'package:restate/screens/signIn.dart';
import 'hexcolor.dart';

class ChooseUser extends StatefulWidget {
  const ChooseUser({Key? key});

  @override
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                borderRadius: BorderRadius.circular(height * 0.025),
              ),
            ),
          ),
          Positioned(
            left: width * 0.10,
            top: height * 0.45,
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
                width: width * 0.25,
                height: width * 0.25,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(width * 0.25),
                ),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.04),
                  child: Image.asset(
                    'assets/images/Builder.png',
                    width: width * 0.16,
                    height: width * 0.16,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: width * 0.13,
            top: height * 0.56,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BuilderRegistration(),
                  ),
                );
              },
              child: Text(
                'Builder',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            left: width * 0.39,
            top: height * 0.45,
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
                width: width * 0.25,
                height: width * 0.25,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(width * 0.25),
                ),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.04),
                  child: Image.asset(
                    'assets/images/Machine.png',
                    width: width * 0.16,
                    height: width * 0.16,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: width * 0.42,
            top: height * 0.56,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MachinaryRegistration(),
                  ),
                );
              },
              child: Text(
                'Owners',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            right: width * 0.08,
            top: height * 0.45,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MaterialRegistration(),
                  ),
                );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(width * 0.5),
                ),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.04),
                  child: Image.asset(
                    'assets/images/Materials.png',
                    width: width * 0.16,
                    height: width * 0.16,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: width * 0.08,
            top: height * 0.56,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MaterialRegistration(),
                  ),
                );
              },
              child: Text(
                'Materials',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.34,
            left: width * 0.17,
            child: Text(
              'Select User Type',
              style: TextStyle(
                fontSize: width * 0.09,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: height * 0.32,
            left: width * 0.22,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              },
              child: RichText(
                text: TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Log in',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
