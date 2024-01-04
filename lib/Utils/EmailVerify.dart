import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool isVerified = false;
  late Timer verificationTimer;

  @override
  void initState() {
    super.initState();
    verificationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkVerificationStatus();
    });
  }

  void sendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent')),
      );
    } catch (e) {}
  }

  void checkVerificationStatus() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (isVerified) {
        verificationTimer.cancel();
        Navigator.pop(context); // Close verification page
      }
    } catch (e) {
      // Handle verification errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'A verification email has been sent to ${widget.email}. Please check your inbox and click the verification link.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.currentUser!
                      .sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verification email resent')),
                  );
                } catch (e) {}
              },
              child: const Text('Resend Email'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber, // Set the background color
                foregroundColor: Colors.black, // Set the text color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30.0), // Set the border radius
                ),
                padding: EdgeInsets.all(16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
