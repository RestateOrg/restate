import 'package:flutter/material.dart';

class BuilderRegistration extends StatefulWidget {
  const BuilderRegistration({super.key});

  @override
  State<BuilderRegistration> createState() => _BuilderRegistrationState();
}

class _BuilderRegistrationState extends State<BuilderRegistration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            print('Menu icon pressed');
          },
          iconSize: 40,
        ),
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.amber,
    );
  }
}
