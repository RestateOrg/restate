import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/Builder/builderProfile.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
          Text('Notifications'),
          Padding(
            padding: EdgeInsets.only(right: 15),
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
      body: Container(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
