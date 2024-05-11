import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restate/Builder/PaymentPage.dart';
import 'package:restate/Builder/Searchresults.dart';
import 'package:restate/Builder/deliveryaddress.dart';
import 'package:restate/Utils/hexcolor.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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
String projectimage = "";
int selectedIndex = 0;

List<QueryDocumentSnapshot> deliverySnapshots = [];

class _BuilderCartState extends State<BuilderCart> {
  int flag = 0;
  List<int> _quantity = [];
  List<String> timeperiod = [];
  List<String> time = [];
  List<int> _price = [];
  List<int> _delivery = [];
  List<double> _discount = [];
  List<DocumentSnapshot> items = [];
  int totalamount = 0;
  int totaldiscount = 0;
  int totaldelivery = 0;
  void initState() {
    super.initState();
    getDeliveryAddress();
    waittime();
  }

  @override
  void dispose() {
    super.dispose();
    DefaultCacheManager().emptyCache();
  }

  void waittime() async {
    await Future.delayed(Duration(seconds: 2));
    calculateTotal();
  }

  Future<void> calculateTotal() async {
    int total = 0;
    int discount = 0;
    int delivery = 0;
    for (int i = 0; i < _price.length; i++) {
      total += _price[i] - _discount[i].toInt();
    }
    for (int i = 0; i < _discount.length; i++) {
      discount += _discount[i].toInt();
    }
    for (int i = 0; i < _delivery.length; i++) {
      total += _delivery[i];
      delivery += _delivery[i];
    }

    setState(() {
      totaldiscount = discount;
      totalamount = total + (total * 0.02).toInt();
      totaldelivery = delivery;
    });
  }

  void _incrementQuantity(
      int index, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
    setState(() {
      _quantity[index]++;
    });
    if (snapshot.data![index]['type'] == 'machinery') {
      if (timeperiod[index] == 'Hour') {
        _price[index] = int.parse(snapshot.data![index]['hourly']);
        _price[index] = _price[index] * int.parse(time[index]);
        _price[index] = _price[index] * _quantity[index];
        _delivery[index] = 0;
        _discount[index] = _price[index] * 0.1;
        _price[index] = _price[index] + _discount[index].toInt();
      }
      if (timeperiod[index] == 'Day') {
        _price[index] = int.parse(snapshot.data![index]['day']);
        _price[index] = _price[index] * int.parse(time[index]);
        _price[index] = _price[index] * _quantity[index];
        _delivery[index] = 0;
        _discount[index] = _price[index] * 0.1;
        _price[index] = _price[index] + _discount[index].toInt();
      }
      if (timeperiod[index] == 'Week') {
        _price[index] = int.parse(snapshot.data![index]['week']);
        _price[index] = _price[index] * int.parse(time[index]);
        _price[index] = _price[index] * _quantity[index];
        _delivery[index] = 0;
        _discount[index] = _price[index] * 0.1;
        _price[index] = _price[index] + _discount[index].toInt();
      }
      if (timeperiod[index] == 'Month') {
        _price[index] = int.parse(snapshot.data![index]['month']);
        _price[index] = _price[index] * int.parse(time[index]);
        _price[index] = _price[index] * _quantity[index];
        _delivery[index] = 0;
        _discount[index] = _price[index] * 0.1;
        _price[index] = _price[index] + _discount[index].toInt();
      }
    } else {
      _price[index] = int.parse(snapshot.data![index]['Price_per']);
      _price[index] = _price[index] * _quantity[index];
      Map<String, dynamic> product =
          snapshot.data![index].data() as Map<String, dynamic>;
      if (product.containsKey("delivery_inside_city")) {
        _delivery[index] =
            int.parse(snapshot.data![index]['delivery_inside_city']) -
                int.parse(snapshot.data![index]['Price_per']);
        _delivery[index] = _delivery[index] * _quantity[index];
      }
      _discount[index] = _price[index] * 0.1;
      _price[index] = _price[index] + _discount[index].toInt();
    }
    calculateTotal();
  }

