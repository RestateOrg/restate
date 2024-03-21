import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restate/Builder/Upload_project.dart';
import 'package:restate/Builder/builderCart.dart';
import 'package:restate/Builder/builderMachine.dart';
import 'package:restate/Builder/builderMaterials.dart';
import 'package:restate/Builder/builderProfile.dart';
import 'package:restate/Builder/mainBuilderHome.dart';
import 'package:restate/Utils/Notificatuons.dart';
import 'package:restate/Utils/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BuilderHomeScreen extends StatefulWidget {
  final int initialSelectedIndex;
  const BuilderHomeScreen({required this.initialSelectedIndex});

  @override
  State<BuilderHomeScreen> createState() => _BuilderHomeScreenState();
}

class _BuilderHomeScreenState extends State<BuilderHomeScreen> {
  List<int> screenOrder = [0, 1, 2, 3];
  int _selectedIndex = 0;
  double selectedIconScale = 1.2;
  double unselectedIconScale = 1.0;

  final User = FirebaseAuth.instance.currentUser;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedIndex = widget.initialSelectedIndex;
    });
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadProject()),
            );
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
                child: Text(
                  "New",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                  ),
                ),
              )
            ],
          ),
          backgroundColor: HexColor('#242424'),
          foregroundColor: Colors.white,
        ),
      ),
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: width * 0.73),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuilderProfiles(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.person,
                  color: Colors.amber,
                  size: 25,
                ),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(right: width * 0.03),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notifications()),
                  );
                },
                child: FaIcon(
                  FontAwesomeIcons.solidBell,
                  color: Colors.black,
                ),
              )),
          Padding(
            padding: EdgeInsets.only(right: 13),
            child: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: FaIcon(
                    FontAwesomeIcons.bars,
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          handleNavigation(index);
        },
        children: [
          MainBuilderHome(),
          BuilderMachine(),
          BuilderMaterials(),
          BuilderCart(),
        ],
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
                onTap: () => handleNavigation(0),
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
                onTap: () => handleNavigation(1),
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
                onTap: () => handleNavigation(2),
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
                onTap: () => handleNavigation(3),
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
        onTap: (index) {
          handleNavigation(index);
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
      endDrawer: CustomDrawer(
        handleNavigation: handleNavigation,
      ),
    );
  }

  void handleNavigation(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _pageController.jumpToPage(0);
          break;
        case 1:
          _pageController.jumpToPage(1);
          break;
        case 2:
          _pageController.jumpToPage(2);
          break;
        case 3:
          _pageController.jumpToPage(3);
          break;
        default:
          break;
      }
    });
  }
}

class CustomDrawer extends StatelessWidget {
  final Function(int) handleNavigation;

  CustomDrawer({required this.handleNavigation});
  // ignore: non_constant_identifier_names
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

    return Drawer(
      width: width * 0.80,
      child: FutureBuilder<String?>(
        future: getUsername(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
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
                                  builder: (context) => BuilderProfiles(),
                                ),
                              );
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
                    handleNavigation(
                        0); // Navigate to the first page (MainBuilderHome)
                    Navigator.pop(context);
                  },
                ),
                Divider(
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
                    handleNavigation(1);
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
                    handleNavigation(2);
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
                    handleNavigation(3);
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
                  color: Colors.black,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                ListTile(
                  leading: FaIcon(
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
    );
  }
}
