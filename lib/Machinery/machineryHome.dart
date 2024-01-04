import 'package:flutter/material.dart';

class MachinaryHomeScreen extends StatefulWidget {
  const MachinaryHomeScreen({super.key});

  @override
  State<MachinaryHomeScreen> createState() => _MachinaryHomeScreenState();
}

class _MachinaryHomeScreenState extends State<MachinaryHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        body: Center(
          child: Text(
            'machinary Home',
            style: TextStyle(
              fontSize: 34,
              color: Colors.white,
            ),
          ),
        ));
  }
}
