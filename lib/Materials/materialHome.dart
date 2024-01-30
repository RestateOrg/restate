import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MaterialHome extends StatefulWidget {
  @override
  _MaterialHomeState createState() => _MaterialHomeState();
}

class _MaterialHomeState extends State<MaterialHome> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.amber,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Container(
                width: width * 0.92,
                child: CupertinoSearchTextField(
                  backgroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  padding: EdgeInsets.all(10),
                ),
              ),
            ),
          ],
        ));
  }
}
