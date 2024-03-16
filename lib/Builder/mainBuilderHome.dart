import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/Builder/Searchpage.dart';

class CardItem {
  final String image;
  final String title;

  CardItem({
    required this.image,
    required this.title,
  });
}

class MainBuilderHome extends StatefulWidget {
  const MainBuilderHome({Key? key});

  @override
  State<MainBuilderHome> createState() => _MainBuilderHomeState();
}

class _MainBuilderHomeState extends State<MainBuilderHome> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  int currentIndex = 0;
  final PageController controller = PageController();
  late Timer timer;

  List<DocumentSnapshot> machSnapshots = [];
  List<DocumentSnapshot> materialSnapshots = [];
  List<DocumentSnapshot> builderSnapshots = [];

  // Initialize the images list
  List<Widget> images = [];

  final User? _user = FirebaseAuth.instance.currentUser;
  final List<String> serviceName = [
    'Project Management',
    'Budget Management',
    'Materials Management',
    'Materials Calculator'
  ];

  final List<String> servImages = [
    'assets/images/proMan.png',
    'assets/images/budgetMan.png',
    'assets/images/matServ.png',
    'assets/images/matServCal.png',
  ];

  @override
  void initState() {
    super.initState();
    getImages();
    getMachineryItems();
    getMaterialsItems();
    startAutoScroll();
    initIndicatorImages(); // Initialize indicator images
  }

  void startAutoScroll() {
    const Duration autoScrollDuration = Duration(seconds: 120);

    timer = Timer.periodic(autoScrollDuration, (Timer t) {
      final nextIndex = (currentIndex + 1) % builderSnapshots.length;
      controller.animateToPage(
        nextIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void initIndicatorImages() {
    images = List.generate(
      builderSnapshots.length,
      (index) => buildIndicator(false),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> getImages() async {
    try {
      CollectionReference buildersRef =
          FirebaseFirestore.instance.collection('builders');

      CollectionReference projectRef =
          buildersRef.doc(_user?.email).collection('Projects');

      final querySnapshot = await projectRef.get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          builderSnapshots = querySnapshot.docs;
        });
      } else {
        print("No data available");
      }
    } catch (e) {
      print("Error getting images: $e");
    }
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
              .where(
                  (snapshot) => snapshot['status'].toLowerCase() == 'available')
              .toList();
          machSnapshots.sort((a, b) => b['rating'].compareTo(a['rating']));
        });
      } else {
        print("No data available");
      }
    } catch (e) {
      print("Error getting machinery items: $e");
    }
  }

  Future<void> getMaterialsItems() async {
    try {
      CollectionReference materialCollectionRef =
          FirebaseFirestore.instance.collection('materials_inventory');

      final querySnapshot = await materialCollectionRef.get();
      print("Query Snapshots: $querySnapshot");

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          materialSnapshots = querySnapshot.docs
              .where(
                  (snapshot) => snapshot['status'].toLowerCase() == 'in stock')
              .toList();
          materialSnapshots.sort((a, b) => b['rating'].compareTo(a['rating']));
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: searchWidget(width, context),
            ),
            Padding(
              padding: EdgeInsets.only(top: width * 0.15),
              child: SizedBox(
                width: double.infinity,
                height: width * 0.65,
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    if (builderSnapshots.isNotEmpty) {
                      final imageUrl =
                          builderSnapshots[index % builderSnapshots.length]
                                  ['imageURl'][0] ??
                              '';
                      return Card(
                        child: Column(
                          children: [
                            Container(
                              width: width,
                              height: width * 0.47,
                              color: Colors.black26,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: width * 0.002),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      builderSnapshots[
                                              index % builderSnapshots.length]
                                          ['projectname'],
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      builderSnapshots[index %
                                          builderSnapshots.length]['location'],
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.02, top: width * 0.85),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Services',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: width * 0.02),
                    child: SizedBox(
                      height: width * 0.36,
                      child: ListView.builder(
                        scrollDirection: Axis
                            .horizontal, // Set scroll direction to horizontal
                        itemCount: servImages.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  showComingSoonDialog(
                                      context, serviceName[index]);
                                },
                                child: Container(
                                  width: width * 0.5,
                                  height: width * 0.3,
                                  child: AspectRatio(
                                    aspectRatio: 4 / 3,
                                    child: Image.asset(
                                      servImages[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                serviceName[index],
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: width * 0.05),
                    child: Text(
                      'Machinery',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: width * 0.02),
                    child: SizedBox(
                      height: 210,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: min(5, machSnapshots.length),
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.all(8),
                              clipBehavior: Clip.antiAlias,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: SizedBox(
                                width: 200,
                                child: Column(
                                  children: [
                                    Container(
                                      height: constraints.maxHeight * 0.6,
                                      width: constraints.maxWidth,
                                      child: ClipRRect(
                                        child: AspectRatio(
                                          aspectRatio: 4 / 3,
                                          child: CachedNetworkImage(
                                            imageUrl: (machSnapshots[index]
                                                        .data()
                                                    as Map<String, dynamic>)[
                                                'image_urls'][0],
                                            // fit: BoxFit.cover,
                                            placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: width * 0.05),
                    child: Text(
                      'Materials',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: width * 0.02),
                    child: SizedBox(
                      height: width * 0.35,
                      child: ListView.builder(
                        scrollDirection: Axis
                            .horizontal, // Set scroll direction to horizontal
                        itemCount: min(5, materialSnapshots.length),
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              width: width * 0.5,
                              height: width * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.5,
                                    height: width * 0.22,
                                    decoration: BoxDecoration(
                                      // Set the background color as needed
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: CachedNetworkImage(
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
                                    height: width * 0.13,
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
                                        padding:
                                            EdgeInsets.only(left: width * 0.02),
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
                                                        materialSnapshots[index]
                                                                [
                                                                'Material_name']
                                                            .substring(0, 12),
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      Text(
                                                        '....',
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            Row(
                                              children: [
                                                (materialSnapshots[index][
                                                                'Material_type']
                                                            .length <=
                                                        5)
                                                    ? Text(
                                                        materialSnapshots[index]
                                                            ['Material_type'],
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 10,
                                                          color: Colors.black26,
                                                          fontWeight:
                                                              FontWeight.w100,
                                                        ),
                                                      )
                                                    : Row(
                                                        children: [
                                                          Text(
                                                            materialSnapshots[
                                                                        index][
                                                                    'Material_type']
                                                                .substring(
                                                                    0, 4),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .black26,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                            ),
                                                          )
                                                        ],
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
                                                        "${materialSnapshots[index]['rating']}/5",
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
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
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "₹${materialSnapshots[index]['Price_per']}",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Text(
                                                      "/${materialSnapshots[index]['Price_per_unit']}",
                                                      style: TextStyle(
                                                          color: Colors.amber,
                                                          fontFamily: 'Roboto',
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: width * 0.08),
                                                  child: (materialSnapshots[
                                                                      index]
                                                                  ['Brand_name']
                                                              .length <
                                                          9)
                                                      ? Text(
                                                          "${materialSnapshots[index]['Brand_name']}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )
                                                      : Row(
                                                          children: [
                                                            Text(
                                                              materialSnapshots[
                                                                          index]
                                                                      [
                                                                      'Brand_name']
                                                                  .substring(
                                                                      0, 9),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            )
                                                          ],
                                                        ),
                                                ),
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
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        height: isSelected ? 12 : 10,
        width: isSelected ? 12 : 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.black : Colors.amber,
        ),
      ),
    );
  }

  void showComingSoonDialog(BuildContext context, String serviceName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Coming Soon'),
          content: Text('The $serviceName service is coming soon!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
  //Null onTap() => null;
}

void main() {
  runApp(MaterialApp(
    home: MainBuilderHome(),
  ));
}
