import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MachineryHome extends StatefulWidget {
  const MachineryHome({super.key});

  @override
  State<MachineryHome> createState() => _MachineryHomeState();
}

class _MachineryHomeState extends State<MachineryHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        body: CupertinoSearchTextField(
          backgroundColor: Colors.white,
          borderRadius: BorderRadius.circular(30),
          padding: EdgeInsets.all(10),
        ));
  }
}