  void _decrementQuantity(
      int index, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
    if (_quantity[index] > 1) {
      setState(() {
        _quantity[index]--;
      });
    }
    if (snapshot.data![index]['type'] == 'machinery') {
      if (timeperiod[index] == 'Hour') {
        _price[index] = int.parse(snapshot.data![index]['hourly']);
        _price[index] = _price[index] * int.parse(time[index]);
        _price[index] = _price[index] * _quantity[index];
        _delivery[index] = 0;
        _discount[index] = _price[index] * 0.1;
        _price[index] = _price[index] + _discount[index].toInt();
      }
      if (timeperiod[index] == 'Day') {
        _price[index] = int.parse(snapshot.data![index]['day']);
        _price[index] = _price[index] * int.parse(time[index]);
        _price[index] = _price[index] * _quantity[index];
        _delivery[index] = 0;
        _discount[index] = _price[index] * 0.1;
        _price[index] = _price[index] + _discount[index].toInt();
      }
      if (timeperiod[index] == 'Week') {
        _price[index] = int.parse(snapshot.data![index]['week']);
        _price[index] = _price[index] * int.parse(time[index]);
        _price[index] = _price[index] * _quantity[index];
        _delivery[index] = 0;
        _discount[index] = _price[index] * 0.1;
        _price[index] = _price[index] + _discount[index].toInt();
      }
      if (timeperiod[index] == 'Month') {
        _price[index] = int.parse(snapshot.data![index]['month']);
        _price[index] = _price[index] * int.parse(time[index]);
        _price[index] = _price[index] * _quantity[index];
        _delivery[index] = 0;
        _discount[index] = _price[index] * 0.1;
        _price[index] = _price[index] + _discount[index].toInt();
      }
    }
    if (snapshot.data![index]['type'] == 'material') {
      _price[index] = int.parse(snapshot.data![index]['Price_per']);
      _price[index] = _price[index] * _quantity[index];
      Map<String, dynamic> product =
          snapshot.data![index].data() as Map<String, dynamic>;
      if (product.containsKey("delivery_inside_city")) {
        _delivery[index] =
            int.parse(snapshot.data![index]['delivery_inside_city']) -
                int.parse(snapshot.data![index]['Price_per']);
      }
      _discount[index] = _price[index] * 0.1;
      _price[index] = _price[index] + _discount[index].toInt();
    }
    calculateTotal();
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
      projectimage = deliverySnapshots[selectedIndex]['imageURl'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 247, 247, 247),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Total Amount: ₹ $totalamount",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    items: items,
                    totalamount: totalamount,
                    totaldiscount: totaldiscount,
                    totaldelivery: totaldelivery,
                    location: location,
                    city: city,
                    state: state,
                    name: name,
                    projectimage: projectimage,
                    quantity: _quantity,
                    timeperiod: timeperiod,
                    time: time,
                    projecttype: projecttype,
                    price: _price,
                    discount: _discount,
                    delivery: _delivery,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.amber[600],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text("Proceed to Checkout",
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
          ),
        ]),
      ),
      backgroundColor: Color.fromARGB(255, 234, 234, 234),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
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
                          onPressed: () async {
                            Map<String, dynamic> result =
                                await Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return DeliveryChoose(
                                  deliverySnapshots: deliverySnapshots,
                                );
                              },
                            ));

                            setState(() {
                              location = result['location'];
                              city = result['city'];
                              state = result['state'];
                              name = result['name'];
                              projecttype = result['projecttype'];
                            });
                          },
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
              Container(
                height: 300,
                child: StreamBuilder<List<DocumentSnapshot>>(
                  stream: _fetchProducts().asStream(),
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
                          if (flag == 0 &&
                              index < (snapshot.data!.length) - 1) {
                            _quantity.add(1);
                            timeperiod.add('Hour');
                            time.add('1');
                            if (snapshot.data![index]['type'] == 'machinery') {
                              _price.add(
                                  int.parse(snapshot.data![index]['hourly']));
                            } else {
                              _price.add(int.parse(
                                  snapshot.data![index]['Price_per']));
                            }
                            _discount.add(0);
                            if (snapshot.data![index]['type'] == 'machinery') {
                              _delivery.add(0);
                            } else {
                              Map<String, dynamic> product =
                                  snapshot.data![index].data()
                                      as Map<String, dynamic>;
                              if (product.containsKey("delivery_inside_city")) {
                                _delivery.add(int.parse(snapshot.data![index]
                                        ['delivery_inside_city']) -
                                    int.parse(
                                        snapshot.data![index]['Price_per']));
                              } else {
                                _delivery.add(0);
                              }
                            }
                          } else if (flag == 0 &&
                              index == (snapshot.data!.length) - 1) {
                            _quantity.add(1);
                            timeperiod.add('Hour');
                            time.add('1');
                            if (snapshot.data![index]['type'] == 'machinery') {
                              _price.add(
                                  int.parse(snapshot.data![index]['hourly']));
                            } else {
                              _price.add(int.parse(
                                  snapshot.data![index]['Price_per']));
                            }
                            _discount.add(0);
                            if (snapshot.data![index]['type'] == 'machinery') {
                              _delivery.add(0);
                            } else {
                              Map<String, dynamic> product =
                                  snapshot.data![index].data()
                                      as Map<String, dynamic>;
                              if (product.containsKey("delivery_inside_city")) {
                                _delivery.add(int.parse(snapshot.data![index]
                                        ['delivery_inside_city']) -
                                    int.parse(
                                        snapshot.data![index]['Price_per']));
                              } else {
                                _delivery.add(0);
                              }
                            }
                            flag = 1;
                            for (int i = 0; i < snapshot.data!.length; i++) {
                              if (snapshot.data![i]['type'] == 'machinery') {
                                if (timeperiod[i] == 'Hour') {
                                  _price[i] =
                                      int.parse(snapshot.data![i]['hourly']);
                                  _price[i] = _price[i] * int.parse(time[i]);
                                  _price[i] = _price[i] * _quantity[i];
                                  _delivery[i] = 0;
                                  _discount[i] = _price[i] * 0.1;
                                  _price[i] = _price[i] + _discount[i].toInt();
                                }
                                if (timeperiod[i] == 'Day') {
                                  _price[i] =
                                      int.parse(snapshot.data![i]['day']);
                                  _price[i] = _price[i] * int.parse(time[i]);
                                  _price[i] = _price[i] * _quantity[i];
                                  _delivery[i] = 0;
                                  _discount[i] = _price[i] * 0.1;
                                  _price[i] = _price[i] + _discount[i].toInt();
                                }
                                if (timeperiod[i] == 'Week') {
                                  _price[i] =
                                      int.parse(snapshot.data![i]['week']);
                                  _price[i] = _price[i] * int.parse(time[i]);
                                  _price[i] = _price[i] * _quantity[i];
                                  _delivery[i] = 0;
                                  _discount[i] = _price[i] * 0.1;
                                  _price[i] = _price[i] + _discount[i].toInt();
                                }
                                if (timeperiod[i] == 'Month') {
                                  _price[i] =
                                      int.parse(snapshot.data![i]['month']);
                                  _price[i] = _price[i] * int.parse(time[i]);
                                  _price[i] = _price[i] * _quantity[i];
                                  _delivery[i] = 0;
                                  _discount[i] = _price[i] * 0.1;
                                  _price[i] = _price[i] + _discount[i].toInt();
                                }
                              }
                              if (snapshot.data![i]['type'] == 'material') {
                                _price[i] =
                                    int.parse(snapshot.data![i]['Price_per']);
                                _price[i] = _price[i] * _quantity[i];
                                Map<String, dynamic> product =
                                    snapshot.data![index].data()
                                        as Map<String, dynamic>;
                                if (product
                                    .containsKey("delivery_inside_city")) {
                                  _delivery[i] = int.parse(snapshot.data![i]
                                          ['delivery_inside_city']) -
                                      int.parse(snapshot.data![i]['Price_per']);
                                } else {
                                  _delivery.add(0);
                                }
                                _discount[i] = _price[i] * 0.1;
                                _price[i] = _price[i] + _discount[i].toInt();
                              }
                            }
                          }

                          if (snapshot.data![index]['type'] == 'machinery') {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(bottom: 3),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        child: CachedNetworkImage(
                                          key: UniqueKey(),
                                          imageUrl: snapshot.data![index]
                                              ['image_urls'][0],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              snapshot.data![index]
                                                  ['machinery_name'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(snapshot.data![index]
                                                ['machinery_type']),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: RatingBar(
                                                    initialRating: snapshot
                                                        .data![index]['rating']
                                                        .toDouble(),
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    ratingWidget: RatingWidget(
                                                      full: Icon(Icons.star,
                                                          color: Colors.amber),
                                                      half: Icon(
                                                          Icons.star_half,
                                                          color: Colors.amber),
                                                      empty: Icon(Icons.star,
                                                          color: Colors.grey),
                                                    ),
                                                    itemSize: 17,
                                                    ignoreGestures: true,
                                                    onRatingUpdate: (rating) {
                                                      print(rating);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3.0),
                                                child: Text(
                                                  "${snapshot.data![index]['rating_count']}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                      255, 0, 0, 0)
                                                  .withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon:
                                                  Icon(Icons.remove, size: 14),
                                              onPressed: () =>
                                                  _decrementQuantity(
                                                      index, snapshot),
                                            ),
                                            Text(
                                              '${_quantity[index]}',
                                              style: TextStyle(fontSize: 14.0),
                                            ),
                                            Container(
                                              child: IconButton(
                                                icon: Icon(Icons.add, size: 14),
                                                onPressed: () =>
                                                    _incrementQuantity(
                                                        index, snapshot),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    "₹ ${snapshot.data![index]['hourly']}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text: " / Hour",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    "₹ ${snapshot.data![index]['week']}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text: " / Week",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                                    Column(children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    "₹ ${snapshot.data![index]['day']}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text: " / Day",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    "₹ ${snapshot.data![index]['month']}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text: " / Month",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ])
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Time Period",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor("#815D00")),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color.fromARGB(
                                                        255, 0, 0, 0)
                                                    .withOpacity(0.3),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: DropdownButton<String>(
                                            underline: Container(),
                                            value: timeperiod[index],
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                timeperiod[index] = newValue!;
                                                time[index] = "1";
                                              });
                                              if (timeperiod[index] == 'Hour') {
                                                _price[index] = int.parse(
                                                    snapshot.data![index]
                                                        ['hourly']);
                                                _price[index] = _price[index] *
                                                    int.parse(time[index]);
                                                _price[index] = _price[index] *
                                                    _quantity[index];
                                                _delivery[index] = 0;
                                                _discount[index] =
                                                    _price[index] * 0.1;
                                                _price[index] = _price[index] +
                                                    _discount[index].toInt();
                                              }
                                              if (timeperiod[index] == 'Day') {
                                                _price[index] = int.parse(
                                                    snapshot.data![index]
                                                        ['day']);
                                                _price[index] = _price[index] *
                                                    int.parse(time[index]);
                                                _price[index] = _price[index] *
                                                    _quantity[index];
                                                _delivery[index] = 0;
                                                _discount[index] =
                                                    _price[index] * 0.1;
                                                _price[index] = _price[index] +
                                                    _discount[index].toInt();
                                              }
                                              if (timeperiod[index] == 'Week') {
                                                _price[index] = int.parse(
                                                    snapshot.data![index]
                                                        ['week']);
                                                _price[index] = _price[index] *
                                                    int.parse(time[index]);
                                                _price[index] = _price[index] *
                                                    _quantity[index];
                                                _delivery[index] = 0;
                                                _discount[index] =
                                                    _price[index] * 0.1;
                                                _price[index] = _price[index] +
                                                    _discount[index].toInt();
                                              }
                                              if (timeperiod[index] ==
                                                  'Month') {
                                                _price[index] = int.parse(
                                                    snapshot.data![index]
                                                        ['month']);
                                                _price[index] = _price[index] *
                                                    int.parse(time[index]);
                                                _price[index] = _price[index] *
                                                    _quantity[index];
                                                _delivery[index] = 0;
                                                _discount[index] =
                                                    _price[index] * 0.1;
                                                _price[index] = _price[index] +
                                                    _discount[index].toInt();
                                              }
                                              calculateTotal();
                                            },
                                            items: <String>[
                                              'Hour',
                                              'Day',
                                              'Week',
                                              'Month'
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 60,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          timeperiod[index] == 'Hour'
                                              ? "Hour"
                                              : timeperiod[index] == 'Day'
                                                  ? "Day"
                                                  : timeperiod[index] == 'Week'
                                                      ? "Week"
                                                      : "Month",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor("#815D00")),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color.fromARGB(
                                                        255, 0, 0, 0)
                                                    .withOpacity(0.3),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: DropdownButton<String>(
                                            underline: Container(),
                                            value: time[index],
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                time[index] = newValue!;
                                                if (timeperiod[index] ==
                                                    'Hour') {
                                                  _price[index] = int.parse(
                                                      snapshot.data![index]
                                                          ['hourly']);
                                                  _price[index] = _price[
                                                          index] *
                                                      int.parse(time[index]);
                                                  _price[index] =
                                                      _price[index] *
                                                          _quantity[index];
                                                  _delivery[index] = 0;
                                                  _discount[index] =
                                                      _price[index] * 0.1;
                                                  _price[index] =
                                                      _price[index] +
                                                          _discount[index]
                                                              .toInt();
                                                }
                                                if (timeperiod[index] ==
                                                    'Day') {
                                                  _price[index] = int.parse(
                                                      snapshot.data![index]
                                                          ['day']);
                                                  _price[index] = _price[
                                                          index] *
                                                      int.parse(time[index]);
                                                  _price[index] =
                                                      _price[index] *
                                                          _quantity[index];
                                                  _delivery[index] = 0;
                                                  _discount[index] =
                                                      _price[index] * 0.1;
                                                  _price[index] =
                                                      _price[index] +
                                                          _discount[index]
                                                              .toInt();
                                                }
                                                if (timeperiod[index] ==
                                                    'Week') {
                                                  _price[index] = int.parse(
                                                      snapshot.data![index]
                                                          ['week']);
                                                  _price[index] = _price[
                                                          index] *
                                                      int.parse(time[index]);
                                                  _price[index] =
                                                      _price[index] *
                                                          _quantity[index];
                                                  _delivery[index] = 0;
                                                  _discount[index] =
                                                      _price[index] * 0.1;
                                                  _price[index] =
                                                      _price[index] +
                                                          _discount[index]
                                                              .toInt();
                                                }
                                                if (timeperiod[index] ==
                                                    'Month') {
                                                  _price[index] = int.parse(
                                                      snapshot.data![index]
                                                          ['month']);
                                                  _price[index] = _price[
                                                          index] *
                                                      int.parse(time[index]);
                                                  _price[index] =
                                                      _price[index] *
                                                          _quantity[index];
                                                  _delivery[index] = 0;
                                                  _discount[index] =
                                                      _price[index] * 0.1;
                                                  _price[index] =
                                                      _price[index] +
                                                          _discount[index]
                                                              .toInt();
                                                }
                                              });
                                              calculateTotal();
                                            },
                                            items: timeperiod[index] == 'Hour'
                                                ? <String>[
                                                    '1',
                                                    '2',
                                                    '3',
                                                    '4',
                                                    '5',
                                                    '6',
                                                    '7',
                                                    '8',
                                                    '9',
                                                    '10',
                                                    '11',
                                                    '12',
                                                    '13',
                                                    '14',
                                                    '15',
                                                    '16',
                                                    '17',
                                                    '18',
                                                    '19',
                                                    '20',
                                                    '21',
                                                    '22',
                                                    '23',
                                                    '24',
                                                  ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList()
                                                : timeperiod[index] == 'Day'
                                                    ? <String>[
                                                        '1',
                                                        '2',
                                                        '3',
                                                        '4',
                                                        '5',
                                                        '6',
                                                        '7',
                                                        '8',
                                                        '9',
                                                        '10',
                                                        '11',
                                                        '12',
                                                        '13',
                                                        '14',
                                                        '15',
                                                        '16',
                                                        '17',
                                                        '18',
                                                        '19',
                                                        '20',
                                                        '21',
                                                        '22',
                                                        '23',
                                                        '24',
                                                        '25',
                                                        '26',
                                                        '27',
                                                        '28',
                                                        '29',
                                                        '30',
                                                        '31',
                                                      ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(
                                                            value,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList()
                                                    : timeperiod[index] ==
                                                            'Week'
                                                        ? <String>[
                                                            '1',
                                                            '2',
                                                            '3',
                                                            '4',
                                                          ].map<
                                                                DropdownMenuItem<
                                                                    String>>(
                                                            (String value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: Text(
                                                                value,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList()
                                                        : <String>[
                                                            '1',
                                                            '2',
                                                            '3',
                                                            '4',
                                                            '5',
                                                            '6',
                                                            '7',
                                                            '8',
                                                            '9',
                                                            '10',
                                                            '11',
                                                            '12',
                                                          ].map<
                                                                DropdownMenuItem<
                                                                    String>>(
                                                            (String value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: Text(
                                                                value,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Delivered Within ${snapshot.data![index]['delivered_within']} |",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Text(" Free Delivery",
                                          style:
                                              TextStyle(color: Colors.green)),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Delete'),
                                                  content: Text(
                                                      'Do You Want to Delete this Item?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Dismiss the dialog
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Delete'),
                                                      onPressed: () async {
                                                        _price[index] = 0;
                                                        _quantity[index] = 0;
                                                        _delivery[index] = 0;
                                                        _discount[index] = 0;
                                                        setState(() {});
                                                        calculateTotal();
                                                        firestore
                                                            .collection(
                                                                'builders')
                                                            .doc(useremail)
                                                            .collection('Cart')
                                                            .doc(snapshot
                                                                .data![index]
                                                                .id)
                                                            .delete();
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.black38,
                                        ),
                                      )
                                    ],
                                  ),
                                )
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
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        child: CachedNetworkImage(
                                            key: UniqueKey(),
                                            imageUrl: snapshot.data![index]
                                                ['Images'][0]),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              snapshot.data![index]
                                                  ['Material_name'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(snapshot.data![index]
                                                ['Material_type']),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: RatingBar(
                                                    initialRating: snapshot
                                                        .data![index]['rating']
                                                        .toDouble(),
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    ratingWidget: RatingWidget(
                                                      full: Icon(Icons.star,
                                                          color: Colors.amber),
                                                      half: Icon(
                                                          Icons.star_half,
                                                          color: Colors.amber),
                                                      empty: Icon(Icons.star,
                                                          color: Colors.grey),
                                                    ),
                                                    itemSize: 17,
                                                    ignoreGestures: true,
                                                    onRatingUpdate: (rating) {
                                                      print(rating);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3.0),
                                                child: Text(
                                                  "${snapshot.data![index]['rating_count']}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        "₹ ${snapshot.data![index]['Price_per']}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        " / ${snapshot.data![index]['Price_per_unit']}",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                      255, 0, 0, 0)
                                                  .withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon:
                                                  Icon(Icons.remove, size: 14),
                                              onPressed: () =>
                                                  _decrementQuantity(
                                                      index, snapshot),
                                            ),
                                            Text(
                                              '${_quantity[index]}',
                                              style: TextStyle(fontSize: 14.0),
                                            ),
                                            Container(
                                              child: IconButton(
                                                icon: Icon(Icons.add, size: 14),
                                                onPressed: () =>
                                                    _incrementQuantity(
                                                        index, snapshot),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Delivered Within ${snapshot.data![index]['delivered_within']}",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Delete'),
                                                  content: Text(
                                                      'Do You Want to Delete this Item?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Dismiss the dialog
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Delete'),
                                                      onPressed: () async {
                                                        _price[index] = 0;
                                                        _quantity[index] = 0;
                                                        _delivery[index] = 0;
                                                        _discount[index] = 0;

                                                        setState(() {});
                                                        calculateTotal();
                                                        firestore
                                                            .collection(
                                                                'builders')
                                                            .doc(useremail)
                                                            .collection('Cart')
                                                            .doc(snapshot
                                                                .data![index]
                                                                .id)
                                                            .delete();
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.black38,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
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
                            Text("₹ ${totalamount + totaldiscount}",
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
                            Text("₹ $totaldelivery", style: TextStyle()),
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
                            Text("₹ $totaldiscount", style: TextStyle()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                            Text("₹ $totalamount",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, bottom: 8),
                        child: Row(
                          children: [
                            Text("You will save ₹ $totaldiscount on this order",
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
            ],
          ),
        ),
      ),
    );
  }

  Future<List<DocumentSnapshot>> _fetchProducts() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('builders')
        .doc(useremail)
        .collection("Cart")
        .get();

    items = querySnapshot.docs;
    return querySnapshot.docs;
  }
}
