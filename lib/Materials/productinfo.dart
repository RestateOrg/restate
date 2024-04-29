import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restate/Machinery/Searchresults.dart';

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
  List<QueryDocumentSnapshot> deliverySnapshots = [];
  int selectedIndex = 0;
  void initState() {
    super.initState();
    getDescription();
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
    return Scaffold(
        backgroundColor: Color.fromARGB(231, 255, 255, 255),
        appBar: AppBar(
          title: Text('Product Info'),
          backgroundColor: Colors.amber,
        ),
        body: SingleChildScrollView(
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
                                (index % widget.data['Images'].length).toInt();
                          });
                        },
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: widget.data['Images']
                                  [index % widget.data['Images'].length],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < widget.data['Images'].length; i++)
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
                            padding: const EdgeInsets.only(left: 8.0, top: 12),
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
                                    text: ' ${widget.data['Material_name']}',
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
                              alignment: AlignmentDirectional(-0.95, -0.7),
                              child: RatingBar(
                                initialRating: widget.data['rating'].toDouble(),
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: Icon(Icons.star, color: Colors.amber),
                                  half: Icon(Icons.star_half,
                                      color: Colors.amber),
                                  empty: Icon(Icons.star, color: Colors.grey),
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
                                  color: const Color.fromARGB(255, 195, 146, 0),
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
                                    text: '₹ ${widget.data['Price_per']} / ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${widget.data['Price_per_unit']}',
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
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Bag Size: ${widget.data['bag_size']}',
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
                                'Available quantity: ${widget.data['available_quantity']}',
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
                                'Delivered within: ${widget.data['delivered_within']}',
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
                                'Status: ${widget.data['status']}',
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
