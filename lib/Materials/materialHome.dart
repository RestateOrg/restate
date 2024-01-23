import 'package:flutter/material.dart';

class MaterialHome extends StatefulWidget {
  @override
  _MaterialHomeState createState() => _MaterialHomeState();
}

class _MaterialHomeState extends State<MaterialHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        body: Center(
          child: Text("Material Home"),
        ));
  }
}
