import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restate/Builder/ProductDetails.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final useremail = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist"),
        backgroundColor: Colors.amber,
      ),
      body: StreamBuilder(
        stream: getitems().asStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            child: ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                var item = snapshot.data?[index].data();
                var item1 = item as Map<String, dynamic>;
                return item1.containsKey("machinery_name")
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                  data: item1, type: 'machinery'),
                            ),
                          );
                        },
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
                                  child: CachedNetworkImage(
                                    key: UniqueKey(),
                                    imageUrl: item1['image_urls'][0],
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.black.withOpacity(0.5)),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                            child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.error),
                                        Text('Error loading image'),
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
                                              top: 5.0, left: 8.0, right: 8.0),
                                          child: Text(
                                            item1['machinery_name'].length > 19
                                                ? item1['machinery_name'].substring(
                                                        0,
                                                        min<int>(
                                                            16,
                                                            item1['machinery_name']
                                                                .length)) +
                                                    "..."
                                                : item1['machinery_name'],
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
                                              item1['machinery_type'],
                                              style: TextStyle(
                                                fontSize:
                                                    item1['machinery_type']
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
                                                left: width * 0.025),
                                            child: Text(
                                              '₹ ${item1['hourly']} Per Hour',
                                              style: TextStyle(
                                                  fontSize: width * 0.033,
                                                  fontWeight: FontWeight.w100),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: width * 0.025,
                                                top: width * 0.05),
                                            child: Text(
                                              '₹ ${item1['day']} Per Day',
                                              style: TextStyle(
                                                  fontSize: width * 0.033,
                                                  fontWeight: FontWeight.w100),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetails(data: item1, type: 'material'),
                            ),
                          );
                        },
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
                                  child: Image.network(item1['Images'][0]),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 5.0, left: 8.0, right: 8.0),
                                          child: Text(
                                            item1['Material_name'].length >= 25
                                                ? item1['Material_name'].substring(
                                                        0,
                                                        min<int>(
                                                            20,
                                                            item1['Material_name']
                                                                .length)) +
                                                    "..."
                                                : item1['Material_name'],
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
                                              item1['Material_type'],
                                              style: TextStyle(
                                                fontSize: item1['Material_type']
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
                                              '₹ ${item1['Price_per']} Per ${item1['Price_per_unit']}',
                                              style: TextStyle(
                                                  fontSize: width * 0.033,
                                                  fontWeight: FontWeight.w100),
                                            ),
                                          ),
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
          );
        },
      ),
    );
  }

  Future<List<DocumentSnapshot>> getitems() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("builders")
        .doc(useremail)
        .collection("wishlist")
        .get();
    return qn.docs;
  }
}
