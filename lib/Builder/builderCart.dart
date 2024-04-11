import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restate/Builder/Searchresults.dart';

class BuilderCart extends StatefulWidget {
  const BuilderCart({Key? key}) : super(key: key);

  @override
  State<BuilderCart> createState() => _BuilderCartState();
}

final useremail = FirebaseAuth.instance.currentUser?.email;
String location = "";
String city = "";
String state = "";
String name = "";
String projecttype = "";
int selectedIndex = 0;
List<QueryDocumentSnapshot> deliverySnapshots = [];

class _BuilderCartState extends State<BuilderCart> {
  void initState() {
    super.initState();
    getDeliveryAddress();
  }

  Future<void> getDeliveryAddress() async {
    CollectionReference collectionReference =
        firestore.collection('builders').doc(useremail).collection('Projects');
    final querySnapshot =
        await collectionReference.orderBy("fromdate", descending: true).get();
    setState(() {
      deliverySnapshots = querySnapshot.docs;
    });
    setState(() {
      location = deliverySnapshots[selectedIndex]['location'];
      city = deliverySnapshots[selectedIndex]['city'];
      state = deliverySnapshots[selectedIndex]['state'];
      name = deliverySnapshots[selectedIndex]['projectname'];
      projecttype = deliverySnapshots[selectedIndex]['projecttype'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 234, 234),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 3),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            width: width,
            child: Column(children: [
              Row(
                children: [
                  Text(
                    "Deliver to:",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.amber[600],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextButton(
                      child: Text(
                        "Change",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              Container(
                width: width,
                child: Text(
                  "$location, $city, $state",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 10),
            ]),
          ),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: _fetchProducts(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data![index]['type'] == 'machinery') {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(bottom: 3),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: Column(children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  snapshot.data![index]['machinery_name'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    snapshot.data![index]['machinery_type'])),
                          ]),
                        );
                      } else {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(bottom: 3),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: Column(children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  snapshot.data![index]['Material_name'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    snapshot.data![index]['Material_type'])),
                          ]),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<DocumentSnapshot>> _fetchProducts() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('builders')
        .doc(useremail)
        .collection("Cart")
        .get();
    return querySnapshot.docs;
  }
}
