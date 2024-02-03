import 'package:flutter/material.dart';
import 'package:restate/Machinery/Searchpage.dart';

class MachineryHome extends StatefulWidget {
  const MachineryHome({super.key});

  @override
  State<MachineryHome> createState() => _MachineryHomeState();
}

class _MachineryHomeState extends State<MachineryHome> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.amber,
        body: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: width * 0.92,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(
                            milliseconds: 200), // Adjust the duration as needed
                        pageBuilder: (_, __, ___) => SearchPage(),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                          // You can also use other transition effects like SlideTransition, ScaleTransition, etc.
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: width * 0.92,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.search, color: Colors.grey),
                        ),
                        Text('Search', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
