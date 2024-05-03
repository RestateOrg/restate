import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restate/Builder/ordercomplete.dart';
import 'package:restate/Builder/upipayment.dart';

class PaymentPage extends StatefulWidget {
  final List<DocumentSnapshot> items;
  final int totalamount;
  final int totaldiscount;
  final int totaldelivery;
  final String location;
  final String city;
  final String state;
  final String name;
  final String projectimage;
  final String projecttype;
  final List<String> time;
  final List<String> timeperiod;
  final List<int> quantity;
  final List<int> price;
  final List<double> discount;
  final List<int> delivery;

  PaymentPage(
      {Key? key,
      required this.items,
      required this.totalamount,
      required this.totaldiscount,
      required this.totaldelivery,
      required this.location,
      required this.city,
      required this.state,
      required this.name,
      required this.projecttype,
      required this.time,
      required this.timeperiod,
      required this.quantity,
      required this.price,
      required this.discount,
      required this.delivery,
      required this.projectimage})
      : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? useremail = FirebaseAuth.instance.currentUser?.email;
  bool isLoading = false;
  String paymentMethod = 'upi';
  @override
  void initState() {
    print(widget.items);
    super.initState();
  }

  Future<void> storedata() async {
    final firestore = FirebaseFirestore.instance;
    for (int i = 0; i < widget.items.length; i++) {
      DocumentReference projectRef = firestore
          .collection('builders')
          .doc(useremail)
          .collection('orders')
          .doc();
      Map<String, dynamic> item =
          widget.items[i].data() as Map<String, dynamic>;

      if (item['type'] == 'machinery') {
        DocumentReference machineryRef = firestore
            .collection('machinery')
            .doc(item['useremail'])
            .collection('order requests')
            .doc();
        await projectRef.set({
          'product': item,
          'quantity': widget.quantity[i],
          'time': widget.time[i],
          'timeperiod': widget.timeperiod[i],
          'total': widget.price[i],
          'discount': widget.discount[i],
          'location': widget.location,
          'projectimage': widget.projectimage,
          'city': widget.city,
          'state': widget.state,
          'status': 'Order Not Yet Accepted',
          'useremail': useremail,
          'name': widget.name,
          'rating given': false,
          'order_name': widget.name,
          'order_id': projectRef.id,
          'order_type': 'machinery',
          'projecttype': widget.projecttype,
          'order_date': DateTime.now(),
        });
        await machineryRef.set({
          'product': item,
          'quantity': widget.quantity[i],
          'time': widget.time[i],
          'timeperiod': widget.timeperiod[i],
          'total': widget.price[i],
          'discount': widget.discount[i],
          'location': widget.location,
          'projectimage': widget.projectimage,
          'city': widget.city,
          'state': widget.state,
          'name': widget.name,
          'status': 'Pending',
          'useremail': useremail,
          'order_name': widget.name,
          'order_id': projectRef.id,
          'order_type': 'machinery',
          'projecttype': widget.projecttype,
          'order_date': DateTime.now(),
        });
      }
      if (item['type'] == 'material') {
        DocumentReference materialRef = firestore
            .collection('materials')
            .doc(item['useremail'])
            .collection('order requests')
            .doc();
        await projectRef.set({
          'product': item,
          'quantity': widget.quantity[i],
          'total': widget.price[i],
          'discount': widget.discount[i],
          'location': widget.location,
          'projectimage': widget.projectimage,
          'city': widget.city,
          'state': widget.state,
          'name': widget.name,
          'rating given': false,
          'status': 'Order Not Yet Accepted',
          'useremail': useremail,
          'order_name': widget.name,
          'order_id': projectRef.id,
          'order_type': 'material',
          'projecttype': widget.projecttype,
          'order_date': DateTime.now(),
        });
        await materialRef.set({
          'product': item,
          'quantity': widget.quantity[i],
          'total': widget.price[i],
          'discount': widget.discount[i],
          'location': widget.location,
          'projectimage': widget.projectimage,
          'city': widget.city,
          'state': widget.state,
          'name': widget.name,
          'status': 'Pending',
          'useremail': useremail,
          'order_name': widget.name,
          'order_id': projectRef.id,
          'order_type': 'material',
          'projecttype': widget.projecttype,
          'order_date': DateTime.now(),
        });
      }
      await notifications(item);
    }
    await deleteCollection();
  }

