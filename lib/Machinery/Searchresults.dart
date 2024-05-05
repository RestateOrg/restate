import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restate/Machinery/ProjectDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Searchresults extends StatefulWidget {
  final Query query;
  final String searchkey;
  const Searchresults({Key? key, required this.query, required this.searchkey})
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
            Navigator.pop(context);
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
      body: Column(
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
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisExtent: 370,
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
                            builder: (context) => ProjectDetails(
                              data: data,
                            ),
                          ),
                        );
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
                          color: Colors.amber,
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
                                      height: constraints.maxHeight * 0.65,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: ClipRRect(
                                        child: CachedNetworkImage(
                                          key: UniqueKey(),
                                          imageUrl: data['imageURl'],
                                          width: constraints.maxWidth,
                                          height: 100,
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0.0),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: constraints.maxWidth,
                                        height: constraints.maxHeight * 0.35,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0, left: 8),
                                                  child: Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.67,
                                                    child: Text(
                                                      data['projectname']
                                                                  .length >
                                                              30
                                                          ? data['projectname']
                                                                  .substring(
                                                                      0, 30) +
                                                              '...'
                                                          : data['projectname'],
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.9, 0),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10,
                                                          right: 8,
                                                          top: 5),
                                                      child: Container(
                                                        color: Colors.black12,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Text(
                                                            data['projecttype'],
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0, left: 8),
                                                child: Container(
                                                  width: constraints.maxWidth *
                                                      0.67,
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: "Location: ",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: 'Roboto',
                                                          color: Colors.black),
                                                      children: [
                                                        TextSpan(
                                                          text: data['location']
                                                                      .length >
                                                                  30
                                                              ? data['location']
                                                                      .substring(
                                                                          0,
                                                                          30) +
                                                                  '...'
                                                              : data[
                                                                  'location'],
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  'Roboto',
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 5, left: 8),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: "Requirements: ",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'Roboto',
                                                        color: Colors.black,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "${data["project requirements"][0]["Item Name"]}+${data["project requirements"].length - 1} more",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                'Roboto',
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0, left: 8),
                                                  child: Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.80,
                                                    child: Text(
                                                      data['projectdescription']
                                                                  .length >
                                                              70
                                                          ? data['projectdescription']
                                                                  .substring(
                                                                      0, 70) +
                                                              '...'
                                                          : data[
                                                              'projectdescription'],
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: 'Roboto',
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
