import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:restate/Builder/orderdetails.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final useremail = FirebaseAuth.instance.currentUser!.email;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    DefaultCacheManager().emptyCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text('Orders'),
        ),
        body: Container(
          child: StreamBuilder(
            stream: fetchData().asStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No Orders'),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data?[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OrderDetails(order: item)));
                            setState(() {});
                          },
                          child: ListTile(
                            title: item?["order_type"] == "machinery"
                                ? Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            color: Colors.black12,
                                            width: 100,
                                            height: 100,
                                            child: CachedNetworkImage(
                                                key: UniqueKey(),
                                                imageUrl: item?["product"]
                                                    ["image_urls"][0]),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item?["status"],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  item?["product"]
                                                      ["machinery_name"],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(Icons.arrow_forward_ios),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            color: Colors.black12,
                                            width: 100,
                                            height: 100,
                                            child: CachedNetworkImage(
                                                key: UniqueKey(),
                                                imageUrl: item?["product"]
                                                    ["Images"][0]),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item?["status"],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  item?["product"]
                                                      ["Material_name"],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(Icons.arrow_forward_ios),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ));
  }

  Future<List<DocumentSnapshot>> fetchData() async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('builders')
        .doc(useremail)
        .collection('orders');
    QuerySnapshot orders = await collectionRef.get();
    return orders.docs;
  }
}
