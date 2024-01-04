import 'package:flutter/material.dart';

class BuilderHomeScreen extends StatefulWidget {
  const BuilderHomeScreen({super.key});

  @override
  State<BuilderHomeScreen> createState() => _BuilderHomeScreenState();
}

class _BuilderHomeScreenState extends State<BuilderHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        body: Center(
          child: Text(
            'Builder Home',
            style: TextStyle(
              fontSize: 34,
              color: Colors.white,
            ),
          ),
        ));
  }
}
