import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/Materials/Editdetails.dart';
import 'package:restate/Materials/help.dart';
import 'package:restate/Materials/material.dart';
import 'package:restate/Utils/hexcolor.dart';
import 'package:restate/Utils/signOut.dart';

class MaterialsProfile extends StatefulWidget {
  const MaterialsProfile({super.key});

  @override
  State<MaterialsProfile> createState() => _MaterialsProfileState();
}

class _MaterialsProfileState extends State<MaterialsProfile> {
  final User? _user = FirebaseAuth.instance.currentUser;
  String? username;
  String? useremail = FirebaseAuth.instance.currentUser!.email;
  late DocumentReference userinfo;
  @override
  void initState() {
    getUsername();
    userinfo = FirebaseFirestore.instance
        .collection('materials')
        .doc(useremail)
        .collection('userinformation')
        .doc('userinfo');
    super.initState();
  }

  Future<String?> getUsername() async {
    try {
      var userDocument = await FirebaseFirestore.instance
          .collection('materials')
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HelpSection();
          }));
        },
        backgroundColor: HexColor('#2A2828'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        label: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.headphonesSimple,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Help",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
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
                      child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MaterialsHomeScreen(
                                initialSelectedIndex: 3,
                              );
                            }));
                          },
                          child: FaIcon(FontAwesomeIcons.box)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.02, bottom: width * 0.03),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MaterialsHomeScreen(
                              initialSelectedIndex: 3,
                            );
                          }));
                        },
                        child: Text(
                          'Your Items',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.04),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.57, bottom: width * 0.03),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MaterialsHomeScreen(
                                  initialSelectedIndex: 3,
                                );
                              }));
                            },
                            child: FaIcon(FontAwesomeIcons.angleRight))),
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
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MaterialsHomeScreen(
                            initialSelectedIndex: 1,
                          );
                        }));
                      },
                      child: FaIcon(
                        FontAwesomeIcons.cartShopping,
                        size: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: width * 0.02,
                        left: width * 0.02,
                        bottom: width * 0.02),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MaterialsHomeScreen(
                            initialSelectedIndex: 1,
                          );
                        }));
                      },
                      child: Text(
                        'Your Orders',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.04),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: width * 0.02,
                          left: width * 0.543,
                          bottom: width * 0.02),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MaterialsHomeScreen(
                                initialSelectedIndex: 1,
                              );
                            }));
                          },
                          child: FaIcon(FontAwesomeIcons.angleRight))),
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
                      FontAwesomeIcons.pen,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: width * 0.02,
                        left: width * 0.02,
                        bottom: width * 0.02),
                    child: InkWell(
                      onTap: () async {
                        DocumentSnapshot snapshot = await userinfo.get();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EditDetails(
                            snapshot: snapshot,
                          );
                        }));
                      },
                      child: Text(
                        'Edit Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.04),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: width * 0.02,
                          left: width * 0.55,
                          bottom: width * 0.02),
                      child: InkWell(
                          onTap: () async {
                            DocumentSnapshot snapshot = await userinfo.get();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return EditDetails(
                                snapshot: snapshot,
                              );
                            }));
                          },
                          child: FaIcon(FontAwesomeIcons.angleRight))),
                ]),
                Divider(
                  color: Colors.black12,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
