import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class DeliveryDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now().add(Duration(days: 2));
    String formattedDate = DateFormat('dd MMM, EEEE').format(now);
    return Scaffold(
      backgroundColor: Color.fromARGB(231, 248, 248, 248),
      appBar: AppBar(
        title: Text('Delivery Details'),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: Container(
              width: width,
              color: Colors.white,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
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
                            text: 'Delivery charge varies with location ',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: '| Delivery By $formattedDate',
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
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              width: width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Delivery Instructions',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Items will be delivered to the address provided during checkout',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              width: width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Shipping Policy of Restate',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'In case of any issues, please contact us within 3 days or email us',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
