import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/Builder/builderProfile.dart';

class BuilderMaterialsDetails extends StatefulWidget {
  // Remove the 'const' keyword from the constructor
  BuilderMaterialsDetails({Key? key, required this.matCatogary})
      : super(key: key);

  final String matCatogary;

  @override
  State<BuilderMaterialsDetails> createState() =>
      _BuilderMaterialsDetailsState();
}

class _BuilderMaterialsDetailsState extends State<BuilderMaterialsDetails> {
  List<DocumentSnapshot> materialSnapshots = [];

  @override
  void initState() {
    super.initState();
    getMaterialsItems();
  }

  Future<void> getMaterialsItems() async {
    try {
      CollectionReference machineryCollectionRef =
          FirebaseFirestore.instance.collection('materials_inventory');

      final querySnapshot = await machineryCollectionRef.get();
      print("Query Snapshots: $querySnapshot");

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          materialSnapshots = querySnapshot.docs
              .where((snapshot) =>
                  snapshot['Material_type'].toLowerCase() ==
                      widget.matCatogary &&
                  snapshot['status'].toLowerCase() == 'in stock')
              .toList();

          if (materialSnapshots.length > 1) {
            materialSnapshots
                .sort((a, b) => b['rating'].compareTo(a['rating']));
          }
        });
      } else {
        print("No data available");
      }
    } catch (e) {
      print("Error getting materials items: $e");
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
              padding: EdgeInsets.only(left: width * 0.04, top: width * 0.04),
              child: Text(
                widget.matCatogary,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            materialSnapshots.any((snapshot) =>
                    snapshot['Material_type'].toLowerCase() ==
                    widget.matCatogary)
                ? SizedBox(
                    height: MediaQuery.of(context).size.height -
                        kToolbarHeight, // Use available height (screen height - app bar height)
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: materialSnapshots.length,
                      itemBuilder: (context, index) {
                        return materialSnapshots[index]['Material_type']
                                    .toLowerCase() ==
                                widget.matCatogary
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
                                          // Set the background color as needed
                                          color: Colors.black26,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: CachedNetworkImage(
                                          key: UniqueKey(),
                                          imageUrl: materialSnapshots[index]
                                                  ['Images'][0] ??
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
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              (materialSnapshots[index]
                                                              ['Material_name']
                                                          .length <
                                                      20)
                                                  ? Text(
                                                      materialSnapshots[index]
                                                          ['Material_name'],
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    )
                                                  : Row(
                                                      children: [
                                                        Text(
                                                          materialSnapshots[
                                                                      index][
                                                                  'Material_name']
                                                              .substring(0, 12),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        Text(
                                                          '....',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              Row(
                                                children: [
                                                  Text(
                                                    materialSnapshots[index]
                                                        ['Material_type'],
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
                                                          FontAwesomeIcons.star,
                                                          color: Colors.amber,
                                                          size: 10,
                                                        ),
                                                        Text(
                                                          "4.5/5",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: 10,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w100,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "₹${materialSnapshots[index]['Price_per']}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      Text(
                                                        " per ${materialSnapshots[index]['Price_per_unit']}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
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
