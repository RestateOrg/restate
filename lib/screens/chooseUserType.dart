import 'package:flutter/material.dart';
import 'package:restate/screens/builderRegistration.dart';
import 'package:restate/screens/machinaryRegistration.dart';
import 'package:restate/screens/materialsRegistation.dart';
import 'package:restate/screens/signIn.dart';

class ChooseUser extends StatefulWidget {
  const ChooseUser({Key? key});

  @override
  _ChooseUserState createState() => _ChooseUserState();
}

class _ChooseUserState extends State<ChooseUser> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: const Color.fromARGB(17, 253, 197, 0),
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 40,
              right: 20,
              bottom: 20,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(0, 253, 197, 0),
                  borderRadius: BorderRadius.circular(height * 0.025),
                ),
              ),
            ),
            Positioned(
              left: width * 0.10,
              top: width * 0.92,
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
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: Image.asset(
                      'assets/images/Builder.png',
                      width: width * 0.16,
                      height: width * 0.16,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: width * 0.135,
              top: width * 1.146,
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
                    color: Colors.black,
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              left: width * 0.39,
              top: width * 0.92,
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
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: Image.asset(
                      'assets/images/Machine.png',
                      width: width * 0.16,
                      height: width * 0.16,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: width * 0.42,
              top: width * 1.146,
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
                    color: Colors.black,
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              right: width * 0.08,
              top: width * 0.92,
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
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: Image.asset(
                      'assets/images/Materials.png',
                      width: width * 0.16,
                      height: width * 0.16,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: width * 0.08,
              top: width * 1.146,
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
                    color: Colors.black,
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              top: width * 0.696,
              left: width * 0.17,
              child: Text(
                'Select User Type',
                style: TextStyle(
                  fontSize: width * 0.09,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
            Positioned(
              bottom: width * 0.656,
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
                      color: Colors.black,
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
      ),
    );
  }
}
