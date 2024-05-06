import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:restate/Builder/builderHome.dart';
import 'package:restate/Machinery/machinery.dart';
import 'package:restate/Materials/material.dart';
import 'package:restate/Utils/getuserinfo.dart';
import 'package:restate/firebase_options.dart';
import 'package:restate/screens/chooseUserType.dart';
import 'package:restate/screens/home.dart';
import 'package:restate/screens/signIn.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

late String? fcmToken;
final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
  });
  fcmToken = await FirebaseMessaging.instance.getToken();
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
        ),
        useMaterial3: true,
      ),
      home: const Begin(),
      navigatorKey: navigatorKey,
      routes: {
        MachinaryHomeScreen.route: (context) => const MachinaryHomeScreen(
              initialSelectedIndex: 1,
            ),
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
    _getlocationpermission();
    checkUserAndNavigate();
  }

  void _getlocationpermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // ignore: unused_local_variable
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<void> checkUserAndNavigate() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final email = user.email;
      var token = await FirebaseFirestore.instance
          .collection('fcmTokens')
          .doc(email)
          .get();
      if (token.exists) {
        await FirebaseFirestore.instance
            .collection('fcmTokens')
            .doc(email)
            .update({'token': fcmToken});
      } else {
        await FirebaseFirestore.instance
            .collection('fcmTokens')
            .doc(email)
            .set({'token': fcmToken});
      }
      final userRole = await UserRole.getUserRole(email!);
      if (userRole == 'Builder') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const BuilderHomeScreen(
                    initialSelectedIndex: 0,
                  )),
        );
      } else if (userRole == 'Machinery') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MachinaryHomeScreen(
                    initialSelectedIndex: 0,
                  )),
        );
      } else if (userRole == 'Material') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MaterialsHomeScreen(
                    initialSelectedIndex: 0,
                  )),
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
      backgroundColor: Colors.white,
      body: const Center(
          child: Image(
        image: AssetImage('assets/images/Appicon.png'),
        width: 100,
        height: 100,
      )),
    );
  }
}
