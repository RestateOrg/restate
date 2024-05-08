import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class YourOrdersDetails extends StatefulWidget {
  final DocumentSnapshot? order;
  YourOrdersDetails({super.key, required this.order});

  @override
  State<YourOrdersDetails> createState() => _YourOrdersDetailsState();
}

class _YourOrdersDetailsState extends State<YourOrdersDetails> {
  int flag = 0;
  double stars = 0.0;
  String? useremail = FirebaseAuth.instance.currentUser!.email;
  String dropdownValue = '';
  String? status;
  void initState() {
    getOrderstatus();
    super.initState();
  }

  @override
  void dispose() {
    DefaultCacheManager().emptyCache();
    super.dispose();
  }

  void getOrderstatus() async {
    setState(() {
      status = widget.order?["orderstatus"];
    });

    if (status == 'Order Accepted') {
      setState(() {
        dropdownValue = 'Out For Delivery';
      });
    } else if (status == 'Out For Delivery') {
      setState(() {
        dropdownValue = 'Order Delivered';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text('Order Details'),
        ),
        body: SingleChildScrollView(
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
                                      imageUrl: widget.order?["projectimage"]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Status:${widget.order?["status"]}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Ordered Machinery:${widget.order?["product"]["machinery_name"]}",
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
                            padding:
                                const EdgeInsets.only(left: 8, bottom: 8.0),
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
                                  padding: const EdgeInsets.only(left: 8.0),
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
                            padding:
                                const EdgeInsets.only(left: 8, bottom: 8.0),
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
                            padding:
                                const EdgeInsets.only(left: 8, bottom: 8.0),
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
            status != 'Order Delivered'
                ? DropdownButton<String>(
                    value: dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: status == 'Order Accepted'
                        ? <String>['Out For Delivery']
                            .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()
                        : status == 'Out For Delivery'
                            ? <String>['Order Delivered']
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()
                            : <String>[]
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                  )
                : Text('Order Delivered'),
            status == 'Order Delivered'
                ? Container()
                : ElevatedButton(
                    onPressed: () {
                      if (dropdownValue == 'Out For Delivery') {
                        final snapshots1 = FirebaseFirestore.instance
                            .collection('machinery')
                            .doc(useremail)
                            .collection('orders')
                            .where('order_id',
                                isEqualTo: widget.order?["order_id"]);
                        snapshots1.get().then((querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            doc.reference.update({
                              "orderstatus": 'Out For Delivery',
                            });
                          });
                        });

                        final snapshots = FirebaseFirestore.instance
                            .collection('builders')
                            .doc(widget.order?["useremail"])
                            .collection('orders')
                            .where('order_id',
                                isEqualTo: widget.order?["order_id"]);
                        snapshots.get().then((querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            doc.reference.update({
                              "status": 'Out For Delivery',
                            });
                          });
                        });
                      } else if (dropdownValue == 'Delivered') {
                        final snapshots1 = FirebaseFirestore.instance
                            .collection('machinery')
                            .doc(useremail)
                            .collection('orders')
                            .where('order_id',
                                isEqualTo: widget.order?["order_id"]);
                        snapshots1.get().then((querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            doc.reference.update({
                              "orderstatus": 'Order Delivered',
                              "status": "Completed"
                            });
                          });
                        });

                        final snapshots = FirebaseFirestore.instance
                            .collection('builders')
                            .doc(widget.order?["useremail"])
                            .collection('orders')
                            .where('order_id',
                                isEqualTo: widget.order?["order_id"]);
                        snapshots.get().then((querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            doc.reference.update({
                              "status": 'Order Delivered',
                            });
                          });
                        });
                      }
                    },
                    child: Text('Update Status'),
                  ),
          ]),
        ));
  }
}
