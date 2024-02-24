import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restate/Machinery/Searchpage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MachineryHome extends StatefulWidget {
  const MachineryHome({super.key});

  @override
  State<MachineryHome> createState() => _MachineryHomeState();
}

class _MachineryHomeState extends State<MachineryHome> {
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    DefaultCacheManager().emptyCache();
  }

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
                                  180, // Dynamic height based on screen size
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
                                          width: constraints.maxWidth * 0.4,
                                          child: Column(
                                            children: [
                                              Container(
                                                height:
                                                    constraints.maxHeight * 0.6,
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
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
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
    final QuerySnapshot querySnapshot = await CollectionRef.get();
    return querySnapshot.docs;
  }
}
