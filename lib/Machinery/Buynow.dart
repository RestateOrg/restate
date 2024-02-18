import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restate/Builder/Upload_project.dart';
import 'package:restate/Machinery/Searchresults.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class BuyNow extends StatefulWidget {
  final Map<String, dynamic> data;
  final String type;
  const BuyNow({Key? key, required this.data, required this.type})
      : super(key: key);
  @override
  _BuyNowState createState() => _BuyNowState();
}

class _BuyNowState extends State<BuyNow> {
  int currentStep = 0;
  List<QueryDocumentSnapshot> deliverySnapshots = [];
  int selectedIndex = 0;
  String location = "";
  String city = "";
  String state = "";
  String name = "";
  String quantity = "1";
  String time = "1";
  String timeperiod = "Hour";
  int total = 0;
  int discount = 0;
  final firestore = FirebaseFirestore.instance;
  List<String> _quantityValues = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10"
  ];
  List<String> _timeperiodvalues = ["Hour", "Day", "Week", "Month"];
  void initState() {
    super.initState();
    getDeliveryAddress();
    assignvalues();
  }

  void dispose() {
    super.dispose();
    DefaultCacheManager().emptyCache();
  }

  void assignvalues() {
    if (timeperiod == "Hour") {
      total = int.parse(time) * int.parse(widget.data['hourly']);
      total = total * int.parse(quantity);
    } else if (timeperiod == "Day") {
      total = int.parse(time) * int.parse(widget.data['day']);
      total = total * int.parse(quantity);
    } else if (timeperiod == "Week") {
      total = int.parse(time) * int.parse(widget.data['week']);
      total = total * int.parse(quantity);
    } else if (timeperiod == "Month") {
      total = int.parse(time) * int.parse(widget.data['month']);
      total = total * int.parse(quantity);
    }
    discount = (total * 0.1).toInt();
  }

  Future<void> getDeliveryAddress() async {
    CollectionReference collectionReference = firestore
        .collection('builders')
        .doc("raja9392t@gmail.com")
        .collection('Projects');
    final querySnapshot =
        await collectionReference.orderBy("fromdate", descending: true).get();
    setState(() {
      deliverySnapshots = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Buy Now'),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: Colors.amber[600],
                  )),
          child: Stepper(
            type: StepperType.horizontal,
            steps: getSteps(width, MediaQuery.of(context).size.height),
            currentStep: currentStep,
            onStepContinue: () {
              setState(() => currentStep <
                      getSteps(width, MediaQuery.of(context).size.height)
                              .length -
                          1
                  ? currentStep += 1
                  : print("send data"));
            },
            onStepCancel: () {
              setState(
                  () => currentStep > 0 ? currentStep -= 1 : print("go back"));
            },
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Row(
                children: <Widget>[
                  currentStep == 0
                      ? Container()
                      : Expanded(
                          child: TextButton(
                            onPressed: details.onStepCancel,
                            child: Text('Back'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white, // Text Color
                              backgroundColor:
                                  Colors.grey, // Button Background Color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // Button corner radius
                              ),
                            ),
                          ),
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextButton(
                        onPressed: details.onStepContinue,
                        child: currentStep == 0
                            ? Text('Deliver Here')
                            : currentStep == 1
                                ? Text('Next')
                                : Text('Finish'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white, // Text Color
                          backgroundColor:
                              Colors.amber[600], // Button Background Color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                5), // Button corner radius
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }

  List<Step> getSteps(width, height) => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text('Address', style: TextStyle(fontSize: 14)),
          content: deliverySnapshots.isEmpty
              ? Column(children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadProject(),
                        ),
                      );
                    },
                    child: Container(
                      width: width,
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-0.9, 0),
                            child: Text(
                              "+ Add New Project",
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 212, 159, 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.65,
                    child: Center(
                      child: Text(
                        'No delivery address found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ])
              : Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UploadProject(),
                          ),
                        );
                      },
                      child: Container(
                        width: width,
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-0.9, 0),
                              child: Text(
                                "+ Add New Project",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color.fromARGB(255, 212, 159, 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      height: height * 0.65,
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return RadioListTile(
                            title: Text(
                                "${deliverySnapshots[index]['projectname']}"),
                            subtitle: Text(
                              "${deliverySnapshots[index]['location']},${deliverySnapshots[index]['city']},${deliverySnapshots[index]['state']}"
                                          .length <
                                      40
                                  ? "${deliverySnapshots[index]['location']},${deliverySnapshots[index]['city']},${deliverySnapshots[index]['state']}"
                                  : "${deliverySnapshots[index]['location']},${deliverySnapshots[index]['city']},${deliverySnapshots[index]['state']}"
                                          .substring(0, 37) +
                                      "...",
                            ),
                            value: index,
                            groupValue: selectedIndex,
                            onChanged: (int? value) {
                              setState(() {
                                selectedIndex = value!;
                                location = deliverySnapshots[index]['location'];
                                city = deliverySnapshots[index]['city'];
                                state = deliverySnapshots[index]['state'];
                                name = deliverySnapshots[index]['projectname'];
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text('Summary', style: TextStyle(fontSize: 14)),
          content: widget.type == 'machinery'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                        ),
                      )),
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
                            Flexible(
                              child: Align(
                                alignment: AlignmentDirectional(0.9, 0),
                                child: Container(
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
                                    onPressed: () {
                                      setState(() {
                                        currentStep = 0;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )
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
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: widget.data['image_urls'][0],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: width * 0.6,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          " ${widget.data['specifications'].toUpperCase()} ${widget.data['back_hoe_size']} ${widget.data['machinery_type']} ( ${widget.data['brand_name'].toUpperCase()} )",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: RatingBar(
                                              initialRating: widget
                                                  .data['rating']
                                                  .toDouble(),
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
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: Text(
                                            "(${widget.data['rating_count']})",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  "₹ ${widget.data['hourly']}",
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
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "₹ ${widget.data['day']}",
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
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "₹ ${widget.data['week']}",
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "₹ ${widget.data['month']}",
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
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                        "Deliveried within ${widget.data['delivered_within']}"),
                    Row(
                      children: [
                        Text(
                          "Quantity: ",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<String>(
                          underline: Container(
                            height: 1,
                            decoration: BoxDecoration(color: Colors.black),
                          ),
                          value: quantity,
                          items: _quantityValues.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              quantity = newValue!;
                              if (timeperiod == "Hour") {
                                total = int.parse(time) *
                                    int.parse(widget.data['hourly']);
                                total = total * int.parse(quantity);
                              } else if (timeperiod == "Day") {
                                total = int.parse(time) *
                                    int.parse(widget.data['day']);
                                total = total * int.parse(quantity);
                              } else if (timeperiod == "Week") {
                                total = int.parse(time) *
                                    int.parse(widget.data['week']);
                                total = total * int.parse(quantity);
                              } else if (timeperiod == "Month") {
                                total = int.parse(time) *
                                    int.parse(widget.data['month']);
                                total = total * int.parse(quantity);
                              }
                            });
                            setState(() {
                              discount = (total * 0.1).toInt();
                            });
                          },
                        ),
                        Spacer(),
                        Text(
                          "Duration: ",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<String>(
                          underline: Container(
                            height: 1,
                            decoration: BoxDecoration(color: Colors.black),
                          ),
                          value: time,
                          items: _quantityValues.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              time = newValue!;
                              if (timeperiod == "Hour") {
                                total = int.parse(time) *
                                    int.parse(widget.data['hourly']);
                                total = total * int.parse(quantity);
                              } else if (timeperiod == "Day") {
                                total = int.parse(time) *
                                    int.parse(widget.data['day']);
                                total = total * int.parse(quantity);
                              } else if (timeperiod == "Week") {
                                total = int.parse(time) *
                                    int.parse(widget.data['week']);
                                total = total * int.parse(quantity);
                              } else if (timeperiod == "Month") {
                                total = int.parse(time) *
                                    int.parse(widget.data['month']);
                                total = total * int.parse(quantity);
                              }
                            });
                            setState(() {
                              discount = (total * 0.1).toInt();
                            });
                          },
                        ),
                        Spacer(),
                        Text(
                          "Time period: ",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<String>(
                          underline: Container(
                            height: 1,
                            decoration: BoxDecoration(color: Colors.black),
                          ),
                          value: timeperiod,
                          items: _timeperiodvalues.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              timeperiod = newValue!;
                            });
                            setState(() {
                              if (timeperiod == "Hour") {
                                total = int.parse(time) *
                                    int.parse(widget.data['hourly']);
                                total = total * int.parse(quantity);
                              } else if (timeperiod == "Day") {
                                total = int.parse(time) *
                                    int.parse(widget.data['day']);
                                total = total * int.parse(quantity);
                              } else if (timeperiod == "Week") {
                                total = int.parse(time) *
                                    int.parse(widget.data['week']);
                                total = total * int.parse(quantity);
                              } else if (timeperiod == "Month") {
                                total = int.parse(time) *
                                    int.parse(widget.data['month']);
                                total = total * int.parse(quantity);
                              }
                            });
                            setState(() {
                              discount = (total * 0.1).toInt();
                            });
                          },
                        ),
                      ],
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(children: [
                        Text(
                          "Price Details",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(children: [
                        Text("Price"),
                        Spacer(),
                        Text("₹${total + discount}")
                      ]),
                    ),
                    Row(
                      children: [
                        Text("Discount"),
                        Spacer(),
                        Text("₹ $discount",
                            style: TextStyle(color: Colors.green)),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Delivery Charges"),
                        Spacer(),
                        Text("Free")
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          "₹${total}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Divider(),
                    Text(
                      "You will save ₹ $discount on this order",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Text(
                        "Total: ₹ $total",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      height: 100,
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.data['image'],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          Column(
                            children: [
                              Text(
                                widget.data['name'],
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                widget.data['price'],
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text('Payment', style: TextStyle(fontSize: 14)),
          content: Container(),
        ),
      ];
}
