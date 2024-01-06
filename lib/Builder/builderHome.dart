import 'package:flutter/material.dart';
import 'package:restate/Utils/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BuilderHomeScreen extends StatefulWidget {
  const BuilderHomeScreen({super.key});

  @override
  State<BuilderHomeScreen> createState() => _BuilderHomeScreenState();
}

class _BuilderHomeScreenState extends State<BuilderHomeScreen> {
  int _selectedIndex = 0;
  double selectedIconScale = 1.2;
  double unselectedIconScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Text(
          'Builder Home',
          style: TextStyle(
            fontSize: 34,
            color: Colors.white,
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
                      FontAwesomeIcons.cartShopping,
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
}
