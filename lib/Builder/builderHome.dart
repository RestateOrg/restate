import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restate/Builder/Upload_project.dart';
import 'package:restate/Builder/builderProfile.dart';
import 'package:restate/Utils/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/screens/signIn.dart';

class BuilderHomeScreen extends StatefulWidget {
  const BuilderHomeScreen({Key? key}) : super(key: key);

  @override
  State<BuilderHomeScreen> createState() => _BuilderHomeScreenState();
}

class _BuilderHomeScreenState extends State<BuilderHomeScreen> {
  int _selectedIndex = 0;
  double selectedIconScale = 1.2;
  double unselectedIconScale = 1.0;

  final User = FirebaseAuth.instance.currentUser;

  Future<String?> getUsername() async {
    String? username;
    try {
      var userDocument = await FirebaseFirestore.instance
          .collection('builders')
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
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UploadProject()));
          },
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
      backgroundColor: Colors.amber,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            _signOut(context);
          },
          child: Text(
            'Builder Home',
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
              padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
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
              padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = 1),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  transform: Matrix4.identity()
                    ..scale(
                      _selectedIndex == 1 ? 1.1 : unselectedIconScale,
                      _selectedIndex == 1 ? 1.1 : unselectedIconScale,
                    ),
                  child: Image.asset(
                    width: 39.0,
                    height: 39.0,
                    _selectedIndex == 1
                        ? 'assets/images/machinery2.png'
                        : 'assets/images/machinery.png',
                  ),
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
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
                    FontAwesomeIcons.boxArchive,
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
              padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
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
                    FontAwesomeIcons.cartShopping,
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
              // If the Future is still running, show a loading indicator
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If there is an error, display the error message
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
                                            BuilderProfiles()));
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
                      // ignore: deprecated_member_use
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
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  Divider(
                    // Divider here
                    color: Colors.black,
                    thickness: 0,
                    indent: 0,
                    endIndent: 0,
                  ),
                  ListTile(
                    leading: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        'assets/images/machinery.png',
                        width: 30,
                        height: 40,
                      ),
                    ),
                    title: Text(
                      'Machinery',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // Handle onTap action
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  Divider(
                    // Divider here
                    color: Colors.black,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.boxArchive,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Materials',
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
                    // Divider here
                    color: Colors.black,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.cartShopping,
                      color: Colors.black,
                    ),
                    title: Text(
                      'My Cart',
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
                    // Divider here
                    color: Colors.black,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.clipboard,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Projects',
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
                    // Divider here
                    color: Colors.black,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  ListTile(
                    leading: FaIcon(
                      // ignore: deprecated_member_use
                      FontAwesomeIcons.cogs,
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
                      // Handle the onTap action for Settings
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  Divider(
                    // Divider here
                    color: Colors.black,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                  // Add more ListTiles for additional menu items
                ],
              );
            }
          },
        ),
      ),
    );
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
}
