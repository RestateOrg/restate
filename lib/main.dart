import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restate/firebase_options.dart';
import 'package:restate/screens/chooseUserType.dart';
import 'package:restate/screens/home.dart';
import 'package:restate/screens/signIn.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GetStarted(),
      routes: {
        '/Getstarted/': (context) => const GetStarted(),
        '/login/': (context) => const LoginView(),
        '/ChooseUser/': (context) => const ChooseUser(),
      },
    );
  }
}

class Begin extends StatelessWidget {
  const Begin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser ?? false;
              if (user != false) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login/', (route) => false);
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/Getstarted/', (route) => false);
              }
              return const Text("Done");
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
