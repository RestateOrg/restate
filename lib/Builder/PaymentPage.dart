import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restate/Builder/ordercomplete.dart';

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
            .collection('orders')
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
            .collection('orders')
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
    }
    await deleteCollection();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Payment Page'),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
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
}
