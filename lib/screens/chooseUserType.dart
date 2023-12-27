import 'package:flutter/material.dart';

class ChooseUser extends StatefulWidget {
  const ChooseUser({Key? key}) : super(key: key);

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
        ],
      ),
    );
  }
}
