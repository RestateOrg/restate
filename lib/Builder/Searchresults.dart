import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/Builder/ProductDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:restate/Builder/Searchpage.dart';

class Searchresults extends StatefulWidget {
  final Query query;
  final String type;
  final String searchkey;
  final int index;
  const Searchresults(
      {Key? key,
      required this.query,
      required this.type,
      required this.searchkey,
      required this.index})
      : super(key: key);

  @override
  State<Searchresults> createState() => _SearchresultsState();
}

FirebaseFirestore firestore = FirebaseFirestore.instance;
String? useremail = FirebaseAuth.instance.currentUser?.email;
List<String> likedItemIds = [];

class _SearchresultsState extends State<Searchresults> {
  @override
  void initState() {
    super.initState();
    firestore
        .collection('builders')
        .doc(useremail)
        .collection('wishlist')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        likedItemIds.add(ds.id);
      }
    });
  }

  @override
  void dispose() {
    // Clear the image cache when the page is disposed
    DefaultCacheManager().emptyCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            widget.index == 0
                ? Navigator.pop(context)
                : Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
          },
          child: Container(
            width: width * 0.7,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(250),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.black.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 18,
                  ),
                ),
                Text('Search',
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: widget.type == 'machinery'
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(
                        text: "Search results for ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(
                            text: "${widget.searchkey}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: widget.query
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data!.docs.isEmpty)
                        return Center(child: Text('No results found'));
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: 350,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> data = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                            data: data,
                                            type: widget.type,
                                          )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 0.5,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),
                              ),
                              child: Card(
                                elevation: 2,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    return Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            width: constraints.maxWidth,
                                            height:
                                                constraints.maxHeight * 0.65,
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                            ),
                                            child: ClipRRect(
                                              child: CachedNetworkImage(
                                                key: UniqueKey(),
                                                imageUrl: data['image_urls'][0],
                                                width: constraints.maxWidth,
                                                height: 100,
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              width: constraints.maxWidth,
                                              height:
                                                  constraints.maxHeight * 0.35,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 5.0,
                                                                left: 8),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -0.8, 0),
                                                          child: Container(
                                                            width: constraints
                                                                    .maxWidth *
                                                                0.67,
                                                            height: 40,
                                                            child: Text(
                                                              data.containsKey(
                                                                      'back_hoe_size')
                                                                  ? "${data['specifications'].toUpperCase()} ${data['back_hoe_size']} ${data['machinery_type']} ( ${data['brand_name'].toUpperCase()} )"
                                                                              .length <
                                                                          38
                                                                      ? "${data['specifications'].toUpperCase()} ${data['back_hoe_size']} ${data['machinery_type']} ( ${data['brand_name'].toUpperCase()} )"
                                                                      : "${data['specifications'].toUpperCase()} ${data['back_hoe_size']} ${data['machinery_type']} ( ${data['brand_name'].toUpperCase()} )".substring(
                                                                              0,
                                                                              35) +
                                                                          '...'
                                                                  : "${data['specifications'].toUpperCase()} ${data['machinery_type']} ( ${data['brand_name'].toUpperCase()} )"
                                                                              .length <
                                                                          38
                                                                      ? "${data['specifications'].toUpperCase()} ${data['machinery_type']} ( ${data['brand_name'].toUpperCase()} )"
                                                                      : "${data['specifications'].toUpperCase()} ${data['machinery_type']} ( ${data['brand_name'].toUpperCase()} )".substring(
                                                                              0,
                                                                              35) +
                                                                          '...',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Roboto',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.9, 0),
                                                          child: RatingBar(
                                                            initialRating: data[
                                                                        'rating']
                                                                    ?.toDouble() ??
                                                                0.0,
                                                            direction:
                                                                Axis.horizontal,
                                                            allowHalfRating:
                                                                true,
                                                            itemCount: 5,
                                                            ratingWidget:
                                                                RatingWidget(
                                                              full: Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              half: Icon(
                                                                Icons.star_half,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              empty: Icon(
                                                                Icons
                                                                    .star_border,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                            ),
                                                            itemSize: 20,
                                                            onRatingUpdate:
                                                                (rating) {
                                                              print(rating);
                                                            },
                                                            ignoreGestures:
                                                                true,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(children: [
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 7.0),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0, 0),
                                                          child: Column(
                                                            children: [
                                                              Text("Hourly",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              Text(
                                                                  "₹${data['hourly']}",
                                                                  style: TextStyle(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          215,
                                                                          163,
                                                                          7))),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 7.0),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0, 0),
                                                          child: Column(
                                                            children: [
                                                              Text("Day",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              Text(
                                                                "₹${data['day']}",
                                                                style: TextStyle(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        215,
                                                                        163,
                                                                        7)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 7.0),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0, 0),
                                                          child: Column(
                                                            children: [
                                                              Text("Weekly",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              Text(
                                                                  "₹${data['week']}",
                                                                  style: TextStyle(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          215,
                                                                          163,
                                                                          7))),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ])
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(
                        text: "Search results for ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(
                            text: "${widget.searchkey}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: widget.query.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data!.docs.isEmpty)
                        return Center(child: Text('No results found'));
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: 350,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> data = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          bool isLiked = likedItemIds
                              .contains(snapshot.data!.docs[index].id);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                            data: data,
                                            type: widget.type,
                                          )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 0.5,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ),
                              ),
                              child: Card(
                                elevation: 2,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    return Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            width: constraints.maxWidth,
                                            height:
                                                constraints.maxHeight * 0.73,
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                            ),
                                            child: ClipRRect(
                                              child: CachedNetworkImage(
                                                key: UniqueKey(),
                                                imageUrl: data['Images'][0],
                                                width: constraints.maxWidth,
                                                height: 100,
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              width: constraints.maxWidth,
                                              height:
                                                  constraints.maxHeight * 0.27,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 5.0,
                                                                left: 8),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -0.9, 0),
                                                          child: Container(
                                                            width: constraints
                                                                    .maxWidth *
                                                                0.67,
                                                            child: Text(
                                                              data['Material_name']
                                                                          .length <
                                                                      39
                                                                  ? data[
                                                                      'Material_name']
                                                                  : data['Material_name']
                                                                          .substring(
                                                                              0,
                                                                              10) +
                                                                      '...',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontFamily:
                                                                    'Roboto',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.9, 0),
                                                          child: Row(
                                                            children: [
                                                              RatingBar(
                                                                initialRating:
                                                                    data['rating']
                                                                            ?.toDouble() ??
                                                                        0.0,
                                                                direction: Axis
                                                                    .horizontal,
                                                                allowHalfRating:
                                                                    true,
                                                                itemCount: 5,
                                                                ratingWidget:
                                                                    RatingWidget(
                                                                  full: Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                  half: Icon(
                                                                    Icons
                                                                        .star_half,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                  empty: Icon(
                                                                    Icons
                                                                        .star_border,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                ),
                                                                itemSize: 20,
                                                                onRatingUpdate:
                                                                    (rating) {
                                                                  print(rating);
                                                                },
                                                                ignoreGestures:
                                                                    true,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 2),
                                                    child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -0.93, 0),
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    '₹ ${data['Price_per']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          199,
                                                                          153,
                                                                          15),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  // Add any other styles for Price per here
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: ' / ',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          199,
                                                                          153,
                                                                          15),
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    '${data['Price_per_unit']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          199,
                                                                          153,
                                                                          15),
                                                                  // Add any other styles for Price per unit here
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 0),
                                                            child: Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      -0.7, 0),
                                                              child: Text(
                                                                "${data['Brand_name']}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                              ),
                                                            )),
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 0),
                                                          child: Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.85, 0),
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  isLiked
                                                                      ? Fluttertoast
                                                                          .showToast(
                                                                          msg:
                                                                              "Removed from wishlist",
                                                                          toastLength:
                                                                              Toast.LENGTH_SHORT,
                                                                          gravity:
                                                                              ToastGravity.BOTTOM,
                                                                          timeInSecForIosWeb:
                                                                              1,
                                                                          backgroundColor:
                                                                              Colors.black,
                                                                          textColor:
                                                                              Colors.white,
                                                                        )
                                                                      : Fluttertoast
                                                                          .showToast(
                                                                          msg:
                                                                              "Added to wishlist",
                                                                          toastLength:
                                                                              Toast.LENGTH_SHORT,
                                                                          gravity:
                                                                              ToastGravity.BOTTOM,
                                                                          timeInSecForIosWeb:
                                                                              1,
                                                                          backgroundColor:
                                                                              Colors.black,
                                                                          textColor:
                                                                              Colors.white,
                                                                        );
                                                                  String
                                                                      itemId =
                                                                      snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .id;

                                                                  if (likedItemIds
                                                                      .contains(
                                                                          itemId)) {
                                                                    // If item is already liked, unlike it
                                                                    likedItemIds
                                                                        .remove(
                                                                            itemId);
                                                                    setState(
                                                                        () {});
                                                                    await firestore
                                                                        .collection(
                                                                            'machinery')
                                                                        .doc(
                                                                            useremail)
                                                                        .collection(
                                                                            'wishlist')
                                                                        .where(
                                                                            'Images',
                                                                            isEqualTo: data[
                                                                                'Images'])
                                                                        .get()
                                                                        .then(
                                                                            (snapshot) {
                                                                      for (DocumentSnapshot ds
                                                                          in snapshot
                                                                              .docs) {
                                                                        ds.reference
                                                                            .delete();
                                                                      }
                                                                    });
                                                                  } else {
                                                                    // If item is not liked, like it
                                                                    likedItemIds
                                                                        .add(
                                                                            itemId);
                                                                    setState(
                                                                        () {});
                                                                    await firestore
                                                                        .collection(
                                                                            'machinery')
                                                                        .doc(
                                                                            useremail)
                                                                        .collection(
                                                                            'wishlist')
                                                                        .add(
                                                                            data);
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  isLiked
                                                                      ? FontAwesomeIcons
                                                                          .solidHeart
                                                                      : FontAwesomeIcons
                                                                          .solidHeart,
                                                                  key:
                                                                      UniqueKey(),
                                                                  color: isLiked
                                                                      ? Colors
                                                                          .pink
                                                                      : Colors
                                                                          .grey, // Change color based on liked state
                                                                ),
                                                              )),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
