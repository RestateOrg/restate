import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restate/Machinery/Searchpage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MaterialHome extends StatefulWidget {
  const MaterialHome({super.key});

  @override
  State<MaterialHome> createState() => _MaterialHomeState();
}

class _MaterialHomeState extends State<MaterialHome> {
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    DefaultCacheManager().emptyCache();
  }

  String useremail = FirebaseAuth.instance.currentUser?.email ?? '';
  List<DocumentSnapshot> inventory = [];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.amber,
        body: Column(children: [
          Align(
            alignment: Alignment.topCenter,
            child: searchWidget(width, context),
          ),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: fetchCategories(), // Your Future<List<String>> function
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final project = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      child: SingleChildScrollView(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Featured',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    200, // Dynamic height based on screen size
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    // Use constraints to adjust layout dynamically
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: min(5, project.length),
                                      itemBuilder: (context, index) {
                                        return Card(
                                          margin: EdgeInsets.all(8),
                                          clipBehavior: Clip.antiAlias,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: SizedBox(
                                            width: 150,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height:
                                                      constraints.maxHeight *
                                                          0.6,
                                                  width: constraints.maxWidth,
                                                  child: ClipRRect(
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          (project[index].data()
                                                                  as Map<String,
                                                                      dynamic>)[
                                                              'imageURl'],
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                      (project[index].data() as Map<String, dynamic>)[
                                                                      'projectname']
                                                                  .toString()
                                                                  .length >
                                                              17
                                                          ? (project[index].data() as Map<String, dynamic>)[
                                                                      'projectname']
                                                                  .toString()
                                                                  .substring(
                                                                      0, 14) +
                                                              '...'
                                                          : (project[index].data()
                                                                  as Map<String,
                                                                      dynamic>)[
                                                              'projectname'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: 'Roboto',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                (project[index].data() as Map<
                                                                    String,
                                                                    dynamic>)[
                                                                'project requirements']
                                                            .length ==
                                                        0
                                                    ? Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0),
                                                          child: Container(
                                                            width: constraints
                                                                .maxWidth,
                                                            child: Text(
                                                              'No requirements',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0),
                                                          child: Container(
                                                            width: constraints
                                                                .maxWidth,
                                                            child: Text(
                                                              "${(project[index].data() as Map<String, dynamic>)['project requirements'][0]['Item Name']} + ${(project[index].data() as Map<String, dynamic>)['project requirements'].length - 1} more items"
                                                                          .length >
                                                                      35
                                                                  ? "${(project[index].data() as Map<String, dynamic>)['project requirements'][0]['Item Name']} + ${(project[index].data() as Map<String, dynamic>)['project requirements'].length - 1} more items"
                                                                          .substring(
                                                                              0,
                                                                              32) +
                                                                      '...'
                                                                  : (project[index].data() as Map<String, dynamic>)['project requirements'].length -
                                                                              1 ==
                                                                          0
                                                                      ? "${(project[index].data() as Map<String, dynamic>)['project requirements'][0]['Item Name']}"
                                                                      : "${(project[index].data() as Map<String, dynamic>)['project requirements'][0]['Item Name']} + ${(project[index].data() as Map<String, dynamic>)['project requirements'].length - 1} more items",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Inventory',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    210, // Dynamic height based on screen size
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    // Use constraints to adjust layout dynamically
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: min(5, inventory.length),
                                      itemBuilder: (context, index) {
                                        return Card(
                                          margin: EdgeInsets.all(8),
                                          clipBehavior: Clip.antiAlias,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: SizedBox(
                                            width: 200,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height:
                                                      constraints.maxHeight *
                                                          0.6,
                                                  width: constraints.maxWidth,
                                                  child: ClipRRect(
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          (inventory[index]
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>)[
                                                              'Images'][0],
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                      (inventory[index].data() as Map<String, dynamic>)['Material_name']
                                                                  .toString()
                                                                  .length >
                                                              19
                                                          ? (inventory[index].data()
                                                                          as Map<String, dynamic>)[
                                                                      'Material_name']
                                                                  .toString()
                                                                  .substring(
                                                                      0, 17) +
                                                              '...'
                                                          : (inventory[index]
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>)[
                                                              'Material_name'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: 'Roboto',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                      (inventory[index].data() as Map<String, dynamic>)['Material_type']
                                                                  .length >
                                                              25
                                                          ? (inventory[index].data()
                                                                          as Map<String, dynamic>)[
                                                                      'Material_type']
                                                                  .toString()
                                                                  .substring(
                                                                      0, 22) +
                                                              '...'
                                                          : (inventory[index]
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>)[
                                                              'Material_type'],
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'Roboto',
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Status:",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        Spacer(),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 8.0),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2),
                                                              color: (inventory[index].data() as Map<
                                                                              String,
                                                                              dynamic>)[
                                                                          'status'] ==
                                                                      'In Stock'
                                                                  ? Colors.green
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : Colors.red
                                                                      .withOpacity(
                                                                          0.5),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child: Container(
                                                                child: Text(
                                                                  (inventory[index]
                                                                          .data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>)['status'],
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    color: (inventory[index].data() as Map<String, dynamic>)['status'] ==
                                                                            'In Stock'
                                                                        ? const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            11,
                                                                            72,
                                                                            13)
                                                                        : const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            131,
                                                                            35,
                                                                            28),
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
                                              ],
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
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ]));
  }

  GestureDetector searchWidget(double width, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200),
            pageBuilder: (_, __, ___) => SearchPage(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Container(
        width: width * 0.92,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.search, color: Colors.grey),
            ),
            Text('Search', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Future<List<DocumentSnapshot>> fetchCategories() async {
    CollectionReference CollectionRef =
        FirebaseFirestore.instance.collection('builder projects');

    final QuerySnapshot querySnapshot = await CollectionRef.limit(5).get();
    CollectionReference CollectionRef1 = FirebaseFirestore.instance
        .collection('materials')
        .doc(useremail)
        .collection('items');
    final QuerySnapshot querySnapshot1 = await CollectionRef1.limit(5).get();
    inventory = querySnapshot1.docs;
    return querySnapshot.docs;
  }
}