  Future<void> notifications(Map<String, dynamic> item) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await firestore.collection('fcmTokens').doc(item['useremail']).get();
    String sellerToken = snapshot['token'];
    await sendNotificationToSeller(sellerToken);
    if (item['type'] == 'machinery') {
      FirebaseFirestore.instance
          .collection('machinery')
          .doc(item['useremail'])
          .collection('notifications')
          .add({
        'title': 'New Order Received',
        'body': 'A new order has been placed by a user.',
        'date': DateTime.now(),
      });
    } else {
      FirebaseFirestore.instance
          .collection('materials')
          .doc(item['useremail'])
          .collection('notifications')
          .add({
        'title': 'New Order Received',
        'body': 'A new order has been placed by a user.',
        'date': DateTime.now(),
      });
    }
  }

  Future<void> sendNotificationToSeller(String sellerToken) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAAXgFwBw:APA91bGwgMQf4NheYj-SfYBLTWxiUA00k7RgPzC4sRzjMTpH-Yhyvx1ni_v1RHYnyy4XxB3iX1IpB2DUV18DU_tfDypKtF6Prw3RnKUzha4IHGsI6dyuNdCpUv9r8GfbsKgp58KDD-yN', // Replace with your Firebase server key
    };
    final payload = {
      'notification': {
        'title': 'New Order Received',
        'body': 'A new order has been placed by a user.',
      },
      'to': sellerToken,
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode(payload));
    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteCollection() async {
    final firestore = FirebaseFirestore.instance;
    CollectionReference collectionRef =
        firestore.collection('builders').doc(useremail).collection('Cart');
    QuerySnapshot querySnapshot = await collectionRef.get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await documentSnapshot.reference.delete();
    }
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Payment Page'),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Radio(
                                    value: 'upi',
                                    groupValue: paymentMethod,
                                    onChanged: (value) {
                                      setState(() {
                                        paymentMethod = value!;
                                      });
                                    },
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text(
                                        "Pay With UPI",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Spacer(),
                                  Image.asset(
                                    'assets/images/upi.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                ]),
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Radio(
                                    value: 'card',
                                    groupValue: paymentMethod,
                                    onChanged: (value) {
                                      setState(() {
                                        paymentMethod = value!;
                                      });
                                    },
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text(
                                        "Card Payment",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Spacer(),
                                  Icon(Icons.payment, size: 40),
                                ]),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 300, left: 8, right: 8),
                          child: Text("Price Summary",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, bottom: 8),
                          child: Row(
                            children: [
                              Text("Price", style: TextStyle()),
                              Spacer(),
                              Text(
                                  "₹ ${widget.totalamount + widget.totaldiscount}",
                                  style: TextStyle()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, bottom: 8),
                          child: Row(
                            children: [
                              Text("Delivery Charges", style: TextStyle()),
                              Spacer(),
                              Text("₹ ${widget.totaldelivery}",
                                  style: TextStyle()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, bottom: 8),
                          child: Row(
                            children: [
                              Text("Discount", style: TextStyle()),
                              Spacer(),
                              Text("₹ ${widget.totaldiscount}",
                                  style: TextStyle()),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                          ),
                          child: Row(
                            children: [
                              Text("Total Amount",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Spacer(),
                              Text("₹ ${widget.totalamount}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                  "You will save ₹ ${widget.totaldiscount} on this order",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  )),
                            ],
                          ),
                        ),
                      ]),
                )
              ]),
            ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          String result = 'failed';
          if (paymentMethod == 'upi') {
            result = await upi();
          }
          if (result == 'success') {
            setState(() {
              isLoading = true; // Add a boolean variable to track loading state
            });

            await storedata();

            setState(() {
              isLoading = false;
              Navigator.pop(
                  context); // Set loading state to false after order function is complete
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderComplete(),
                ),
              );
            });
          }
        },
        child: Container(
          height: 70,
          color: Colors.amber,
          child: Center(
            child: Text("Pay Now"),
          ),
        ),
      ),
    );
  }

  Future<String> upi() async {
    String result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return UpiPayment(
          amount: widget.totalamount.toInt(),
        );
      },
    ));
    return result;
  }
}
