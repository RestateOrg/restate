import 'package:flutter/material.dart';

class MaterialsHomeScreen extends StatefulWidget {
  const MaterialsHomeScreen({super.key});

  @override
  State<MaterialsHomeScreen> createState() => _MaterialsHomeScreenState();
}

class _MaterialsHomeScreenState extends State<MaterialsHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        body: Center(
          child: Text(
            'Materials Home',
            style: TextStyle(
              fontSize: 34,
              color: Colors.white,
            ),
          ),
        ));
  }
}
