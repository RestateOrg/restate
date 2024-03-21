import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/Builder/ProductDetails.dart';
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
      body: RefreshIndicator(
        onRefresh: () async {
          await getImages();
          setState(() {});
        },
        child: SingleChildScrollView(
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
                        currentIndex =
                            (index % builderSnapshots.length).toInt();
                      });
                    },
                    itemBuilder: (context, index) {
                      if (builderSnapshots.isNotEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: width * 0.8,
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: width,
                                    height: width * 0.47,
                                    color: Colors.black26,
                                    child: CachedNetworkImage(
                                      imageUrl: builderSnapshots[index %
                                          builderSnapshots.length]['imageURl'],
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          builderSnapshots[index %
                                                  builderSnapshots.length]
                                              ['projectname'],
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          builderSnapshots[index %
                                                  builderSnapshots.length]
                                              ['location'],
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
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
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: min(5, machSnapshots.length),
                              itemBuilder: (context, index) {
                                return FutureBuilder<Map<String, int>>(
                                  future: getImageDimensions(
                                      machSnapshots[index]['image_urls'][0]),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.waiting ||
                                        !snapshot.hasData) {
                                      return Container();
                                    }

                                    final imageDimensions = snapshot.data!;
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                              data: machSnapshots[index].data()
                                                  as Map<String, dynamic>,
                                              type: "machinery",
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
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
                                                    constraints.maxHeight * 0.6,
                                                width: constraints.maxWidth,
                                                child: ClipRRect(
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        machSnapshots[index]
                                                            ['image_urls'][0],
                                                    fit: ((imageDimensions[
                                                                    'width']! >
                                                                imageDimensions[
                                                                    'height']!) ||
                                                            (imageDimensions[
                                                                    'width']! ==
                                                                imageDimensions[
                                                                    'height']!))
                                                        ? BoxFit.cover
                                                        : null, //BoxFit.none
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    machSnapshots[index][
                                                                    'machinery_name']
                                                                .toString()
                                                                .length >
                                                            19
                                                        ? machSnapshots[index][
                                                                    'machinery_name']
                                                                .toString()
                                                                .substring(
                                                                    0, 17) +
                                                            '...'
                                                        : machSnapshots[index]
                                                            ['machinery_name'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                        machSnapshots[index]
                                                            ['machinery_type'],
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Roboto',
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Row(
                                                      children: [
                                                        FaIcon(
                                                          FontAwesomeIcons.star,
                                                          color: Colors.amber,
                                                          size: 15,
                                                        ),
                                                        Text(
                                                          "${machSnapshots[index]['rating']}/5",
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                              "₹${machSnapshots[index]['hourly']}"),
                                                          Text(
                                                            '/Hour',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.amber,
                                                              fontFamily:
                                                                  'Roboto',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "₹${machSnapshots[index]['day']}",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                              ),
                                                            ),
                                                            Text(
                                                              '/Day',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .amber,
                                                                  fontFamily:
                                                                      'Roboto'),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
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
                        height: 210,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: min(5, materialSnapshots.length),
                              itemBuilder: (context, index) {
                                return FutureBuilder<Map<String, int>>(
                                  future: getImageDimensions(
                                      materialSnapshots[index]['Images'][0]),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.waiting ||
                                        !snapshot.hasData) {
                                      return Container();
                                    }

                                    final imageDimensions = snapshot.data!;
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                              data: materialSnapshots[index]
                                                      .data()
                                                  as Map<String, dynamic>,
                                              type: "materials",
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
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
                                                    constraints.maxHeight * 0.6,
                                                width: constraints.maxWidth,
                                                child: ClipRRect(
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        materialSnapshots[index]
                                                            ['Images'][0],
                                                    fit: ((imageDimensions[
                                                                    'width']! >
                                                                imageDimensions[
                                                                    'height']!) ||
                                                            (imageDimensions[
                                                                    'width']! ==
                                                                imageDimensions[
                                                                    'height']!))
                                                        ? BoxFit.cover
                                                        : null,
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    materialSnapshots[index][
                                                                    'Material_name']
                                                                .toString()
                                                                .length >
                                                            19
                                                        ? materialSnapshots[
                                                                        index][
                                                                    'Material_name']
                                                                .toString()
                                                                .substring(
                                                                    0, 17) +
                                                            '...'
                                                        : materialSnapshots[
                                                                index]
                                                            ['Material_name'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                        materialSnapshots[index]
                                                                        [
                                                                        'Material_type']
                                                                    .toString()
                                                                    .length >
                                                                19
                                                            ? materialSnapshots[
                                                                            index]
                                                                        [
                                                                        'Material_type']
                                                                    .toString()
                                                                    .substring(
                                                                        0, 17) +
                                                                '...'
                                                            : materialSnapshots[
                                                                    index][
                                                                'Material_type'],
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Roboto',
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Row(
                                                      children: [
                                                        FaIcon(
                                                          FontAwesomeIcons.star,
                                                          color: Colors.amber,
                                                          size: 15,
                                                        ),
                                                        Text(
                                                          "${materialSnapshots[index]['rating']}/5",
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8.0),
                                                        child: Text(
                                                          materialSnapshots[index]
                                                                          [
                                                                          'Brand_name']
                                                                      .toString()
                                                                      .length >
                                                                  19
                                                              ? materialSnapshots[
                                                                              index]
                                                                          [
                                                                          'Brand_name']
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          17) +
                                                                  '...'
                                                              : materialSnapshots[
                                                                      index][
                                                                  'Brand_name'],
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.grey),
                                                        )),
                                                  ),
                                                  Spacer(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "₹${materialSnapshots[index]['Price_per']}",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto',
                                                              ),
                                                            ),
                                                            Text(
                                                              "/${materialSnapshots[index]['Price_per_unit']}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .amber,
                                                                  fontFamily:
                                                                      'Roboto'),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
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

  Future<Map<String, int>> getImageDimensions(String imageUrl) async {
    try {
      final completer = Completer<ImageInfo>();
      final listener = ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info);
      });

      final ImageStream stream = CachedNetworkImageProvider(imageUrl)
          .resolve(ImageConfiguration(size: Size(200, 150)));
      stream.addListener(listener);

      final info = await completer.future;
      stream.removeListener(listener);

      return {
        'width': info.image.width,
        'height': info.image.height,
      };
    } catch (e) {
      print('Error fetching image dimensions: $e');
      return {'width': 0, 'height': 0};
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: MainBuilderHome(),
  ));
}
