import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:restate/Machinery/editpage.dart';
import 'package:restate/Machinery/productinfo.dart';

class MachineryInventory extends StatefulWidget {
  const MachineryInventory({super.key});

  @override
  State<MachineryInventory> createState() => _MachineryInventoryState();
}

class _MachineryInventoryState extends State<MachineryInventory> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String useremail; // Use 'late' to initialize later
  late CollectionReference collectionRef; // Initialize later as well
  List<DocumentSnapshot> allSnapshots = [];
  List<DocumentSnapshot> filteredSnapshots = [];
  CollectionReference CollectionRef =
      FirebaseFirestore.instance.collection('machinery inventory');
  @override
  void initState() {
    super.initState();

    useremail =
        FirebaseAuth.instance.currentUser?.email ?? ''; // Assign in initState
    collectionRef = firestore
        .collection('machinery')
        .doc(useremail)
        .collection('inventory');
    fetchData(); // Fetch data after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Clear the image cache when the page is popped
      CachedNetworkImageProvider('', cacheManager: DefaultCacheManager())
          .evict();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const Duration delay = Duration(milliseconds: 3);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: width,
            color: Colors.amber,
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: Container(
                width: width * 0.92,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: CupertinoSearchTextField(
                  backgroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  padding: EdgeInsets.all(10),
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        // If the search query is empty, show all items
                        filteredSnapshots = allSnapshots; // Use the normal list
                      } else {
                        // filter the list based on Material_type
                        filteredSnapshots = allSnapshots
                            .where((element) => (element.data()
                                    as Map<String, dynamic>)['machinery_name']
                                .toString()
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.03),
                child: Text(
                  "Your Inventory",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                Future.delayed(delay, () {
                  setState(() {
                    collectionRef = firestore
                        .collection('machinery')
                        .doc(useremail)
                        .collection('inventory');
                    fetchData();
                  });
                });
              },
              child: ListView.builder(
                itemCount: filteredSnapshots.length,
                itemBuilder: (context, index) {
                  final snapshot = filteredSnapshots[index];
                  int length = (snapshot.data()
                          as Map<String, dynamic>)['machinery_name']
                      .length;
                  return Padding(
                    padding: (index == filteredSnapshots.length - 1)
                        ? EdgeInsets.only(bottom: width * 0.2)
                        : EdgeInsets.only(bottom: 0),
                    child: Container(
                      color: index % 2 != 0
                          ? const Color.fromARGB(40, 253, 197, 0)
                          : const Color.fromARGB(0, 255, 255, 255),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductInfo(
                                  data: snapshot.data() as Map<String, dynamic>,
                                  type: "machinery"),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.all(width * 0.03),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.black, // Set the border color
                                width: 0.2,
                                // Set the border width
                              ),
                            ),
                            height: width * 0.9,
                            child: Column(
                              children: [
                                Container(
                                  height: width * 0.65,
                                  width: width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12)),
                                    color: Colors.black12,
                                  ),
                                  child: CachedNetworkImage(
                                    key: UniqueKey(),
                                    imageUrl: (snapshot.data() as Map<String,
                                        dynamic>)['image_urls'][0],
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.black.withOpacity(0.5)),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                            child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.error),
                                        Text('Error loading image'),
                                      ],
                                    )),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 5.0, left: 8.0, right: 8.0),
                                          child: Text(
                                            length > 19
                                                ? (snapshot.data() as Map<
                                                                String,
                                                                dynamic>)[
                                                            'machinery_name']
                                                        .substring(
                                                            0,
                                                            min<int>(
                                                                16,
                                                                (snapshot.data() as Map<
                                                                            String,
                                                                            dynamic>)[
                                                                        'machinery_name']
                                                                    .length)) +
                                                    "..."
                                                : (snapshot.data() as Map<
                                                    String,
                                                    dynamic>)['machinery_name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: width * 0.04,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 5.0,
                                            left: 3.0,
                                          ),
                                          child: Container(
                                            height: width * 0.06,
                                            width: width * 0.17,
                                            decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(2)),
                                            child: Center(
                                                child: Text(
                                              (snapshot.data() as Map<String,
                                                  dynamic>)['machinery_type'],
                                              style: TextStyle(
                                                fontSize: (snapshot.data() as Map<
                                                                    String,
                                                                    dynamic>)[
                                                                'machinery_type']
                                                            .toString()
                                                            .length <=
                                                        17
                                                    ? width * 0.02
                                                    : width * 0.015,
                                                fontFamily: 'Roboto',
                                              ),
                                            )),
                                          ),
                                        ),
                                        Flexible(
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(1, 0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditPage(
                                                            snapshot: snapshot),
                                                    settings: RouteSettings(
                                                        arguments: snapshot),
                                                  ),
                                                );
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: width * 0.015,
                                                left: width * 0.02),
                                            child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductInfo(
                                                              data: snapshot
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>,
                                                              type:
                                                                  "machinery"),
                                                    ),
                                                  );
                                                },
                                                child:
                                                    Icon(Icons.info, size: 20)),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: width * 0.015,
                                                left: width * 0.02),
                                            child: GestureDetector(
                                                onTap: () async {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text('Delete'),
                                                          content: Text(
                                                              'Do You Want to Delete this Item?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(
                                                                  'Cancel'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // Dismiss the dialog
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text(
                                                                  'Delete'),
                                                              onPressed:
                                                                  () async {
                                                                final documentRef =
                                                                    snapshot
                                                                        .reference;

                                                                for (int i = 0;
                                                                    i <
                                                                        (snapshot.data()
                                                                                as Map<String, dynamic>)['image_urls']
                                                                            .length;
                                                                    i++) {
                                                                  firebase_storage
                                                                      .FirebaseStorage
                                                                      .instance
                                                                      .refFromURL((snapshot
                                                                              .data()
                                                                          as Map<
                                                                              String,
                                                                              dynamic>)['image_urls'][i])
                                                                      .delete();
                                                                }
                                                                Query query = CollectionRef.where(
                                                                    'image_urls',
                                                                    isEqualTo: ((snapshot
                                                                            .data()
                                                                        as Map<
                                                                            String,
                                                                            dynamic>)['image_urls']));
                                                                query.get().then(
                                                                    (QuerySnapshot
                                                                        snapshot) async {
                                                                  if (snapshot
                                                                      .docs
                                                                      .isNotEmpty) {
                                                                    for (DocumentSnapshot document
                                                                        in snapshot
                                                                            .docs) {
                                                                      final documentId =
                                                                          document
                                                                              .reference;
                                                                      await documentId
                                                                          .delete();
                                                                    }
                                                                  } else {
                                                                    print(
                                                                        'No documents found with the matching image URL.');
                                                                  }
                                                                });

                                                                await documentRef
                                                                    .delete();
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        'Document deleted!'),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            1),
                                                                  ),
                                                                );
                                                                Future.delayed(
                                                                    delay, () {
                                                                  setState(() {
                                                                    collectionRef = firestore
                                                                        .collection(
                                                                            'machinery')
                                                                        .doc(
                                                                            useremail)
                                                                        .collection(
                                                                            'inventory');
                                                                    fetchData();
                                                                  });
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: Icon(Icons.delete,
                                                    size: 20)),
                                          ),
                                        )
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: width * 0.025),
                                        child: Text("Price",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: width * 0.036,
                                                fontFamily: 'Roboto')),
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: width * 0.025),
                                            child: Text(
                                              '₹ ${(snapshot.data() as Map<String, dynamic>)['hourly']} Per Hour',
                                              style: TextStyle(
                                                  fontSize: width * 0.033,
                                                  fontWeight: FontWeight.w100),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: width * 0.025,
                                                top: width * 0.05),
                                            child: Text(
                                              '₹ ${(snapshot.data() as Map<String, dynamic>)['day']} Per Day',
                                              style: TextStyle(
                                                  fontSize: width * 0.033,
                                                  fontWeight: FontWeight.w100),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: width * 0.09),
                                            child: Text(
                                              'Status',
                                              style: TextStyle(
                                                  fontSize: width * 0.037,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: width * 0.03,
                                                  top: width * 0.05),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    color: (snapshot.data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>)[
                                                                'status'] ==
                                                            'Available'
                                                        ? Colors.green
                                                            .withOpacity(0.4)
                                                        : Colors.red
                                                            .withOpacity(0.4),
                                                  ),
                                                  width: width * 0.17,
                                                  height: width * 0.05,
                                                  child: Center(
                                                    child: Text(
                                                      (snapshot.data() as Map<
                                                          String,
                                                          dynamic>)['status'],
                                                      style: TextStyle(
                                                          fontSize:
                                                              width * 0.025,
                                                          fontWeight:
                                                              FontWeight.w100,
                                                          color: (snapshot.data() as Map<
                                                                          String,
                                                                          dynamic>)[
                                                                      'status'] ==
                                                                  'Available'
                                                              ? Colors.green
                                                                  .shade900
                                                              : Colors.red
                                                                  .shade900),
                                                    ),
                                                  ))),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      final querySnapshot =
          await collectionRef.orderBy('timestamp', descending: true).get();
      setState(() {
        allSnapshots = querySnapshot.docs;
        filteredSnapshots = querySnapshot.docs;
      });
    } catch (error) {}
  }
}
