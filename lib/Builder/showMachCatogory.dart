import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/Builder/builderProfile.dart';

class ShowMachCatogory extends StatefulWidget {
  const ShowMachCatogory({Key? key, required this.categoryName})
      : super(key: key);

  final String categoryName;

  @override
  State<ShowMachCatogory> createState() => _ShowMachCatogoryState();
}

class _ShowMachCatogoryState extends State<ShowMachCatogory> {
  List<DocumentSnapshot> machSnapshots = [];

  @override
  void initState() {
    super.initState();
    getMachineryItems();
  }

  Future<void> getMachineryItems() async {
    try {
      CollectionReference machineryCollectionRef =
          FirebaseFirestore.instance.collection('machinery inventory');

      final querySnapshot = await machineryCollectionRef.get();
      print("Query Snapshots: $querySnapshot");

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          machSnapshots = querySnapshot.docs
              .where((snapshot) =>
                  (snapshot['machinery_type']).toLowerCase() ==
                      widget.categoryName.toLowerCase() &&
                  snapshot['status'].toLowerCase() == 'available')
              .toList();

          if (machSnapshots.length > 1) {
            machSnapshots.sort((a, b) => b['rating'].compareTo(a['rating']));
          }
        });
      } else {
        print("No data available");
      }
    } catch (e) {
      print("Error getting machinery items: $e");
    }
  }

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
          Padding(
            padding: EdgeInsets.only(right: width * 0.03),
            child: FaIcon(
              FontAwesomeIcons.solidBell,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.007),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: width * 0.047, top: width * 0.02),
              child: Container(
                width: width * 0.92,
                child: CupertinoSearchTextField(
                  backgroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  padding: EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.04, top: width * 0.05),
              child: Text(
                (widget.categoryName).toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            machSnapshots.any((snapshot) =>
                    snapshot['machinery_type'].toLowerCase() ==
                    widget.categoryName)
                ? SizedBox(
                    height: MediaQuery.of(context).size.height -
                        kToolbarHeight, // Use available height (screen height - app bar height)
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: machSnapshots.length,
                      itemBuilder: (context, index) {
                        return machSnapshots[index]['machinery_type']
                                    .toLowerCase() ==
                                widget.categoryName
                            ? Card(
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Container(
                                  width: width * 0.5,
                                  height: width * 0.5,
                                  decoration: BoxDecoration(
                                    // Set the background color as needed
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: width * 0.5,
                                        height: width * 0.32,
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: machSnapshots[index]
                                                  ['image_urls'][0] ??
                                              '',
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        width: width * 0.5,
                                        height: width * 0.17,
                                        decoration: BoxDecoration(
                                          // Set the background color as needed
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: width * 0.02),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  machSnapshots[index]
                                                      ['machinery_name'],
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      machSnapshots[index]
                                                          ['machinery_type'],
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 10,
                                                        color: Colors.black26,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: width * 0.15),
                                                      child: Row(
                                                        children: [
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .star,
                                                            color: Colors.amber,
                                                            size: 10,
                                                          ),
                                                          Text(
                                                            machSnapshots[index]
                                                                    ['rating']
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "₹${machSnapshots[index]['hourly']}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        Text(
                                                          '/Hourly',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.amber,
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: width * 0.04),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "₹${machSnapshots[index]['day']}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          Text(
                                                            "/Day",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .amber,
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox.shrink();
                      },
                    ),
                  )
                : Center(child: Text('NO data')),
          ],
        ),
      ),
    );
  }
}
