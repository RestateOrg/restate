import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/Builder/Upload_project.dart';
import 'package:restate/Machinery/Buynow.dart';
import 'package:restate/Machinery/DeliveryInstruction.dart';
import 'package:restate/Machinery/Searchresults.dart';
import 'package:intl/intl.dart';
import 'package:restate/Machinery/machinery.dart';

class ProductInfo extends StatefulWidget {
  final Map<String, dynamic> data;
  final String type;
  const ProductInfo({Key? key, required this.data, required this.type})
      : super(key: key);

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int currentIndex = 0;
  final PageController controller = PageController();
  bool isLiked = false;
  bool isinCart = false;
  String city = '';
  String zipcode = '';
  String location = '';
  String description = '';
  int _selectedIndex = 0;
  List<QueryDocumentSnapshot> deliverySnapshots = [];
  int selectedIndex = 0;
  void initState() {
    super.initState();
    getDescription();
  }

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      if (isinCart) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MachinaryHomeScreen(
              initialSelectedIndex: 3,
            ),
          ),
        );
      } else {
        await firestore
            .collection('machinery')
            .doc(useremail)
            .collection('Cart')
            .add(widget.data)
            .then((value) {
          setState(() {
            isinCart = true;
          });
        });
        Fluttertoast.showToast(
          msg: 'Added to Cart',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        );
      }
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BuyNow(data: widget.data, type: widget.type)));
    }
  }

  void getDescription() {
    if (widget.type == 'machinery') {
      var userdocument = firestore
          .collection('Machinery_descriptions')
          .doc('All descriptions')
          .get();
      userdocument.then((value) {
        setState(() {
          description = value['${widget.data['machinery_type']}'];
        });
      });
    } else {
      var userdocument = firestore
          .collection('Materials_descriptions')
          .doc('All descriptions')
          .get();
      userdocument.then((value) {
        setState(() {
          description = value['${widget.data['Material_type']}'];
        });
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    DefaultCacheManager().emptyCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var time = DateTime.now().add(Duration(days: 2));
    String formattedDate = DateFormat('dd MMM, EEEE').format(time);
    return Scaffold(
        backgroundColor: Color.fromARGB(231, 255, 255, 255),
        appBar: AppBar(
          title: Text('Product Info'),
          backgroundColor: Colors.amber,
        ),
        body: widget.type == 'machinery'
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 300,
                            width: width,
                            child: PageView.builder(
                              controller: controller,
                              onPageChanged: (index) {
                                setState(() {
                                  currentIndex =
                                      (index % widget.data['image_urls'].length)
                                          .toInt();
                                });
                              },
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.data['image_urls'][index %
                                        widget.data['image_urls'].length],
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0;
                                  i < widget.data['image_urls'].length;
                                  i++)
                                buildIndicator(currentIndex == i)
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Container(
                        width: width,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, top: 10),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: widget.data
                                                  .containsKey('back_hoe_size')
                                              ? " ${widget.data['specifications'].toUpperCase()} ${widget.data['back_hoe_size']} ${widget.data['machinery_type']} ( ${widget.data['brand_name'].toUpperCase()} )"
                                                          .length <
                                                      50
                                                  ? " ${widget.data['specifications'].toUpperCase()} ${widget.data['back_hoe_size']} ${widget.data['machinery_type']} ( ${widget.data['brand_name'].toUpperCase()} )"
                                                  : " ${widget.data['specifications'].toUpperCase()} ${widget.data['back_hoe_size']} ${widget.data['machinery_type']} ( ${widget.data['brand_name'].toUpperCase()} )"
                                                          .substring(0, 47) +
                                                      '...'
                                              : " ${widget.data['specifications'].toUpperCase()} ${widget.data['machinery_type']} ( ${widget.data['brand_name'].toUpperCase()} )"
                                                          .length <
                                                      50
                                                  ? " ${widget.data['specifications'].toUpperCase()} ${widget.data['machinery_type']} ( ${widget.data['brand_name'].toUpperCase()} )"
                                                  : " ${widget.data['specifications'].toUpperCase()} ${widget.data['machinery_type']} ( ${widget.data['brand_name'].toUpperCase()} )"
                                                          .substring(0, 47) +
                                                      '...',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w200,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Align(
                                    alignment:
                                        AlignmentDirectional(-0.95, -0.7),
                                    child: RatingBar(
                                      initialRating:
                                          widget.data['rating'].toDouble(),
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      ratingWidget: RatingWidget(
                                        full: Icon(Icons.star,
                                            color: Colors.amber),
                                        half: Icon(Icons.star_half,
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
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    widget.data['rating_count'].toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: const Color.fromARGB(
                                            255, 195, 146, 0),
                                        fontFamily: 'Roboto'),
                                  ),
                                ),
                              ]),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, top: 4.0),
                              child: Align(
                                  alignment: AlignmentDirectional(-0.9, -0.7),
                                  child: Row(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  '₹ ${widget.data['hourly']} / ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Hour',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: const Color.fromARGB(
                                                      255, 195, 146, 0),
                                                  fontFamily: 'Roboto'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    '₹ ${widget.data['week']} / ',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'Week',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: const Color.fromARGB(
                                                        255, 195, 146, 0),
                                                    fontFamily: 'Roboto'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.0, top: 4.0, bottom: 8.0),
                                  child: Align(
                                      alignment:
                                          AlignmentDirectional(-0.95, -0.7),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  '₹ ${widget.data['day']} / ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Day',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: const Color.fromARGB(
                                                      255, 195, 146, 0),
                                                  fontFamily: 'Roboto'),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '₹ ${widget.data['month']} / ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Month',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: const Color.fromARGB(
                                                  255, 195, 146, 0),
                                              fontFamily: 'Roboto'),
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Container(
                        width: width,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Container(
                          width: width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Product Info',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 8.0, right: 8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Brand name: ${widget.data['brand_name'].toUpperCase()}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 8.0, right: 8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Type: ${widget.data['machinery_type']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 8.0, right: 8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Condition : ${widget.data['condition']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 8.0, right: 8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Available Quantity: ${widget.data['available quantity']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 8.0, right: 8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Delivered Within: ${widget.data['delivered_within']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                        left: 8.0,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Status: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, right: 8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.data['status'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8.0, right: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Rating : ${widget.data['rating']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Container(
                          width: width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Description',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8.0, right: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Align(
                                  alignment: AlignmentDirectional(0.9, 0),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0, top: 8),
                                    child: Icon(
                                      FontAwesomeIcons.share,
                                      size: 25,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, right: 8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      isLiked = !isLiked;
                                    });
                                    Fluttertoast.showToast(
                                      msg: isLiked
                                          ? 'Added to wishlist'
                                          : 'Removed from wishlist',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      fontSize: 16.0,
                                    );
                                    isLiked
                                        ? await firestore
                                            .collection('machinery')
                                            .doc(useremail)
                                            .collection('wishlist')
                                            .add(widget.data)
                                        : await firestore
                                            .collection('machinery')
                                            .doc(useremail)
                                            .collection('wishlist')
                                            .where('Images',
                                                isEqualTo:
                                                    widget.data['Images'])
                                            .get()
                                            .then((value) {
                                            value.docs.forEach((element) {
                                              element.reference.delete();
                                            });
                                          });
                                  },
                                  child: AnimatedSwitcher(
                                    duration: Duration(
                                        milliseconds:
                                            200), // Animation duration
                                    child: Icon(
                                      isLiked
                                          ? FontAwesomeIcons.solidHeart
                                          : FontAwesomeIcons.solidHeart,
                                      key: ValueKey<bool>(
                                          isLiked), // Key to distinguish between states
                                      color: isLiked ? Colors.red : Colors.grey,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 300,
                            width: width,
                            child: PageView.builder(
                              controller: controller,
                              onPageChanged: (index) {
                                setState(() {
                                  currentIndex =
                                      (index % widget.data['Images'].length)
                                          .toInt();
                                });
                              },
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.data['Images']
                                        [index % widget.data['Images'].length],
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0;
                                  i < widget.data['Images'].length;
                                  i++)
                                buildIndicator(currentIndex == i)
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Container(
                        width: width,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, top: 12),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: widget.data['Brand_name'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' ${widget.data['Material_name']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w200,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Align(
                                    alignment:
                                        AlignmentDirectional(-0.95, -0.7),
                                    child: RatingBar(
                                      initialRating:
                                          widget.data['rating'].toDouble(),
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      ratingWidget: RatingWidget(
                                        full: Icon(Icons.star,
                                            color: Colors.amber),
                                        half: Icon(Icons.star_half,
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
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    widget.data['rating_count'].toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: const Color.fromARGB(
                                            255, 195, 146, 0),
                                        fontFamily: 'Roboto'),
                                  ),
                                ),
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, top: 4.0, bottom: 12.0),
                              child: Align(
                                  alignment: AlignmentDirectional(-0.95, -0.7),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '₹ ${widget.data['Price_per']} / ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${widget.data['Price_per_unit']}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: const Color.fromARGB(
                                                  255, 195, 146, 0),
                                              fontFamily: 'Roboto'),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Container(
                          width: width,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Deliver to: ',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '$city - $zipcode',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  location != ''
                                      ? Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, bottom: 8),
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: location.length > 20
                                                        ? '$location'.substring(
                                                                0, 20) +
                                                            '...'
                                                        : '$location',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              Spacer(),
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor: Colors.white,
                                        context: context,
                                        builder: (builder) {
                                          return Scaffold(
                                            appBar: AppBar(
                                              automaticallyImplyLeading: false,
                                              backgroundColor: Colors.amber,
                                              leadingWidth: 50,
                                              leading: IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              title: Text(
                                                  'Select Project Address'),
                                            ),
                                            body: deliverySnapshots.isEmpty
                                                ? Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UploadProject(),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: width,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black12,
                                                                spreadRadius:
                                                                    0.5,
                                                                blurRadius: 0.5,
                                                                offset:
                                                                    const Offset(
                                                                        0, 3),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        -0.9,
                                                                        0),
                                                                child: Text(
                                                                  "+ Add New Project",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        212,
                                                                        159,
                                                                        0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  -0.2, 0),
                                                          child: Center(
                                                            child: Text(
                                                              'No delivery address found',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  UploadProject(),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: width,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black12,
                                                                spreadRadius:
                                                                    0.5,
                                                                blurRadius: 0.5,
                                                                offset:
                                                                    const Offset(
                                                                        0, 3),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        -0.9,
                                                                        0),
                                                                child: Text(
                                                                  "+ Add New Project",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        212,
                                                                        159,
                                                                        0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: ListView.builder(
                                                          itemCount:
                                                              deliverySnapshots
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return RadioListTile(
                                                              title: Text(
                                                                  "${deliverySnapshots[index]['projectname']}"),
                                                              subtitle: Text(
                                                                "${deliverySnapshots[index]['location']},${deliverySnapshots[index]['city']},${deliverySnapshots[index]['state']}"
                                                                            .length <
                                                                        40
                                                                    ? "${deliverySnapshots[index]['location']},${deliverySnapshots[index]['city']},${deliverySnapshots[index]['state']}"
                                                                    : "${deliverySnapshots[index]['location']},${deliverySnapshots[index]['city']},${deliverySnapshots[index]['state']}".substring(
                                                                            0,
                                                                            37) +
                                                                        "...",
                                                              ),
                                                              value: index,
                                                              groupValue:
                                                                  selectedIndex,
                                                              onChanged:
                                                                  (int? value) {
                                                                setState(() {
                                                                  selectedIndex =
                                                                      value!;
                                                                  city = deliverySnapshots[
                                                                          index]
                                                                      ['city'];
                                                                  zipcode = deliverySnapshots[
                                                                          index]
                                                                      [
                                                                      'zipcode'];
                                                                  location = deliverySnapshots[
                                                                          index]
                                                                      [
                                                                      'location'];
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 8.0,
                                            left: 18.0,
                                            right: 18),
                                        child: Text(
                                          'Change',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: const Color.fromARGB(
                                                255, 201, 151, 0),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeliveryDetailsPage()));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Container(
                          width: width,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 10, right: 10),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.truck,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Container(
                                    width: width * 0.6,
                                    child: RichText(
                                      text: TextSpan(
                                        text:
                                            'Delivery charge varies with location ',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                '| Delivery By $formattedDate',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Align(
                                    alignment: AlignmentDirectional(0.9, 0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black.withOpacity(0.7),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Container(
                          width: width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Column(children: [
                                  Icon(
                                    FontAwesomeIcons.ban,
                                    color:
                                        const Color.fromARGB(255, 217, 163, 0)
                                            .withOpacity(0.7),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Center(
                                      child: Container(
                                        width: 80,
                                        child: Center(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Text(
                                              'Cancellation upto 24 hrs',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                Spacer(),
                                Column(children: [
                                  Icon(
                                    FontAwesomeIcons.shieldHalved,
                                    color:
                                        const Color.fromARGB(255, 217, 163, 0)
                                            .withOpacity(0.7),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Center(
                                      child: Container(
                                        width: 80,
                                        child: Center(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Align(
                                              child: Text(
                                                'Top Graded Quality',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                Spacer(),
                                Column(children: [
                                  Icon(
                                    FontAwesomeIcons.truck,
                                    color:
                                        const Color.fromARGB(255, 217, 163, 0)
                                            .withOpacity(0.7),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Center(
                                      child: Container(
                                        width: 80,
                                        child: Center(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Align(
                                              child: Text(
                                                'Quick Delivery',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Container(
                          width: width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Highlights',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8.0, right: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Brand name: ${widget.data['Brand_name']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8.0, right: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Type: ${widget.data['Material_type']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8.0, right: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Quality : Best',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                                widget.data['Price_per_unit'] == 'Bag'
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 8.0, right: 8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Bag weight : ${widget.data['bag_size']}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Container(
                          width: width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Description',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8.0, right: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ));
  }

  Widget buildIndicator(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        height: isSelected ? 8 : 6,
        width: isSelected ? 8 : 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Color.fromARGB(255, 41, 41, 41) : Colors.grey,
        ),
      ),
    );
  }
}
