import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/Materials/materialProfile.dart';
import 'package:restate/Utils/hexcolor.dart';
import 'package:restate/screens/signIn.dart';

class MaterialsHomeScreen extends StatefulWidget {
  const MaterialsHomeScreen({super.key});

  @override
  State<MaterialsHomeScreen> createState() => _MaterialsHomeScreenState();
}

class _MaterialsHomeScreenState extends State<MaterialsHomeScreen> {
  int _selectedIndex = 0;
  double selectedIconScale = 1.2;
  double unselectedIconScale = 1.0;

  final User = FirebaseAuth.instance.currentUser;

  Future<String?> getUsername() async {
    String? username;
    try {
      var userDocument = await FirebaseFirestore.instance
          .collection('materials')
          .doc(User!.email)
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
    return username;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: Container(
        width: 100,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          onPressed: () {},
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: width * 0.05),
                child: Icon(Icons.add),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.02,
                ),
                child: Text("New",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                    )),
              )
            ],
          ), // Replace with your desired icon
          backgroundColor: HexColor('#242424'),
          foregroundColor: Colors.white,
          // Customize button color
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.account_circle, size: 35),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MaterialsProfile()));
          },
        ),
      ),
      backgroundColor: Colors.amber,
      body: Center(
        child: GestureDetector(
          onTap: () {},
          child: Text(
            'material home',
            style: TextStyle(
              fontSize: 34,
              color: Colors.white,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: TextStyle(fontSize: 0),
        unselectedLabelStyle: TextStyle(fontSize: 0),
        backgroundColor: HexColor('#242424'),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = 0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  transform: Matrix4.identity()
                    ..scale(
                      _selectedIndex == 0
                          ? selectedIconScale
                          : unselectedIconScale,
                      _selectedIndex == 0
                          ? selectedIconScale
                          : unselectedIconScale,
                    ),
                  child: FaIcon(
                    FontAwesomeIcons.houseChimney,
                    color:
                        _selectedIndex == 0 ? Colors.amber : Color(0xFFE8E8E8),
                  ),
                ),
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = 1),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  transform: Matrix4.identity()
                    ..scale(
                      _selectedIndex == 1
                          ? selectedIconScale
                          : unselectedIconScale,
                      _selectedIndex == 1
                          ? selectedIconScale
                          : unselectedIconScale,
                    ),
                  child: FaIcon(
                    FontAwesomeIcons.clipboardList,
                    color:
                        _selectedIndex == 1 ? Colors.amber : Color(0xFFE8E8E8),
                  ),
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = 2),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  transform: Matrix4.identity()
                    ..scale(
                      _selectedIndex == 2
                          ? selectedIconScale
                          : unselectedIconScale,
                      _selectedIndex == 2
                          ? selectedIconScale
                          : unselectedIconScale,
                    ),
                  child: FaIcon(
                    FontAwesomeIcons.chartColumn,
                    color:
                        _selectedIndex == 2 ? Colors.amber : Color(0xFFE8E8E8),
                  ),
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = 3),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  transform: Matrix4.identity()
                    ..scale(
                      _selectedIndex == 3
                          ? selectedIconScale
                          : unselectedIconScale,
                      _selectedIndex == 3
                          ? selectedIconScale
                          : unselectedIconScale,
                    ),
                  child: FaIcon(
                    FontAwesomeIcons.box,
                    color:
                        _selectedIndex == 3 ? Colors.amber : Color(0xFFE8E8E8),
                  ),
                ),
              ),
            ),
            label: '',
          ),
        ],
      ),
      endDrawer: Drawer(
        width: width * 0.80,
        child: FutureBuilder<String?>(
          future: getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -20,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              child: FaIcon(
                                // ignore: deprecated_member_use
                                FontAwesomeIcons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MaterialsProfile()));
                              },
                              child: Icon(
                                Icons.account_circle,
                                color: Colors.amber,
                                size: 60,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' Welcome,',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '  ${snapshot.data}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.houseChimney,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Home',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.clipboardList,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Orders',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.chartColumn,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Dash Board',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.box,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Inventory',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.moneyBill,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Your Revenue',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.gears,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

void _signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  } catch (e) {
    print("Error signing out: $e");
  }
}
