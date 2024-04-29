import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderRequest extends StatefulWidget {
  const OrderRequest({super.key});

  @override
  State<OrderRequest> createState() => _OrderRequestState();
}

class _OrderRequestState extends State<OrderRequest> {
  bool _isUploading = false;
  Future<void> orderaccept(int index) async {
    final firestore = FirebaseFirestore.instance;
    final useremail = FirebaseAuth.instance.currentUser?.email;
    final snapshot = await firestore
        .collection('materials')
        .doc(useremail)
        .collection('order requests')
        .get();
    final orderRequest = snapshot.docs[index];
    await firestore
        .collection('materials')
        .doc(useremail)
        .collection('order requests')
        .doc(orderRequest.id)
        .update({'status': 'Order Accepted'});
    final snapshot1 = await firestore
        .collection('machinery')
        .doc(useremail)
        .collection('order requests')
        .get();
    final orderRequest1 = snapshot1.docs[index];
    await firestore
        .collection('machinery')
        .doc(useremail)
        .collection('orders')
        .add(orderRequest1.data());
    await getfcm(index);
    await sendNotificationToSeller(fcm);
    await notifications(index);
    await updatestock(index);
    await firestore
        .collection('materials')
        .doc(useremail)
        .collection('order requests')
        .doc(orderRequest.id)
        .delete();
  }

  Future<void> updatestock(int index) async {
    final firestore = FirebaseFirestore.instance;
    final useremail = FirebaseAuth.instance.currentUser?.email;
    final snapshot = await firestore
        .collection('materials')
        .doc(useremail)
        .collection('order requests')
        .get();
    final orderRequest = snapshot.docs[index];
    final product = orderRequest['product'];
    final snapshot1 = await firestore
        .collection('materials')
        .doc(useremail)
        .collection('items')
        .where('Material_name', isEqualTo: product['Material_name'])
        .get();
    final item = snapshot1.docs[0];
    final stock = int.parse(item['available_quantity']);
    final imageurls = item['Images'];
    final quantity = int.parse(orderRequest['quantity']);
    final newstock = stock - quantity;
    await firestore
        .collection('materials')
        .doc(useremail)
        .collection('items')
        .doc(product['Material_name'])
        .update({'available_quantity': "$newstock"});
    final snapshot2 = await firestore
        .collection('materials_inventory')
        .where('Images', isEqualTo: imageurls)
        .get();
    final item1 = snapshot2.docs[0];
    await firestore
        .collection('materials_inventory')
        .doc(item1.id)
        .update({'available_quantity': "$newstock"});
  }

  @override
  void initState() {
    super.initState();
  }

  String fcm = '';

  Future<void> notifications(int index) async {
    final firestore = FirebaseFirestore.instance;
    final useremail = FirebaseAuth.instance.currentUser?.email;
    final snapshot = await firestore
        .collection('materials')
        .doc(useremail)
        .collection('order requests')
        .get();
    final orderRequest = snapshot.docs[index];
    final email = orderRequest['useremail'];
    DocumentReference projectRef = firestore
        .collection('builders')
        .doc(email)
        .collection('Notifications')
        .doc();
    await projectRef.set({
      'notification title': "Order Request Has Been Accepted",
      'notification':
          "Your Order Has Been Accepted The Seller It Will Be Shipped Soon",
      'timestamp': DateTime.now(),
    });
  }

  Future<void> getfcm(int index) async {
    final firestore = FirebaseFirestore.instance;
    final useremail = FirebaseAuth.instance.currentUser?.email;
    final snapshot = await firestore
        .collection('materials')
        .doc(useremail)
        .collection('order requests')
        .get();
    final orderRequest = snapshot.docs[index];
    final email = orderRequest['useremail'];
    final snapshot1 = await firestore.collection('fcmTokens').doc(email).get();
    fcm = snapshot1['token'];
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
        'title': 'Your Order Has Been Accepted',
        'body':
            'Your Order Has Been Accepted The Seller It Will Be Shipped Soon',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Requests'),
        backgroundColor: Colors.amber,
      ),
      body: Column(children: [
        StreamBuilder(
          stream: getRequests().asStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final orderRequests = snapshot.data;
              return Expanded(
                child: Container(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: ListView.builder(
                      itemCount: orderRequests?.length,
                      itemBuilder: (context, index) {
                        final orderRequest = orderRequests?[index];
                        return ListTile(
                          title: Container(
                            padding: EdgeInsets.all(10),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Product: ${orderRequest?['product']['Material_name']}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Quantity: ${orderRequest?['quantity']}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Price: ₹${orderRequest?['total']}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Flexible(
                                    child: Align(
                                  alignment: AlignmentDirectional(0.9, 0),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          // Add code to accept order request
                                        },
                                      ),
                                    ),
                                  ),
                                )),
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          _isUploading =
                                              true; // Start the upload and show progress indicator
                                        });
                                        try {
                                          await orderaccept(index);
                                        } catch (e) {
                                          print(e); // Handle or log error
                                        } finally {
                                          setState(() {
                                            _isUploading =
                                                false; // Hide progress indicator once upload is complete
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )
      ]),
    );
  }

  Future<List<DocumentSnapshot>> getRequests() async {
    final firestore = FirebaseFirestore.instance;
    final useremail = FirebaseAuth.instance.currentUser?.email;
    final snapshot = await firestore
        .collection('materials')
        .doc(useremail)
        .collection('order requests')
        .get();
    return snapshot.docs;
  }
}
