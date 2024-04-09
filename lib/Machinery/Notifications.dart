import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/Builder/builderProfile.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

final useremail = FirebaseAuth.instance.currentUser?.email;

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Notifications"),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _fetchNotifications(),
        builder: (BuildContext context,
            AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                // Access data from each DocumentSnapshot correctly
                String title = snapshot.data![index]['notification title'];
                String notification = snapshot.data![index]['notification'];

                // Build your notification item widget here
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(70, 255, 255, 255),
                  ),
                  child: Column(children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          snapshot.data![index]['notification title'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(snapshot.data![index]['notification'])),
                  ]),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<DocumentSnapshot>> _fetchNotifications() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('machinery')
        .doc(useremail)
        .collection("Notifications")
        .get();
    return querySnapshot.docs;
  }
}
