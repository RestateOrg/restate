import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Searchresults extends StatefulWidget {
  final Query query;
  final String type;
  const Searchresults({Key? key, required this.query, required this.type})
      : super(key: key);

  @override
  State<Searchresults> createState() => _SearchresultsState();
}

class _SearchresultsState extends State<Searchresults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text('Search Results'),
        backgroundColor: Colors.amber,
      ),
      body: widget.type == 'machinery'
          ? StreamBuilder<QuerySnapshot>(
              stream: widget.query.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> data = snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>;
                    return Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Stack(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight * 0.6,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: ClipRRect(
                                    child: Image.network(
                                      data['image_urls'][0],
                                      width: constraints.maxWidth,
                                      height: 100,
                                      fit: BoxFit.cover,
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
                                    height: constraints.maxHeight * 0.4,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(-0.9, 0),
                                            child: Text(
                                              data['machinery_name'].length < 22
                                                  ? data['machinery_name']
                                                  : data['machinery_name']
                                                          .substring(0, 22) +
                                                      '...',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0, top: 8.0),
                                          child: Text(
                                            data['hourly'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
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
                    );
                  },
                );
              },
            )
          : StreamBuilder<QuerySnapshot>(
              stream: widget.query.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Adjust the number of columns as needed
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> data = snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>;
                    return Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Stack(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight * 0.6,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: ClipRRect(
                                    child: Image.network(
                                      data['Images'][0],
                                      width: constraints.maxWidth,
                                      height: 100,
                                      fit: BoxFit.cover,
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
                                    height: constraints.maxHeight * 0.4,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(-0.9, 0),
                                            child: Text(
                                              data['Material_name'].length < 22
                                                  ? data['Material_name']
                                                  : data['Material_name']
                                                          .substring(0, 22) +
                                                      '...',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0, top: 8.0),
                                          child: Text(
                                            "${data['Price_per']} per ${data['Price_per_unit']}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
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
                    );
                  },
                );
              },
            ),
    );
  }
}
