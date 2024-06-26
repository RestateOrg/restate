import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restate/Materials/editpage.dart';
import 'package:restate/Materials/productinfo.dart';

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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: width,
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
              child: CupertinoSearchTextField(
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(30),
                padding: EdgeInsets.all(10),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      filteredSnapshots = allSnapshots; // Use the normal list
                    } else {
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
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductInfo(
                                data: snapshot.data() as Map<String, dynamic>,
                                type: "material"),
                          ),
                        );
                      },
                      child: Container(
                        color: index % 2 != 0
                            ? const Color.fromARGB(40, 253, 197, 0)
                            : const Color.fromARGB(0, 255, 193, 7),
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
                                            length >= 25
                                                ? (snapshot.data() as Map<
                                                                String,
                                                                dynamic>)[
                                                            'Material_name']
                                                        .substring(
                                                            0,
                                                            min<int>(
                                                                20,
                                                                (snapshot.data() as Map<
                                                                            String,
                                                                            dynamic>)[
                                                                        'Material_name']
                                                                    .length)) +
                                                    "..."
                                                : (snapshot.data() as Map<
                                                    String,
                                                    dynamic>)['Material_name'],
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
                                        Flexible(
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(1, 0),
                                            child: InkWell(
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
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductInfo(
                                                              data: snapshot
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>,
                                                              type: "material"),
                                                    ),
                                                  );
                                                },
                                                child:
                                                    Icon(Icons.info, size: 20)),
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
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text('Delete'),
                                                          content: Text(
                                                              'Do You Want to Delete this Item?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(
                                                                  'Cancel'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // Dismiss the dialog
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text(
                                                                  'Delete'),
                                                              onPressed:
                                                                  () async {
                                                                final documentRef =
                                                                    snapshot
                                                                        .reference;

                                                                for (int i = 0;
                                                                    i <
                                                                        (snapshot.data()
                                                                                as Map<String, dynamic>)['Images']
                                                                            .length;
                                                                    i++) {
                                                                  firebase_storage
                                                                      .FirebaseStorage
                                                                      .instance
                                                                      .refFromURL((snapshot
                                                                              .data()
                                                                          as Map<
                                                                              String,
                                                                              dynamic>)['Images'][i])
                                                                      .delete();
                                                                }
                                                                Query query = CollectionRef.where(
                                                                    'Images',
                                                                    isEqualTo: ((snapshot
                                                                            .data()
                                                                        as Map<
                                                                            String,
                                                                            dynamic>)['Images']));
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
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        'Document deleted!'),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            1),
                                                                  ),
                                                                );
                                                                Future.delayed(
                                                                    delay, () {
                                                                  setState(() {
                                                                    collectionRef = firestore
                                                                        .collection(
                                                                            'materials')
                                                                        .doc(
                                                                            useremail)
                                                                        .collection(
                                                                            'items');
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
                                                child: Icon(Icons.delete,
                                                    size: 20)),
                                          ),
                                        )
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: width * 0.025),
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
                                                        BorderRadius.circular(
                                                            2),
                                                    color: (snapshot.data()
                                                                    as Map<
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
                                                          fontSize:
                                                              width * 0.025,
                                                          fontWeight:
                                                              FontWeight.w100,
                                                          color: (snapshot.data() as Map<
                                                                          String,
                                                                          dynamic>)[
                                                                      'status'] ==
                                                                  'In Stock'
                                                              ? Colors.green
                                                                  .shade900
                                                              : Colors.red
                                                                  .shade900),
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
