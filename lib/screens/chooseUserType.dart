// ignore: file_names
import 'package:flutter/material.dart';
import 'package:restate/screens/builderRegistration.dart';
import 'package:restate/screens/machinaryRegistration.dart';
import 'package:restate/screens/materialsRegistation.dart';

class ChooseUser extends StatefulWidget {
  const ChooseUser({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChooseUserState createState() => _ChooseUserState();
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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Image.asset(
                  'assets/images/Builder.png',
                  width: 90,
                  height: 90,
                ),
              ),
            ),
          ),
          Positioned(
            left: 55,
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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Image.asset(
                  'assets/images/Machine.png',
                  width: 90,
                  height: 90,
                ),
              ),
            ),
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
            top: 200,
            left: 50,
            child: Text(
              'Select the User Type',
              style: TextStyle(
                fontSize: 35,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
