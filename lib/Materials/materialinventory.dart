import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restate/Materials/editpage.dart';

class MaterialInventory extends StatefulWidget {
  const MaterialInventory({super.key});

  @override
  State<MaterialInventory> createState() => _MaterialInventoryState();
}

class _MaterialInventoryState extends State<MaterialInventory> {
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
        firestore.collection('materials').doc(useremail).collection('items');
    fetchData();
    // Fetch data after initialization
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const Duration delay = Duration(milliseconds: 3);
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        children: [
          Container(
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
                                as Map<String, dynamic>)['Material_name']
                            .toString()
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  }
                });
              },
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.03),
                child: Text(
                  "Your Inventory",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                Future.delayed(delay, () {
                  setState(() {
                    collectionRef = firestore
                        .collection('materials')
                        .doc(useremail)
                        .collection('items');
                    fetchData();
                  });
                });
              },
              child: ListView.builder(
                itemCount: filteredSnapshots.length,
                itemBuilder: (context, index) {
                  final snapshot = filteredSnapshots[index];
                  int length =
                      (snapshot.data() as Map<String, dynamic>)['Material_name']
                          .length;
                  return Padding(
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
                                  as Map<String, dynamic>)['Images'][0]),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 5.0, left: 8.0, right: 8.0),
                                      child: Text(
                                        (snapshot.data() as Map<String,
                                                    dynamic>)['Material_name']
                                                .substring(
                                                    0,
                                                    min<int>(
                                                        15,
                                                        (snapshot.data() as Map<
                                                                    String,
                                                                    dynamic>)[
                                                                'Material_name']
                                                            .length)) +
                                            ((snapshot.data() as Map<String,
                                                                dynamic>)[
                                                            'Material_name']
                                                        .length >
                                                    15
                                                ? "..."
                                                : ""),
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
                                        right: length == 1
                                            ? width * 0.30
                                            : length == 2
                                                ? width * 0.27
                                                : length == 3
                                                    ? width * 0.24
                                                    : length == 4
                                                        ? width * 0.21
                                                        : length == 5
                                                            ? width * 0.18
                                                            : length == 6
                                                                ? width * 0.16
                                                                : length == 7
                                                                    ? width *
                                                                        0.15
                                                                    : length ==
                                                                            8
                                                                        ? width *
                                                                            0.125
                                                                        : length ==
                                                                                9
                                                                            ? width *
                                                                                0.10
                                                                            : length == 10
                                                                                ? width * 0.08
                                                                                : length == 11
                                                                                    ? width * 0.06
                                                                                    : length == 12
                                                                                        ? width * 0.04
                                                                                        : length == 13
                                                                                            ? width * 0.01
                                                                                            : 0,
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
                                              dynamic>)['Material_type'],
                                          style: TextStyle(
                                            fontSize: (snapshot.data() as Map<
                                                                String,
                                                                dynamic>)[
                                                            'Material_type']
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
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              top: width * 0.015,
                                              left: width * 0.2),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditPage(
                                                          snapshot: snapshot),
                                                  settings: RouteSettings(
                                                      arguments: snapshot),
                                                ),
                                              );
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              size: 20,
                                            ),
                                          )),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: width * 0.015,
                                            left: width * 0.02),
                                        child: Icon(Icons.info, size: 20),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: width * 0.015,
                                            left: width * 0.02),
                                        child: GestureDetector(
                                            onTap: () async {
                                              final documentRef =
                                                  snapshot.reference;
                                              Query query = CollectionRef.where(
                                                  'Images',
                                                  isEqualTo: ((snapshot.data()
                                                      as Map<String,
                                                          dynamic>)['Images']));
                                              query.get().then((QuerySnapshot
                                                  snapshot) async {
                                                if (snapshot.docs.isNotEmpty) {
                                                  for (DocumentSnapshot document
                                                      in snapshot.docs) {
                                                    final documentId =
                                                        document.reference;
                                                    await documentId.delete();
                                                  }
                                                } else {
                                                  print(
                                                      'No documents found with the matching image URL.');
                                                }
                                              });
                                              for (int i = 0;
                                                  i <
                                                      (snapshot.data() as Map<
                                                                  String,
                                                                  dynamic>)[
                                                              'Images']
                                                          .length;
                                                  i++) {
                                                firebase_storage
                                                    .FirebaseStorage.instance
                                                    .refFromURL((snapshot.data()
                                                            as Map<String,
                                                                dynamic>)[
                                                        'Images'][i])
                                                    .delete();
                                              }
                                              await documentRef.delete();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content:
                                                      Text('Document deleted!'),
                                                  duration:
                                                      Duration(seconds: 1),
                                                ),
                                              );
                                              Future.delayed(delay, () {
                                                setState(() {
                                                  collectionRef = firestore
                                                      .collection('materials')
                                                      .doc(useremail)
                                                      .collection('items');
                                                  fetchData();
                                                });
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
                                    padding:
                                        EdgeInsets.only(left: width * 0.025),
                                    child: Text("Price",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: width * 0.036,
                                            fontFamily: 'Roboto')),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: width * 0.025,
                                            top: width * 0.02),
                                        child: Text(
                                          '₹ ${(snapshot.data() as Map<String, dynamic>)['Price_per']} Per ${(snapshot.data() as Map<String, dynamic>)['Price_per_unit']}',
                                          style: TextStyle(
                                              fontSize: width * 0.033,
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: width * 0.09),
                                        child: Text(
                                          'Status',
                                          style: TextStyle(
                                              fontSize: width * 0.037,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              right: width * 0.03,
                                              top: width * 0.05),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                color: (snapshot.data() as Map<
                                                                String,
                                                                dynamic>)[
                                                            'status'] ==
                                                        'In Stock'
                                                    ? Colors.green
                                                        .withOpacity(0.4)
                                                    : Colors.red
                                                        .withOpacity(0.4),
                                              ),
                                              width: width * 0.17,
                                              height: width * 0.05,
                                              child: Center(
                                                child: Text(
                                                  (snapshot.data() as Map<
                                                      String,
                                                      dynamic>)['status'],
                                                  style: TextStyle(
                                                      fontSize: width * 0.025,
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      color: (snapshot.data() as Map<
                                                                      String,
                                                                      dynamic>)[
                                                                  'status'] ==
                                                              'In Stock'
                                                          ? Colors
                                                              .green.shade900
                                                          : Colors
                                                              .red.shade900),
                                                ),
                                              ))),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
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
