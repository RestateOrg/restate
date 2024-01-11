import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/Materials/materialHome.dart';
import 'package:restate/Utils/signOut.dart';

class MaterialsProfile extends StatefulWidget {
  const MaterialsProfile({Key? key}) : super(key: key);

  @override
  State<MaterialsProfile> createState() => _MaterialsProfileState();
}

class _MaterialsProfileState extends State<MaterialsProfile> {
  final User? _user = FirebaseAuth.instance.currentUser;

  Future<String?> getUsername() async {
    String? username;
    try {
      var userDocument = await FirebaseFirestore.instance
          .collection('materials')
          .doc(_user?.email)
          .collection('userinformation')
          .doc('userinfo')
          .get();

      if (userDocument.exists) {
        username = userDocument.get('fullName');
      }
    } catch (e) {
      print("Error getting username: $e");
    }
    return username;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.amber,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.04,
            ),
            child: Container(
              width: width,
              height: height * 0.06,
              color: Colors.amber,
              child: Padding(
                padding:
                    EdgeInsets.only(left: width * 0.005, top: height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: width * 0.003),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MaterialsHomeScreen()));
                          },
                          child: FaIcon(
                            FontAwesomeIcons.arrowLeft,
                            color: Colors.black,
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.7),
                      child: FaIcon(
                        // ignore: deprecated_member_use
                        FontAwesomeIcons.cog,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: width * 0.02),
                        child: GestureDetector(
                          onTap: () async {
                            await handleSignOut(
                                context); // Call the function from Signout.dart
                          },
                          child: FaIcon(
                            FontAwesomeIcons.doorOpen,
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.1),
            child: Container(
              height: height * 0.3,
              width: width,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ]),
              child: Container(
                color: Colors.amber,
              ),
            ),
          ),
          if ((_user?.email?.length ?? 0) > 19)
            Padding(
              padding: EdgeInsets.only(left: width * 0.2, top: height * 0.13),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.person,
                      color: Colors.amber,
                      size: 80,
                    ),
                  ),
                  FutureBuilder<String?>(
                    future: getUsername(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return Column(
                          children: [
                            Text(
                              '${snapshot.data}',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_user?.email}',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: EdgeInsets.only(left: width * 0.33, top: height * 0.13),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.person,
                      color: Colors.amber,
                      size: 80,
                    ),
                  ),
                  FutureBuilder<String?>(
                    future: getUsername(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return Column(
                          children: [
                            Text(
                              '${snapshot.data}',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_user?.email}',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.41),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: width * 0.003),
                  child: Container(
                    width: width,
                    height: height * 0.06,
                    color: Colors.amber,
                  ),
                ),
                Divider(
                  color: Colors.black,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.003),
                  child: Container(
                    width: width,
                    height: height * 0.06,
                    color: Colors.amber,
                  ),
                ),
                Divider(
                  color: Colors.black,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.003),
                  child: Container(
                    width: width,
                    height: height * 0.06,
                    color: Colors.amber,
                  ),
                ),
                Divider(
                  color: Colors.black,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.003),
                  child: Container(
                    width: width,
                    height: height * 0.06,
                    color: Colors.amber,
                  ),
                ),
                Divider(
                  color: Colors.black,
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.003, top: height * 0.05),
            child: Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.03, top: height * 0.375),
                  child: FaIcon(
                    FontAwesomeIcons.box,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.04, top: height * 0.375),
                  child: Text(
                    'Your Items',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.6, top: height * 0.375),
                  child: FaIcon(
                    FontAwesomeIcons.angleRight,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.003, top: height * 0.05),
            child: Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.02, top: height * 0.455),
                  child: FaIcon(
                    FontAwesomeIcons.cartArrowDown,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.04, top: height * 0.455),
                  child: Text(
                    'Your Orders',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.57, top: height * 0.455),
                  child: FaIcon(
                    FontAwesomeIcons.angleRight,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.003, top: height * 0.05),
            child: Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.03, top: height * 0.544),
                  child: FaIcon(
                    FontAwesomeIcons.pen,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.04, top: height * 0.544),
                  child: Text(
                    'Edit Details',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.57, top: height * 0.544),
                  child: FaIcon(
                    FontAwesomeIcons.angleRight,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.003, top: height * 0.05),
            child: Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.03, top: height * 0.633),
                  child: FaIcon(
                    FontAwesomeIcons.solidClock,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.04, top: height * 0.633),
                  child: Text(
                    'Order History',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.53, top: height * 0.633),
                  child: FaIcon(
                    FontAwesomeIcons.angleRight,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.003, top: height * 0.005),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.789, top: height * 0.089),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8, top: height * 0.089),
                  child: GestureDetector(
                    onTap: () async {
                      await handleSignOut(
                          context); // Call the function from Signout.dart
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        // Customize the color if needed
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
