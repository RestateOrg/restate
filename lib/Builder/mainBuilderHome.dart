import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/Builder/ProductDetails.dart';
import 'package:restate/Builder/Searchpage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:restate/Utils/find_Image_DImentions.dart';

class MainBuilderHome extends StatefulWidget {
  const MainBuilderHome({Key? key});

  @override
  State<MainBuilderHome> createState() => _MainBuilderHomeState();
}

class _MainBuilderHomeState extends State<MainBuilderHome> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  int currentIndex = 0;

  final PageController _pageController = PageController(initialPage: 0);
  late Timer timer;

  List<DocumentSnapshot> machSnapshots = [];
  List<DocumentSnapshot> materialSnapshots = [];
  List<DocumentSnapshot> builderSnapshots = [];

  // Initialize the images list
  List<Widget> images = [];
  List<int> builder_image_height = [];
  List<int> builder_image_width = [];
  List<int> machinery_image_height = [];
  List<int> machinery_image_width = [];
  List<int> material_image_height = [];
  List<int> material_image_width = [];

  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getImages();
    getMachineryItems();
    getMaterialsItems();
    startTimer();
    //startAutoScroll();
  }

  @override
  void dispose() {
    super.dispose();
    DefaultCacheManager().emptyCache();
    timer.cancel();
  }

  Future<void> getImages() async {
    try {
      CollectionReference buildersRef =
          FirebaseFirestore.instance.collection('builders');

      CollectionReference projectRef =
          buildersRef.doc(_user?.email).collection('Projects');

      final querySnapshot = await projectRef.get();
      print("Query Snapshots: $querySnapshot");

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          builderSnapshots = querySnapshot.docs;
          builder_image_height.clear();
          builder_image_width.clear();
        });

        for (int i = 0; i < builderSnapshots.length; i++) {
          try {
            final dimensions =
                await FindImgDimen(imageUrl: builderSnapshots[i]['imageURl'])
                    .getImageDimensions();
            setState(() {
              builder_image_width.add(dimensions['width'] ?? 0);
              builder_image_height.add(dimensions['height'] ?? 0);
            });
          } catch (e) {
            print("Error getting image dimensions for project ${i + 1}: $e");
          }
        }
      } else {
        print("No data available");
      }
    } catch (e) {
      print("Error getting images: $e");
    }
  }

  void startAutoScroll() {
    const Duration autoScrollDuration = Duration(seconds: 10);

    timer = Timer.periodic(autoScrollDuration, (Timer t) {
      final nextIndex = (currentIndex + 1) % builderSnapshots.length;
      _pageController.animateToPage(
        nextIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (builderSnapshots.isNotEmpty) {
        if (currentIndex == builderSnapshots.length - 1) {
          _pageController.animateToPage(0,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        } else {
          _pageController.nextPage(
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        }
      } else {
        print('empty');
      }
    });
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
          machinery_image_height
              .clear(); // Clear existing heights before fetching new ones
          machinery_image_width
              .clear(); // Clear existing widths before fetching new ones
        });

        // Fetch image dimensions after populating machSnapshots
        for (int i = 0; i < machSnapshots.length; i++) {
          try {
            final dimensions =
                await FindImgDimen(imageUrl: machSnapshots[i]['image_urls'][0])
                    .getImageDimensions();
            setState(() {
              machinery_image_width.add(dimensions['width'] ?? 0);
              machinery_image_height.add(dimensions['height'] ?? 0);
            });
          } catch (e) {
            print("Error getting image dimensions for machinery ${i + 1}: $e");
          }
        }
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
          material_image_height.clear();
          material_image_width.clear();
        });
        // Fetch image dimensions after populating machSnapshots
        for (int i = 0; i < materialSnapshots.length; i++) {
          try {
            final dimensions =
                await FindImgDimen(imageUrl: materialSnapshots[i]['Images'][0])
                    .getImageDimensions();
            setState(() {
              material_image_width.add(dimensions['width'] ?? 0);
              material_image_height.add(dimensions['height'] ?? 0);
            });
          } catch (e) {
            print("Error getting image dimensions for machinery ${i + 1}: $e");
          }
        }
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
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          await getImages();
          await getMachineryItems();
          await getMaterialsItems();
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width,
                    color: Colors.amber,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: searchWidget(width, context),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: Container(
                                color: Colors.white,
                                width: double.infinity,
                                height: width * 0.55,
                                child: builderSnapshots.isEmpty
                                    ? Center(
                                        child: Text("No Projects Yet"),
                                      )
                                    : builder_image_height.length !=
                                            builderSnapshots.length
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : PageView.builder(
                                            controller: _pageController,
                                            itemCount: builderSnapshots.length,
                                            onPageChanged: (value) {
                                              setState(() {
                                                currentIndex = value;
                                              });
                                            },
                                            itemBuilder: (context, index) {
                                              if (builderSnapshots.isEmpty) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }

                                              final imageUrl = builderSnapshots[
                                                  index %
                                                      builderSnapshots
                                                          .length]['imageURl'];
                                              final h =
                                                  builder_image_height[index];
                                              final w =
                                                  builder_image_width[index];

                                              return _buildImageItem(
                                                context,
                                                imageUrl,
                                                h,
                                                w,
                                              );
                                            },
                                          ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: width * 0.57),
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List<Widget>.generate(
                                    builderSnapshots.length,
                                    (index) => Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          _pageController.animateToPage(index,
                                              duration:
                                                  Duration(microseconds: 300),
                                              curve: Curves.easeIn);
                                        },
                                        child: CircleAvatar(
                                          radius: 4,
                                          backgroundColor: currentIndex == index
                                              ? Colors.amber
                                              : Colors.black,
                                          // foregroundColor: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.02),
                    child: Text(
                      'Services',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    height: width * 0.35,
                    //color: Colors.yellow,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              showComingSoonDialog(
                                  context, "Project Management");
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.amber,
                                  child: SizedBox(
                                    width: 60,
                                    height: 40,
                                    child: Image.asset(
                                      'assets/images/services/serviePro.png',
                                    ),
                                  ),
                                ),
                                // Tab()
                                Text(
                                  'Project',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Management',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              showComingSoonDialog(
                                  context, 'Material Calculator');
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.amber,
                                  child: Container(
                                    width: 50,
                                    height: 40,
                                    child: Image.asset(
                                      'assets/images/services/materialCaluclator.png',
                                    ),
                                  ),
                                ),
                                Text(
                                  'Material',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Calculator',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              showComingSoonDialog(
                                  context, 'Material Management');
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.amber,
                                  child: Container(
                                    width: 50,
                                    height: 40,
                                    child: Image.asset(
                                      'assets/images/services/materialManagement.png',
                                    ),
                                  ),
                                ),
                                Text(
                                  'Material',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Management',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              showComingSoonDialog(
                                  context, 'Budget Calculator');
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.amber,
                                  child: Container(
                                    width: 50,
                                    height: 40,
                                    child: Image.asset(
                                      'assets/images/services/budgetCalculator.png',
                                    ),
                                  ),
                                ),
                                Text(
                                  'Budget',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Calculator',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    height: width * 0.7,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(55, 253, 198, 0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.02,
                            top: width * 0.02,
                          ),
                          child: Text(
                            'Machinery',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        (machinery_image_height.length != machSnapshots.length)
                            ? Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: width * 0.02),
                                child: SizedBox(
                                  height: 210,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: min(5, machSnapshots.length),
                                        itemBuilder: (context, index) {
                                          final image = machSnapshots[index]
                                              ['image_urls'][0];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetails(
                                                    data: machSnapshots[index]
                                                            .data()
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
                                                      height: constraints
                                                              .maxHeight *
                                                          0.6,
                                                      width:
                                                          constraints.maxWidth,
                                                      child: ClipRRect(
                                                        child:
                                                            CachedNetworkImage(
                                                          key: UniqueKey(),
                                                          imageUrl: image,
                                                          fit: ((machinery_image_width[
                                                                          index] >
                                                                      machinery_image_height[
                                                                          index]) ||
                                                                  (machinery_image_width[
                                                                          index] ==
                                                                      machinery_image_height[
                                                                          index]))
                                                              ? BoxFit.cover
                                                              : null, //BoxFit.none
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
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0),
                                                        child: Text(
                                                          machSnapshots[index][
                                                                          'machinery_name']
                                                                      .toString()
                                                                      .length >
                                                                  19
                                                              ? machSnapshots[index]
                                                                          [
                                                                          'machinery_name']
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          17) +
                                                                  '...'
                                                              : machSnapshots[
                                                                      index][
                                                                  'machinery_name'],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8.0),
                                                            child: Text(
                                                              machSnapshots[
                                                                      index][
                                                                  'machinery_type'],
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 8.0),
                                                          child: Row(
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .star,
                                                                color: Colors
                                                                    .amber,
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
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8.0),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    "₹${machSnapshots[index]['hourly']}"),
                                                                Text(
                                                                  '/Hour',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .amber,
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
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 8.0),
                                                          child: Row(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "₹${machSnapshots[index]['day']}",
                                                                    style:
                                                                        TextStyle(
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
                                  ),
                                ),
                              ),
                      ],
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
                  //Text((material_image_height.length).toString()),
                  Container(
                    width: width,
                    height: width * 0.7,
                    child: (material_image_height.length !=
                            materialSnapshots.length)
                        ? Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: width * 0.02),
                            child: SizedBox(
                              height: 210,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: min(5, materialSnapshots.length),
                                    itemBuilder: (context, index) {
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
                                                      constraints.maxHeight *
                                                          0.6,
                                                  width: constraints.maxWidth,
                                                  child: ClipRRect(
                                                    child: CachedNetworkImage(
                                                      key: UniqueKey(),
                                                      imageUrl:
                                                          materialSnapshots[
                                                                  index]
                                                              ['Images'][0],
                                                      fit: ((material_image_width[
                                                                      index] >
                                                                  material_image_height[
                                                                      index]) ||
                                                              (material_image_width[
                                                                      index] ==
                                                                  material_image_height[
                                                                      index]))
                                                          ? BoxFit.cover
                                                          : null,
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
                                                      materialSnapshots[index][
                                                                      'Material_name']
                                                                  .toString()
                                                                  .length >
                                                              19
                                                          ? materialSnapshots[
                                                                          index]
                                                                      [
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
                                                        padding:
                                                            EdgeInsets.only(
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
                                                                          0,
                                                                          17) +
                                                                  '...'
                                                              : materialSnapshots[
                                                                      index][
                                                                  'Material_type'],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.grey),
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
                                                            FontAwesomeIcons
                                                                .star,
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
                                                                ? materialSnapshots[index]
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
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Roboto',
                                                                color: Colors
                                                                    .grey),
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
                                                                style:
                                                                    TextStyle(
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
                              ),
                            ),
                          ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageItem(
      BuildContext context, String image, int imgHeight, int imgWidth) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.53,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            color: Colors.white,
            child: ((imgHeight == 0) || (imgWidth == 0))
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : CachedNetworkImage(
                    key: UniqueKey(),
                    imageUrl: image,
                    fit: (imgWidth > imgHeight) || (imgHeight == imgWidth)
                        ? BoxFit.cover
                        : null,
                  ),
          ),
        ),
      ],
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
