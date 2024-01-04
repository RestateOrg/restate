import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restate/Builder/builderHome.dart';
import 'package:restate/Machinery/machineryHome.dart';
import 'package:restate/Materials/materialHome.dart';
import 'package:restate/Utils/getuserinfo.dart';
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
      title: 'Restate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Begin(),
      routes: {
        '/Getstarted/': (context) => const GetStarted(),
        '/login/': (context) => const LoginView(),
        '/ChooseUser/': (context) => const ChooseUser(),
      },
    );
  }
}

class Begin extends StatefulWidget {
  const Begin({super.key});

  @override
  _BeginState createState() => _BeginState();
}

class _BeginState extends State<Begin> {
  @override
  void initState() {
    super.initState();
    checkUserAndNavigate();
  }

  Future<void> checkUserAndNavigate() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final email = user.email;
      final userRole = await UserRole.getUserRole(email!);

      if (userRole == 'Builder') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BuilderHomeScreen()),
        );
      } else if (userRole == 'Machinery') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MachinaryHomeScreen()),
        );
      } else if (userRole == 'Material') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MaterialsHomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GetStarted()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GetStarted()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
