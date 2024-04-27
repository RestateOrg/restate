import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';

class ProjectDetails extends StatefulWidget {
  final Map<String, dynamic> data;
  const ProjectDetails({Key? key, required this.data}) : super(key: key);

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  int currentIndex = 0;
  String useremail = FirebaseAuth.instance.currentUser!.email!;
  List<QueryDocumentSnapshot> deliverySnapshots = [];
  int selectedIndex = 0;
  void initState() {
    super.initState();
    getfcm();
  }

  String fcm = '';

  void getfcm() {
    FirebaseFirestore.instance
        .collection('fcmTokens')
        .doc(widget.data['email'])
        .get()
        .then((value) {
      setState(() {
        fcm = value['token'];
      });
    });
  }

  @override
  void dispose() {
    DefaultCacheManager().emptyCache();
    super.dispose();
  }

  Future<void> requestsent() async {
    await FirebaseFirestore.instance
        .collection('builders')
        .doc(widget.data['email'])
        .collection("Requests")
        .doc()
        .set({
      'requested project': widget.data,
      'status': 'pending',
      'builderemail': widget.data['email'],
      'requesteremail': useremail,
      'timestamp': DateTime.now(),
    });
    await sendNotificationToSeller(fcm);
    await notifications();
  }

  Future<void> notifications() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference projectRef = firestore
        .collection('builders')
        .doc(widget.data['useremail'])
        .collection('Notifications')
        .doc();
    projectRef.set({
      'notification title': "New Project Request Received",
      'notification': "You have Received Order Request from a user",
      'timestamp': DateTime.now(),
    });
  }

  Future<void> sendNotificationToSeller(String sellerToken) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAAXgFwBw:APA91bGwgMQf4NheYj-SfYBLTWxiUA00k7RgPzC4sRzjMTpH-Yhyvx1ni_v1RHYnyy4XxB3iX1IpB2DUV18DU_tfDypKtF6Prw3RnKUzha4IHGsI6dyuNdCpUv9r8GfbsKgp58KDD-yN', // Replace with your Firebase server key
    };
    final payload = {
      'notification': {
        'title': 'New Project Request Received',
        'body': 'A new project Request has been placed by a user.',
      },
      'to': sellerToken,
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode(payload));
    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color.fromARGB(231, 255, 255, 255),
        appBar: AppBar(
          title: Text('Project Info'),
          backgroundColor: Colors.amber,
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () async {
            await requestsent();
          },
          child: Container(
            height: 70,
            color: Colors.amber,
            child: Center(
                child: Text(
              "Request Quote",
              style: TextStyle(color: Colors.white, fontSize: 16),
            )),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 300,
                      width: width,
                      child: SizedBox(
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: widget.data['imageURl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(),
                child: Container(
                  width: width,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 10, bottom: 10),
                            child: Text(
                              widget.data['projectname'],
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Container(
                    width: width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Project Info',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'From Date: ${widget.data['fromdate']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'To Date: ${widget.data['todate']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'City : ${widget.data['city']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'State: ${widget.data['state']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Country: ${widget.data['country']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 8.0,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Site Conditions: ${widget.data['siteconditions']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Delivery And Pickup : ${widget.data['deliveryandpickup']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Location : ${widget.data['location']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Container(
                    width: width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Project Description',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.data['projectdescription'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Container(
                    width: width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Project Requirements',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                widget.data['project requirements'].length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8.0, right: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              widget.data[
                                                      'project requirements']
                                                  [index]['Item Name'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(widget
                                                  .data['project requirements']
                                                      [index]
                                                  .containsKey('Quantity')
                                              ? "Quantity: ${widget.data['project requirements'][index]['Quantity']} "
                                              : "Duration: ${widget.data['project requirements'][index]['Duration']} "),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(widget
                                                  .data['project requirements']
                                                      [index]
                                                  .containsKey(
                                                      'Price Willing to Pay')
                                              ? "Price will pay: ${widget.data['project requirements'][index]['Price Willing to Pay']}"
                                              : "Delivery Date: ${widget.data['project requirements'][index]['Delivery Date']}"),
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
