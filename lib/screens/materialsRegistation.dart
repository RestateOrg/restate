// ignore: file_names
import 'package:flutter/material.dart';

class MaterialRegistration extends StatefulWidget {
  const MaterialRegistration({super.key});

  @override
  State<MaterialRegistration> createState() => _MaterialRegistrationState();
}

class _MaterialRegistrationState extends State<MaterialRegistration> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {},
          iconSize: height * 0.056,
        ),
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.amber,
    );
  }
}
