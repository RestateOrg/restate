// ignore: file_names
import 'package:flutter/material.dart';

class MachinaryRegistration extends StatefulWidget {
  const MachinaryRegistration({super.key});

  @override
  State<MachinaryRegistration> createState() => _MachinaryRegistrationState();
}

class _MachinaryRegistrationState extends State<MachinaryRegistration> {
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
