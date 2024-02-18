import 'package:flutter/material.dart';

class BuilderCart extends StatefulWidget {
  const BuilderCart({super.key});

  @override
  State<BuilderCart> createState() => _BuilderCartState();
}

class _BuilderCartState extends State<BuilderCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(child: Text('Builder Cart')),
    );
  }
}
