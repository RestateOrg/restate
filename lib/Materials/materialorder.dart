import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:restate/Materials/OrdersRequest.dart';
import 'package:restate/Materials/YourOrderDetails.dart';

class MaterialOrder extends StatefulWidget {
  @override
  State<MaterialOrder> createState() => _MaterialOrderState();
}

class _MaterialOrderState extends State<MaterialOrder> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String useremail; // Use 'late' to initialize later
  late CollectionReference collectionRef; // Initialize later as well
  List<DocumentSnapshot> allSnapshots = [];
  List<DocumentSnapshot> filteredSnapshots = [];
  @override
  void initState() {
    super.initState();

    useremail =
        FirebaseAuth.instance.currentUser?.email ?? ''; // Assign in initState
    collectionRef =
        firestore.collection('materials').doc(useremail).collection('orders');
    fetchData(); // Fetch data after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Clear the image cache when the page is popped
      CachedNetworkImageProvider('', cacheManager: DefaultCacheManager())
          .evict();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const Duration delay = Duration(milliseconds: 3);
    return Scaffold(
      backgroundColor: Colors.white,
      body: filteredSnapshots.isEmpty
          ? RefreshIndicator(
              onRefresh: () async {
                Future.delayed(delay, () {
                  setState(() {
                    collectionRef = firestore
                        .collection('materials')
                        .doc(useremail)
                        .collection('orders');
                    fetchData();
                  });
                });
              },
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.amber,
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 8.0, right: 8.0),
                          child: Container(
                            width: width * 0.92,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: CupertinoSearchTextField(
                              backgroundColor: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              padding: EdgeInsets.all(10),
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    // If the search query is empty, show all items
                                    filteredSnapshots =
                                        allSnapshots; // Use the normal list
                                  } else {
                                    // filter the list based on Material_type
                                    filteredSnapshots = allSnapshots
                                        .where((element) => (element.data()
                                                    as Map<String, dynamic>)[
                                                'order_name']
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
                      ),
                      Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: width * 0.03),
                                child: Text(
                                  "Your Orders",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          Flexible(
                              child: Align(
                                  alignment: AlignmentDirectional(0.9, 0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderRequest()));
                                    },
                                    child: Text(
                                      "Requests",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.blue),
                                    ),
                                  )))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 300.0),
                        child: Center(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'No Orders Found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Column(
              children: [
                Container(
                  width: width,
                  color: Colors.amber,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
                    child: Container(
                      width: width * 0.92,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.black.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: CupertinoSearchTextField(
                        backgroundColor: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        padding: EdgeInsets.all(10),
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              // If the search query is empty, show all items
                              filteredSnapshots =
                                  allSnapshots; // Use the normal list
                            } else {
                              // filter the list based on Material_type
                              filteredSnapshots = allSnapshots
                                  .where((element) => (element.data()
                                          as Map<String, dynamic>)['order_name']
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
                ),
                Row(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: width * 0.03),
                          child: Text(
                            "Your Orders",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Flexible(
                        child: Align(
                            alignment: AlignmentDirectional(0.9, 0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderRequest()));
                              },
                              child: Text(
                                "Requests",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                            )))
                  ],
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      Future.delayed(delay, () {
                        setState(() {
                          collectionRef = firestore
                              .collection('materials')
                              .doc(useremail)
                              .collection('orders');
                          fetchData();
                        });
                      });
                    },
                    child: ListView.builder(
                      itemCount: filteredSnapshots.length,
                      itemBuilder: (context, index) {
                        final snapshot = filteredSnapshots[index];
                        int length = (snapshot.data()
                                as Map<String, dynamic>)['order_name']
                            .length;
                        return Padding(
                          padding: (index == filteredSnapshots.length - 1)
                              ? EdgeInsets.only(bottom: width * 0.2)
                              : EdgeInsets.only(bottom: 0),
                          child: Container(
                            color: index % 2 != 0
                                ? const Color.fromARGB(40, 253, 197, 0)
                                : const Color.fromARGB(0, 255, 193, 7),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => YourOrdersDetails(
                                            order: filteredSnapshots[index])));
                              },
                              child: Card(
                                margin: EdgeInsets.all(width * 0.03),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          Colors.black, // Set the border color
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
                                        child: CachedNetworkImage(
                                          imageUrl: (snapshot.data() as Map<
                                              String, dynamic>)['projectimage'],
                                          key: UniqueKey(),
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.black
                                                          .withOpacity(0.5)),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Center(
                                                  child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.error),
                                              Text("$error"),
                                            ],
                                          )),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 5.0,
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Text(
                                                  length > 19
                                                      ? (snapshot.data() as Map<
                                                                      String,
                                                                      dynamic>)[
                                                                  'order_name']
                                                              .substring(
                                                                  0,
                                                                  min<int>(
                                                                      16,
                                                                      (snapshot.data() as Map<String, dynamic>)['order_name']
                                                                          .length)) +
                                                          "..."
                                                      : (snapshot.data() as Map<
                                                              String, dynamic>)[
                                                          'order_name'],
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
                                                          BorderRadius.circular(
                                                              2)),
                                                  child: Center(
                                                      child: Text(
                                                    (snapshot.data() as Map<
                                                            String, dynamic>)[
                                                        'projecttype'],
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
                                                  alignment:
                                                      AlignmentDirectional(
                                                          1, 0),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      top: width * 0.015,
                                                      right: width * 0.015,
                                                    ),
                                                    child: InkWell(
                                                        onTap: () {},
                                                        child: Icon(Icons.info,
                                                            size: 20)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Text(
                                                (snapshot.data() as Map<String,
                                                        dynamic>)['product']
                                                    ['Material_name'],
                                                style: TextStyle(
                                                    fontSize: width * 0.037),
                                              ),
                                            ),
                                          ),
                                          Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: width * 0.025),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: 'Total:',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              ' ₹${(snapshot.data() as Map<String, dynamic>)['total']}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2),
                                                          color: (snapshot.data()
                                                                          as Map<
                                                                              String,
                                                                              dynamic>)[
                                                                      'status'] ==
                                                                  'Completed'
                                                              ? Colors.green
                                                                  .withOpacity(
                                                                      0.4)
                                                              : Colors.red
                                                                  .withOpacity(
                                                                      0.4),
                                                        ),
                                                        width: width * 0.17,
                                                        height: width * 0.05,
                                                        child: Center(
                                                          child: Text(
                                                            (snapshot.data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>)[
                                                                'status'],
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.025,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w100,
                                                                color: (snapshot.data()
                                                                                as Map<String, dynamic>)[
                                                                            'status'] ==
                                                                        'Completed'
                                                                    ? Colors
                                                                        .green
                                                                        .shade900
                                                                    : Colors.red
                                                                        .shade900),
                                                          ),
                                                        ))),
                                              ),
                                            ],
                                          ),
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
      final querySnapshot =
          await collectionRef.orderBy('order_date', descending: true).get();
      setState(() {
        allSnapshots = querySnapshot.docs;
        filteredSnapshots = querySnapshot.docs;
      });
    } catch (error) {}
  }
}
