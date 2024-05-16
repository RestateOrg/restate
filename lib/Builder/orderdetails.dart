import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  final DocumentSnapshot? order;
  OrderDetails({super.key, required this.order});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class Timeline extends StatelessWidget {
  final DocumentSnapshot? order;
  Timeline({super.key, required this.order});
  String _formatTimestamp(Timestamp timestamp) {
    // Assuming timestamp is of type Firestore Timestamp, adjust this if needed
    DateTime dateTime =
        timestamp.toDate(); // Convert Firestore Timestamp to DateTime
    // Format DateTime as desired
    String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    bool isOrderAccepted = order?['status'] == 'Order Accepted';
    bool isOrderShipped = order?['status'] == 'Out For Delivery';
    bool isOrderDelivered = order?['status'] == 'Order Delivered';
    return Column(
      children: <Widget>[
        TimelineItem(
          title: 'Order Requested',
          subTitle: '',
          isActive: true,
          isCompleted: true,
        ),
        TimelineItem(
          title: 'Order Accepted',
          subTitle: '',
          isActive: isOrderAccepted || isOrderShipped || isOrderDelivered,
          isCompleted: isOrderAccepted || isOrderShipped || isOrderDelivered,
        ),
        TimelineItem(
          title: 'Out For Delivery',
          subTitle: '',
          isActive: isOrderShipped || isOrderDelivered,
          isCompleted: isOrderShipped || isOrderDelivered,
        ),
        TimelineItem(
          title: 'Order Delivered',
          subTitle: '',
          isActive: isOrderDelivered,
          isCompleted: isOrderDelivered,
        ),
      ],
    );
  }
}

class TimelineItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool isActive;
  final bool isCompleted;

  const TimelineItem({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.isActive,
    required this.isCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 10.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? Colors.green : Colors.black26,
                ),
              ),
              Icon(
                isCompleted ? Icons.check : Icons.circle,
                color: Colors.white,
                size: 15.0,
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: isActive ? Colors.green : Colors.black26,
                  width: 2.0,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.green : Colors.black26,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: isActive ? Colors.green : Colors.black26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderDetailsState extends State<OrderDetails> {
  int flag = 0;
  double stars = 0.0;
  bool isLoading = false;
  String? useremail = FirebaseAuth.instance.currentUser?.email;
  @override
  void dispose() {
    DefaultCacheManager().emptyCache();
    super.dispose();
  }

  Future<void> _submitRating() async {
    if (widget.order?["order_type"] == "machinery") {
      DocumentReference already = FirebaseFirestore.instance
          .collection("machinery")
          .doc(widget.order?["product"]["useremail"])
          .collection("inventory")
          .doc(widget.order?["product"]["machinery_name"]);

      DocumentSnapshot snapshot = await already.get();
      double oldrating = snapshot["rating"].toDouble();
      int oldcount = snapshot["rating_count"];
      await FirebaseFirestore.instance
          .collection('machinery')
          .doc(widget.order?["product"]["useremail"])
          .collection('inventory')
          .doc(widget.order?['product']['machinery_name'])
          .update({"rating": oldrating + stars});
      await FirebaseFirestore.instance
          .collection('machinery')
          .doc(widget.order?["product"]["useremail"])
          .collection('inventory')
          .doc(widget.order?['product']['machinery_name'])
          .update({"rating_count": oldcount + 1});
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('machinery inventory')
          .where('image_urls',
              arrayContains: widget.order?["product"]["image_urls"][0])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        double oldrating = documentSnapshot["rating"].toDouble();
        int oldcount = documentSnapshot["rating_count"];
        await FirebaseFirestore.instance
            .collection('machinery inventory')
            .doc(documentSnapshot.id)
            .update({"rating": oldrating + stars});
        await FirebaseFirestore.instance
            .collection('machinery inventory')
            .doc(documentSnapshot.id)
            .update({"rating_count": oldcount + 1});
      }
    } else {
      DocumentReference already = FirebaseFirestore.instance
          .collection("material")
          .doc(widget.order?["product"]["useremail"])
          .collection("inventory")
          .doc(widget.order?["product"]["Material_name"]);

      DocumentSnapshot snapshot = await already.get();
      double oldrating = snapshot["rating"].toDouble();
      int oldcount = snapshot["rating_count"];
      await FirebaseFirestore.instance
          .collection('material')
          .doc(widget.order?["product"]["useremail"])
          .collection('inventory')
          .doc(widget.order?['product']['Material_name'])
          .update({"rating": oldrating + stars});
      await FirebaseFirestore.instance
          .collection('material')
          .doc(widget.order?["product"]["useremail"])
          .collection('inventory')
          .doc(widget.order?['product']['Material_name'])
          .update({"rating_count": oldcount + 1});
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('material inventory')
          .where('Images', arrayContains: widget.order?["product"]["Images"][0])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        double oldrating = documentSnapshot["rating"].toDouble();
        int oldcount = documentSnapshot["rating_count"];
        await FirebaseFirestore.instance
            .collection('material inventory')
            .doc(documentSnapshot.id)
            .update({"rating": oldrating + stars});
        await FirebaseFirestore.instance
            .collection('material inventory')
            .doc(documentSnapshot.id)
            .update({"rating_count": oldcount + 1});
      }
    }
    await FirebaseFirestore.instance
        .collection("builders")
        .doc(useremail)
        .collection("orders")
        .doc(widget.order?.id)
        .update({"rating given": true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text('Order Details'),
        ),
        body: isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Text(
                        "Order ID: ${widget.order?["order_id"]}",
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  widget.order?["order_type"] == "machinery"
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0, left: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        color: Colors.black12,
                                        width: 100,
                                        height: 100,
                                        child: CachedNetworkImage(
                                            key: UniqueKey(),
                                            imageUrl: widget.order?["product"]
                                                ["image_urls"][0]),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.order?["status"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              widget.order?["product"]
                                                  ["machinery_name"],
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    widget.order?["product"]["machinery_type"],
                                    style: TextStyle(
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, bottom: 8.0),
                                  child: Text(
                                    "₹ ${widget.order?["total"]}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0, left: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        color: Colors.black12,
                                        width: 100,
                                        height: 100,
                                        child: CachedNetworkImage(
                                            key: UniqueKey(),
                                            imageUrl: widget.order?["product"]
                                                ["Images"][0]),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.order?["status"],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              widget.order?["product"]
                                                  ["Material_name"],
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, bottom: 8.0),
                                  child: Text(
                                    widget.order?["product"]["Material_type"],
                                    style: TextStyle(
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, bottom: 8.0),
                                  child: Text(
                                    "₹ ${widget.order?["total"]}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  Divider(),
                  Timeline(
                    order: widget.order,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 20),
                      child: Row(
                        children: [
                          Text(
                            "See Full Details",
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.amber),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 20),
                      child: Row(
                        children: [
                          Text(
                            "This Product is Not Eligible for Return",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Why?",
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      )),
                  Center(
                      child: widget.order?['rating given'] == false
                          ? RatingBar.builder(
                              initialRating:
                                  widget.order?["product"]["rating"].toDouble(),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 50,
                              itemBuilder: (context, _) => Icon(
                                Icons.star_rate_rounded,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  stars = rating;
                                  flag = 1;
                                });
                              },
                            )
                          : Container()),
                  flag == 1
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await _submitRating();
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Rating Submitted'),
                              ));
                              await Future.delayed(Duration(seconds: 1));
                              Navigator.pop(context);
                            },
                            child: Text('Submit Rating'),
                          ),
                        )
                      : Container(),
                ]),
              ));
  }
}
