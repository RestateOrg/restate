import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/Utils/hexcolor.dart';
import 'package:restate/Utils/signOut.dart';

class BuilderProfiles extends StatefulWidget {
  const BuilderProfiles({super.key});

  @override
  State<BuilderProfiles> createState() => _BuilderProfilesState();
}

class _BuilderProfilesState extends State<BuilderProfiles> {
  final User? _user = FirebaseAuth.instance.currentUser;
  String? username;
  String? useremail = FirebaseAuth.instance.currentUser!.email;
  @override
  void initState() {
    getUsername();
    super.initState();
  }

  Future<String?> getUsername() async {
    try {
      var userDocument = await FirebaseFirestore.instance
          .collection('builders')
          .doc(_user?.email)
          .collection('userinformation')
          .doc('userinfo')
          .get();

      if (userDocument.exists) {
        // If the document exists, retrieve the username
        username = userDocument.get('fullName');
      }
    } catch (e) {
      print("Error getting username: $e");
    }
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Stack(
        children: [
          Container(
              height: width * 0.95,
              decoration: BoxDecoration(
                color: Colors.amber,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: width * 0.1, left: width * 0.05),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back)),
                        ),
                      ),
                      Flexible(
                        child: Align(
                          alignment: AlignmentDirectional(1, 0),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: width * 0.1, left: width * 0.02),
                            child: Column(
                              children: [
                                Icon(Icons.settings),
                                Text(
                                  'Settings',
                                  style: TextStyle(fontSize: 7),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: width * 0.1,
                            left: width * 0.02,
                            right: width * 0.02),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await handleSignOut(context);
                              },
                              child: FaIcon(
                                FontAwesomeIcons.doorOpen,
                                size: 23,
                              ),
                            ),
                            Text(
                              'Logout',
                              style: TextStyle(fontSize: 7),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Icon(
                            Icons.account_circle,
                            size: 130,
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(),
                          child: username != null
                              ? Text(
                                  '$username',
                                  style: TextStyle(
                                    fontSize: (username != null &&
                                            username!.length < 20)
                                        ? 20
                                        : 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  "No Name",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(),
                          child: Text(
                            '$useremail',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: width),
                  child: Row(children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.07, bottom: width * 0.03),
                      child: FaIcon(FontAwesomeIcons.productHunt),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.02, bottom: width * 0.03),
                      child: Text(
                        'Your Projects',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.04),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.52, bottom: width * 0.03),
                        child: FaIcon(FontAwesomeIcons.angleRight)),
                  ]),
                ),
                Divider(
                  color: Colors.black12,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                Row(children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: width * 0.02,
                        left: width * 0.068,
                        bottom: width * 0.02),
                    child: FaIcon(
                      FontAwesomeIcons.pen,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: width * 0.02,
                        left: width * 0.02,
                        bottom: width * 0.02),
                    child: Text(
                      'Edit Details',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: width * 0.04),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: width * 0.02,
                          left: width * 0.55,
                          bottom: width * 0.02),
                      child: FaIcon(FontAwesomeIcons.angleRight)),
                ]),
                Divider(
                  color: Colors.black12,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                Row(children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: width * 0.02,
                        left: width * 0.068,
                        bottom: width * 0.02),
                    child: FaIcon(
                      FontAwesomeIcons.solidClock,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: width * 0.02,
                        left: width * 0.02,
                        bottom: width * 0.02),
                    child: Text(
                      'Order History',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: width * 0.04),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: width * 0.02,
                          left: width * 0.52,
                          bottom: width * 0.02),
                      child: FaIcon(FontAwesomeIcons.angleRight)),
                ]),
                Divider(
                  color: Colors.black12,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.7, top: width * 0.30),
                  child: Container(
                    height: width * 0.12,
                    width: width * 0.24,
                    decoration: BoxDecoration(
                        color: HexColor('#2A2828'),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FaIcon(
                            FontAwesomeIcons.headphonesSimple,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0, bottom: 8, top: 8),
                          child: Text(
                            "Help",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
