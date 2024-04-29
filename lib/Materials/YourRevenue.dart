import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class YourRevenue extends StatefulWidget {
  @override
  _YourRevenueState createState() => _YourRevenueState();
}

String? useremail = FirebaseAuth.instance.currentUser?.email;

class _YourRevenueState extends State<YourRevenue> {
  void initState() {
    getRevenue();
    super.initState();
  }

  List<DocumentSnapshot> orders = [];
  num revenue = 0;
  Map<String, dynamic> products = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(252, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text('Your Revenue'),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'Total Revenue',
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  Text(
                    ' ₹$revenue',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      'Total Orders',
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    Text(
                      '${orders.length}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 5),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Average Revenue Per Order',
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),
                      Text(
                        orders.length != 0
                            ? ' ₹${revenue ~/ orders.length}'
                            : '0',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                    height: 200,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'Revenue by Product',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              var key = products.keys.elementAt(index);
                              return Row(
                                children: [
                                  Text(
                                    key,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Spacer(),
                                  Text(
                                    ' ₹${products[key]}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ));
  }

  Future getRevenue() async {
    int i = 0;

    CollectionReference CollectionRef = FirebaseFirestore.instance
        .collection('materials')
        .doc(useremail)
        .collection('orders');
    final querySnapshot = await CollectionRef.get();
    CollectionReference CollectionRef1 = FirebaseFirestore.instance
        .collection('materials')
        .doc(useremail)
        .collection('items');
    final querySnapshot1 = await CollectionRef1.get();
    querySnapshot1.docs.forEach((element) {
      products[element['Material_name']] = 0;
    });
    setState(() {
      orders = querySnapshot.docs;
    });
    while (i < orders.length) {
      revenue = revenue + orders[i]['total'];
      i++;
    }
    i = 0;
    setState(() {
      revenue = revenue;
    });
    while (i < orders.length) {
      var order = orders[i];
      var productsInOrder = order['product'];

      if (productsInOrder is List) {
        for (var product in productsInOrder) {
          var machineryName = product['Material_name'];
          var total = order['total'];

          if (products.containsKey(machineryName)) {
            products[machineryName] = (products[machineryName]! + total)!;
          } else {
            products[machineryName] = total;
          }
        }
      } else {
        var machineryName = productsInOrder['Material_name'];
        var total = order['total'];

        if (products.containsKey(machineryName)) {
          products[machineryName] = (products[machineryName]! + total)!;
        } else {
          products[machineryName] = total;
        }
      }

      i++;
    }

    setState(() {
      products = products;
    });
  }
}
