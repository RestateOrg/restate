import 'package:flutter/material.dart';

class BuilderRegistration extends StatefulWidget {
  const BuilderRegistration({super.key});

  @override
  State<BuilderRegistration> createState() => _BuilderRegistrationState();
}

class _BuilderRegistrationState extends State<BuilderRegistration> {
  @override
  Widget build(BuildContext context) {
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
