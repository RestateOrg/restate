import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restate/Builder/projectinfo.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class YourProjects extends StatefulWidget {
  const YourProjects({super.key});

  @override
  State<YourProjects> createState() => _YourProjectsState();
}

class _YourProjectsState extends State<YourProjects> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String useremail; // Use 'late' to initialize later
  late CollectionReference collectionRef; // Initialize later as well
  List<DocumentSnapshot> allSnapshots = [];
  List<DocumentSnapshot> filteredSnapshots = [];
  CollectionReference CollectionRef =
      FirebaseFirestore.instance.collection('materials_inventory');

  @override
  void initState() {
    super.initState();
    useremail =
        FirebaseAuth.instance.currentUser?.email ?? ''; // Assign in initState
    collectionRef =
        firestore.collection('builders').doc(useremail).collection('Projects');
    fetchData();
    // Fetch data after initialization
  }

  void dispose() {
    DefaultCacheManager().emptyCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const Duration delay = Duration(milliseconds: 3);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Your Projects'),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: width,
            color: Colors.amber,
            child: Container(
              margin: EdgeInsets.all(8),
              width: width * 0.92,
              child: CupertinoSearchTextField(
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(30),
                padding: EdgeInsets.all(10),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      // If the search query is empty, show all items
                      filteredSnapshots = allSnapshots; // Use the normal list
                    } else {
                      // filter the list based on Material_type
                      filteredSnapshots = allSnapshots
                          .where((element) => (element.data()
                                  as Map<String, dynamic>)['projectname']
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    }
                  });
                },
              ),
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.03),
                child: Text(
                  "Your Projects",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                Future.delayed(delay, () {
                  setState(() {
                    collectionRef = firestore
                        .collection('builders')
                        .doc(useremail)
                        .collection('Projects');
                    fetchData();
                  });
                });
              },
              child: ListView.builder(
                itemCount: filteredSnapshots.length,
                itemBuilder: (context, index) {
                  final snapshot = filteredSnapshots[index];
                  int length =
                      (snapshot.data() as Map<String, dynamic>)['projectname']
                          .length;
                  return Container(
                    width: width,
                    color: index % 2 != 0
                        ? const Color.fromARGB(40, 253, 197, 0)
                        : Colors.white,
                    child: Padding(
                      padding: (index == filteredSnapshots.length - 1)
                          ? EdgeInsets.only(bottom: width * 0.3)
                          : EdgeInsets.only(bottom: 0),
                      child: Card(
                        margin: EdgeInsets.all(width * 0.03),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black, // Set the border color
                              width: 0.2,
                              // Set the border width
                            ),
                          ),
                          height: width * 0.9,
                          child: Column(
                            children: [
                              Container(
                                height: width * 0.65,
                                width: width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12)),
                                  color: Colors.black12,
                                ),
                                child: Image.network((snapshot.data()
                                    as Map<String, dynamic>)['imageURl']),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 5.0, left: 8.0, right: 8.0),
                                        child: Text(
                                          length >= 25
                                              ? (snapshot.data() as Map<String,
                                                              dynamic>)[
                                                          'projectname']
                                                      .substring(
                                                          0,
                                                          min<int>(
                                                              20,
                                                              (snapshot.data() as Map<
                                                                          String,
                                                                          dynamic>)[
                                                                      'projectname']
                                                                  .length)) +
                                                  "..."
                                              : (snapshot.data() as Map<String,
                                                  dynamic>)['projectname'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: width * 0.04,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 5.0,
                                          left: 3.0,
                                        ),
                                        child: Container(
                                          height: width * 0.06,
                                          width: width * 0.17,
                                          decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(2)),
                                          child: Center(
                                              child: Text(
                                            (snapshot.data() as Map<String,
                                                dynamic>)['projecttype'],
                                            style: TextStyle(
                                              fontSize: (snapshot.data() as Map<
                                                                  String,
                                                                  dynamic>)[
                                                              'projecttype']
                                                          .toString()
                                                          .length <=
                                                      17
                                                  ? width * 0.02
                                                  : width * 0.015,
                                              fontFamily: 'Roboto',
                                            ),
                                          )),
                                        ),
                                      ),
                                      Flexible(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: width * 0.015,
                                                left: width * 0.02),
                                            child: InkWell(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return ProjectInfo(
                                                      data: snapshot.data()
                                                          as Map<String,
                                                              dynamic>,
                                                    );
                                                  }));
                                                },
                                                child:
                                                    Icon(Icons.info, size: 20)),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: width * 0.015,
                                              left: width * 0.02),
                                          child: InkWell(
                                              onTap: () async {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text('Delete'),
                                                        content: Text(
                                                            'Do You Want to Delete this Item?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child:
                                                                Text('Cancel'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Dismiss the dialog
                                                            },
                                                          ),
                                                          TextButton(
                                                            child:
                                                                Text('Delete'),
                                                            onPressed:
                                                                () async {
                                                              final documentRef =
                                                                  snapshot
                                                                      .reference;

                                                              for (int i = 0;
                                                                  i <
                                                                      (snapshot.data() as Map<
                                                                              String,
                                                                              dynamic>)['imageURl']
                                                                          .length;
                                                                  i++) {
                                                                firebase_storage
                                                                    .FirebaseStorage
                                                                    .instance
                                                                    .refFromURL((snapshot
                                                                            .data()
                                                                        as Map<
                                                                            String,
                                                                            dynamic>)['imageURl'])
                                                                    .delete();
                                                              }
                                                              Query query = CollectionRef.where(
                                                                  'imageUrL',
                                                                  isEqualTo: ((snapshot
                                                                          .data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>)['imageURl']));
                                                              query.get().then(
                                                                  (QuerySnapshot
                                                                      snapshot) async {
                                                                if (snapshot
                                                                    .docs
                                                                    .isNotEmpty) {
                                                                  for (DocumentSnapshot document
                                                                      in snapshot
                                                                          .docs) {
                                                                    final documentId =
                                                                        document
                                                                            .reference;
                                                                    await documentId
                                                                        .delete();
                                                                  }
                                                                } else {
                                                                  print(
                                                                      'No documents found with the matching image URL.');
                                                                }
                                                              });

                                                              await documentRef
                                                                  .delete();
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                      'Document deleted!'),
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                ),
                                                              );
                                                              Future.delayed(
                                                                  delay, () {
                                                                setState(() {
                                                                  collectionRef = firestore
                                                                      .collection(
                                                                          'builders')
                                                                      .doc(
                                                                          useremail)
                                                                      .collection(
                                                                          'Projects');
                                                                  fetchData();
                                                                });
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              },
                                              child:
                                                  Icon(Icons.delete, size: 20)),
                                        ),
                                      )
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: width * 0.025, top: 2),
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'From Date: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: width * 0.036,
                                            fontFamily: 'Roboto',
                                            color: Colors.black,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${(snapshot.data() as Map<String, dynamic>)['fromdate']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: width * 0.025, top: 2),
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'To Date: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: width * 0.036,
                                            fontFamily: 'Roboto',
                                            color: Colors.black,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${(snapshot.data() as Map<String, dynamic>)['todate']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  (snapshot.data() as Map<String, dynamic>)[
                                                  'projectrequirements']
                                              .length ==
                                          0
                                      ? Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Container(
                                              child: Text(
                                                'No requirements',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Roboto',
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Container(
                                              child: Text(
                                                "${(snapshot.data() as Map<String, dynamic>)['projectrequirements'][0]['Item Name']} + ${(snapshot.data() as Map<String, dynamic>)['projectrequirements'].length - 1} more items"
                                                            .length >
                                                        35
                                                    ? "${(snapshot.data() as Map<String, dynamic>)['projectrequirements'][0]['Item Name']} + ${(snapshot.data() as Map<String, dynamic>)['projectrequirements'].length - 1} more items"
                                                            .substring(0, 32) +
                                                        '...'
                                                    : (snapshot.data() as Map<
                                                                            String,
                                                                            dynamic>)[
                                                                        'projectrequirements']
                                                                    .length -
                                                                1 ==
                                                            0
                                                        ? "${(snapshot.data() as Map<String, dynamic>)['projectrequirements'][0]['Item Name']}"
                                                        : "${(snapshot.data() as Map<String, dynamic>)['projectrequirements'][0]['Item Name']} + ${(snapshot.data() as Map<String, dynamic>)['projectrequirements'].length - 1} more items",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Roboto',
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      final querySnapshot = await collectionRef.get();
      setState(() {
        allSnapshots = querySnapshot.docs;
        filteredSnapshots = querySnapshot.docs;
      });
    } catch (error) {}
  }
}
