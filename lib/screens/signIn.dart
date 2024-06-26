import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restate/Builder/builderHome.dart';
import 'package:restate/Machinery/machinery.dart';
import 'package:restate/Materials/material.dart';
import 'package:restate/Utils/EmailVerify.dart';
import 'package:restate/Utils/getuserinfo.dart';
import '../firebase_options.dart';
import 'package:restate/screens/chooseUserType.dart';
import 'package:restate/Utils/resetPassword.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController email;
  late final TextEditingController password;
  bool _isPasswordVisible = false;
  bool _showLoading = false;
  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void _showDocumentIdPopup2(String documentId, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(documentId),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(
          255, 255, 233, 168), // Set the background color of the app to amber
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 20.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.black54
                      ], // Set your gradient colors
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(16.0),
                        child: Container(
                          width: 200.0,
                          height: 200.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                10.0), // You can adjust the radius as needed
                            image: const DecorationImage(
                              image: AssetImage('assets/images/mainBack.png'),
                              fit: BoxFit.cover, // Adjust the fit as needed
                            ),
                          ),
                        ),
                      ),
                      TextField(
                        controller: email,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter your email here',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(23.0),
                          ),
                          contentPadding: const EdgeInsets.all(12.0),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: password,
                        obscureText: !_isPasswordVisible,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Enter your password here',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(23.0),
                          ),
                          contentPadding: const EdgeInsets.all(12.0),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () async {
                          final _email = email.text;
                          final _password = password.text;
                          try {
                            setState(() {
                              _showLoading = true; // Set _showLoading to true
                            });
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: _email, password: _password);
                            final user = FirebaseAuth.instance.currentUser;
                            final userRole = await UserRole.getUserRole(_email);
                            SizedBox(
                              height: 50,
                              child: Text(
                                userRole.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            );
                            if (user?.emailVerified ?? false) {
                              if (userRole == 'Builder') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BuilderHomeScreen(
                                      initialSelectedIndex: 0,
                                    ),
                                  ),
                                );
                              } else if (userRole == 'Material') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MaterialsHomeScreen(
                                      initialSelectedIndex: 0,
                                    ),
                                  ),
                                );
                              } else if (userRole == 'Machinery') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MachinaryHomeScreen(
                                      initialSelectedIndex: 0,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VerificationPage(email: _email)));
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == "user-not-found") {
                              _showDocumentIdPopup2(
                                  "There is no account existing with this email",
                                  "No User Found");
                            }
                            if (e.code == "wrong-password") {
                              _showDocumentIdPopup2(
                                  "The Password You have Entered Is Incorrect",
                                  "Incorrect Password");
                            }
                            if (e.code == "network-request-failed") {
                              _showDocumentIdPopup2(
                                  "Please check your internet connection",
                                  "No Internet Connection");
                            }
                            print(e.code);
                          } finally {
                            setState(() {
                              _showLoading = false; // Set _showLoading to false
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Login',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Builder(builder: (context) {
                              return _showLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : SizedBox();
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChooseUser(),
                            ),
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontFamily: 'Roboto'),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign up',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPassword(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
