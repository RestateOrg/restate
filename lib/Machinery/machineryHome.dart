import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/Utils/hexcolor.dart';
import 'package:restate/screens/signIn.dart';

class MachinaryHomeScreen extends StatefulWidget {
  const MachinaryHomeScreen({super.key});

  @override
  State<MachinaryHomeScreen> createState() => _MachinaryHomeScreenState();
}

class _MachinaryHomeScreenState extends State<MachinaryHomeScreen> {
  int _selectedIndex = 0;
  double selectedIconScale = 1.2;
  double unselectedIconScale = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
          child: GestureDetector(
        onTap: () {
          _signOut(context);
        },
        child: Text(
          'machinary Home',
          style: TextStyle(
            fontSize: 34,
            color: Colors.white,
          ),
        ),
      )),
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
                      color: _selectedIndex == 0
                          ? Colors.amber
                          : Color(0xFFE8E8E8),
                    )),
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
                        _selectedIndex == 1
                            ? selectedIconScale
                            : unselectedIconScale,
                        _selectedIndex == 1
                            ? selectedIconScale
                            : unselectedIconScale,
                      ),
                    child: FaIcon(
                      FontAwesomeIcons.clipboardList,
                      color: _selectedIndex == 1
                          ? Colors.amber
                          : Color(0xFFE8E8E8),
                    )),
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
                      FontAwesomeIcons.chartColumn,
                      color: _selectedIndex == 2
                          ? Colors.amber
                          : Color(0xFFE8E8E8),
                    )),
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
                      FontAwesomeIcons.box,
                      color: _selectedIndex == 3
                          ? Colors.amber
                          : Color(0xFFE8E8E8),
                    )),
              ),
            ),
            label: '',
          ),
        ],
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
