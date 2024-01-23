import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        children: [
          CupertinoSearchTextField(
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
                              as Map<String, dynamic>)['Material_type']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                }
              });
            },
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
            child: ListView.builder(
              itemCount: filteredSnapshots.length,
              itemBuilder: (context, index) {
                final snapshot = filteredSnapshots[index];
                return Card(
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
                          child: Image.network((snapshot.data()
                              as Map<String, dynamic>)['image_urls'][0]),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 5.0, left: 8.0, right: 8.0),
                                  child: Text(
                                    (snapshot.data() as Map<String, dynamic>)[
                                        'machinery_name'],
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
                                    right: 7 *
                                            (17 -
                                                (snapshot.data() as Map<String,
                                                            dynamic>)[
                                                        'machinery_name']
                                                    .toString()
                                                    .length
                                                    .toDouble()) +
                                        8,
                                  ),
                                  child: Container(
                                    height: width * 0.06,
                                    width: width * 0.17,
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(2)),
                                    child: Center(
                                        child: Text(
                                      (snapshot.data() as Map<String, dynamic>)[
                                          'machinery_type'],
                                      style: TextStyle(
                                        fontSize: (snapshot.data() as Map<
                                                            String, dynamic>)[
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
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          top: width * 0.015,
                                          left: width * 0.25),
                                      child: Icon(
                                        Icons.edit,
                                        size: 20,
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: width * 0.015, left: width * 0.01),
                                    child: Icon(Icons.info, size: 20),
                                  ),
                                )
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: width * 0.025),
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
                                    padding:
                                        EdgeInsets.only(left: width * 0.025),
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
                                        left: width * 0.025, top: width * 0.05),
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
                                    padding:
                                        EdgeInsets.only(right: width * 0.09),
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
                                                BorderRadius.circular(2),
                                            color: (snapshot.data() as Map<
                                                        String,
                                                        dynamic>)['status'] ==
                                                    'Available'
                                                ? Colors.green.withOpacity(0.4)
                                                : Colors.red.withOpacity(0.4),
                                          ),
                                          width: width * 0.17,
                                          height: width * 0.05,
                                          child: Center(
                                            child: Text(
                                              (snapshot.data() as Map<String,
                                                  dynamic>)['status'],
                                              style: TextStyle(
                                                  fontSize: width * 0.025,
                                                  fontWeight: FontWeight.w100,
                                                  color: (snapshot.data()
                                                                  as Map<String,
                                                                      dynamic>)[
                                                              'status'] ==
                                                          'Available'
                                                      ? Colors.green.shade900
                                                      : Colors.red.shade900),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      final querySnapshot = await collectionRef.get();
      setState(() {
        allSnapshots = querySnapshot.docs;
        filteredSnapshots = querySnapshot.docs;
      });
    } catch (error) {}
  }
}
