import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restate/Builder/Searchresults.dart';
import 'package:restate/Utils/hexcolor.dart';

class BuilderCart extends StatefulWidget {
  const BuilderCart({Key? key}) : super(key: key);

  @override
  State<BuilderCart> createState() => _BuilderCartState();
}

final useremail = FirebaseAuth.instance.currentUser?.email;
String location = "";
String city = "";
String state = "";
String name = "";
String projecttype = "";
int selectedIndex = 0;

String time = "1";
List<QueryDocumentSnapshot> deliverySnapshots = [];

class _BuilderCartState extends State<BuilderCart> {
  List<int> _quantity = [];
  List<String> timeperiod = [];
  void initState() {
    super.initState();
    getDeliveryAddress();
  }

  void _incrementQuantity(int index) {
    setState(() {
      _quantity[index]++;
    });
  }

  void _decrementQuantity(int index) {
    if (_quantity[index] > 0) {
      setState(() {
        _quantity[index]--;
      });
    }
  }

  Future<void> getDeliveryAddress() async {
    CollectionReference collectionReference =
        firestore.collection('builders').doc(useremail).collection('Projects');
    final querySnapshot =
        await collectionReference.orderBy("fromdate", descending: true).get();
    setState(() {
      deliverySnapshots = querySnapshot.docs;
    });
    setState(() {
      location = deliverySnapshots[selectedIndex]['location'];
      city = deliverySnapshots[selectedIndex]['city'];
      state = deliverySnapshots[selectedIndex]['state'];
      name = deliverySnapshots[selectedIndex]['projectname'];
      projecttype = deliverySnapshots[selectedIndex]['projecttype'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 234, 234),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 3),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              width: width,
              child: Column(children: [
                Row(
                  children: [
                    Text(
                      "Deliver to:",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.amber[600],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextButton(
                        child: Text(
                          "Change",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                Container(
                  width: width,
                  child: Text(
                    "$location, $city, $state",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ]),
            ),
            Container(
              height: 500,
              child: FutureBuilder<List<DocumentSnapshot>>(
                future: _fetchProducts(),
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
                        _quantity.add(0);

                        if (snapshot.data![index]['type'] == 'machinery') {
                          timeperiod.add('Hour');
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 3),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data![index]
                                            ['image_urls'][0],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            snapshot.data![index]
                                                ['machinery_name'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(snapshot.data![index]
                                              ['machinery_type']),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: RatingBar(
                                                  initialRating: snapshot
                                                      .data![index]['rating']
                                                      .toDouble(),
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  ratingWidget: RatingWidget(
                                                    full: Icon(Icons.star,
                                                        color: Colors.amber),
                                                    half: Icon(Icons.star_half,
                                                        color: Colors.amber),
                                                    empty: Icon(Icons.star,
                                                        color: Colors.grey),
                                                  ),
                                                  itemSize: 17,
                                                  ignoreGestures: true,
                                                  onRatingUpdate: (rating) {
                                                    print(rating);
                                                  },
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Text(
                                                "${snapshot.data![index]['rating_count']}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 0, 0, 0)
                                                .withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.remove, size: 14),
                                            onPressed: () =>
                                                _decrementQuantity(index),
                                          ),
                                          Text(
                                            '${_quantity[index]}',
                                            style: TextStyle(fontSize: 14.0),
                                          ),
                                          Container(
                                            child: IconButton(
                                              icon: Icon(Icons.add, size: 14),
                                              onPressed: () =>
                                                  _incrementQuantity(index),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  "₹ ${snapshot.data![index]['hourly']}",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " / Hour",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  "₹ ${snapshot.data![index]['week']}",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " / Week",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                  Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  "₹ ${snapshot.data![index]['day']}",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " / Day",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  "₹ ${snapshot.data![index]['month']}",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " / Month",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Time Period",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: HexColor("#815D00")),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                      255, 0, 0, 0)
                                                  .withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: DropdownButton<String>(
                                          underline: Container(),
                                          value: timeperiod[index],
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              timeperiod[index] = newValue!;
                                            });
                                          },
                                          items: <String>[
                                            'Hour',
                                            'Day',
                                            'Week',
                                            'Month'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 60,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        timeperiod[index] == 'Hour'
                                            ? "Hour"
                                            : timeperiod[index] == 'Day'
                                                ? "Day"
                                                : timeperiod[index] == 'Week'
                                                    ? "Week"
                                                    : "Month",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: HexColor("#815D00")),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                      255, 0, 0, 0)
                                                  .withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: DropdownButton<String>(
                                          underline: Container(),
                                          value: time,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              time = newValue!;
                                            });
                                          },
                                          items: timeperiod[index] == 'Hour'
                                              ? <String>[
                                                  '1',
                                                  '2',
                                                  '3',
                                                  '4',
                                                  '5',
                                                  '6',
                                                  '7',
                                                  '8',
                                                  '9',
                                                  '10',
                                                  '11',
                                                  '12',
                                                  '13',
                                                  '14',
                                                  '15',
                                                  '16',
                                                  '17',
                                                  '18',
                                                  '19',
                                                  '20',
                                                  '21',
                                                  '22',
                                                  '23',
                                                  '24',
                                                ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  );
                                                }).toList()
                                              : timeperiod[index] == 'Day'
                                                  ? <String>[
                                                      '1',
                                                      '2',
                                                      '3',
                                                      '4',
                                                      '5',
                                                      '6',
                                                      '7',
                                                      '8',
                                                      '9',
                                                      '10',
                                                      '11',
                                                      '12',
                                                      '13',
                                                      '14',
                                                      '15',
                                                      '16',
                                                      '17',
                                                      '18',
                                                      '19',
                                                      '20',
                                                      '21',
                                                      '22',
                                                      '23',
                                                      '24',
                                                      '25',
                                                      '26',
                                                      '27',
                                                      '28',
                                                      '29',
                                                      '30',
                                                      '31',
                                                    ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList()
                                                  : timeperiod[index] == 'Week'
                                                      ? <String>[
                                                          '1',
                                                          '2',
                                                          '3',
                                                          '4',
                                                        ].map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Text(
                                                              value,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList()
                                                      : <String>[
                                                          '1',
                                                          '2',
                                                          '3',
                                                          '4',
                                                          '5',
                                                          '6',
                                                          '7',
                                                          '8',
                                                          '9',
                                                          '10',
                                                          '11',
                                                          '12',
                                                        ].map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Text(
                                                              value,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Delivered Within ${snapshot.data![index]['delivered_within']} |",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    Text(" Free Delivery",
                                        style: TextStyle(color: Colors.green)),
                                  ],
                                ),
                              )
                            ]),
                          );
                        } else {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 3),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      child: CachedNetworkImage(
                                          imageUrl: snapshot.data![index]
                                              ['Images'][0]),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            snapshot.data![index]
                                                ['Material_name'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(snapshot.data![index]
                                              ['Material_type']),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: RatingBar(
                                                  initialRating: snapshot
                                                      .data![index]['rating']
                                                      .toDouble(),
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  ratingWidget: RatingWidget(
                                                    full: Icon(Icons.star,
                                                        color: Colors.amber),
                                                    half: Icon(Icons.star_half,
                                                        color: Colors.amber),
                                                    empty: Icon(Icons.star,
                                                        color: Colors.grey),
                                                  ),
                                                  itemSize: 17,
                                                  ignoreGestures: true,
                                                  onRatingUpdate: (rating) {
                                                    print(rating);
                                                  },
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Text(
                                                "${snapshot.data![index]['rating_count']}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      "₹ ${snapshot.data![index]['Price_per']}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      " / ${snapshot.data![index]['Price_per_unit']}",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 0, 0, 0)
                                                .withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.remove, size: 14),
                                            onPressed: () =>
                                                _decrementQuantity(index),
                                          ),
                                          Text(
                                            '${_quantity[index]}',
                                            style: TextStyle(fontSize: 14.0),
                                          ),
                                          Container(
                                            child: IconButton(
                                              icon: Icon(Icons.add, size: 14),
                                              onPressed: () =>
                                                  _incrementQuantity(index),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Delivered Within ${snapshot.data![index]['delivered_within']}",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
            Container(
              width: width,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("Price Summary")]),
            )
          ],
        ),
      ),
    );
  }

  Future<List<DocumentSnapshot>> _fetchProducts() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('builders')
        .doc(useremail)
        .collection("Cart")
        .get();
    return querySnapshot.docs;
  }
}
