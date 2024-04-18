import 'dart:math';

import 'package:flutter/material.dart';
import 'package:restate/Builder/Upload_project.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryChoose extends StatefulWidget {
  final List<QueryDocumentSnapshot> deliverySnapshots;

  DeliveryChoose({Key? key, required this.deliverySnapshots});
  @override
  State<DeliveryChoose> createState() => _DeliveryChooseState();
}

class _DeliveryChooseState extends State<DeliveryChoose> {
  int selectedIndex = -1;
  String location = '';
  String city = '';
  String state = '';
  String name = '';
  String imageurl = '';
  String projecttype = '';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Choose Delivery Address'),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (selectedIndex != -1) {
            Navigator.pop(context, {
              'location': location,
              'city': city,
              'state': state,
              'name': name,
              'imageurl': imageurl,
              'projecttype': projecttype
            });
          }
        },
        child: Container(
            height: 70,
            color: Colors.amber,
            child: Center(
              child: Text("Select Address"),
            )),
      ),
      body: widget.deliverySnapshots.isEmpty
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
                    itemCount: min(widget.deliverySnapshots.length, 3),
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        title: Text(
                            "${widget.deliverySnapshots[index]['projectname']}"),
                        subtitle: Text(
                          "${widget.deliverySnapshots[index]['location']},${widget.deliverySnapshots[index]['city']},${widget.deliverySnapshots[index]['state']}"
                                      .length <
                                  40
                              ? "${widget.deliverySnapshots[index]['location']},${widget.deliverySnapshots[index]['city']},${widget.deliverySnapshots[index]['state']}"
                              : "${widget.deliverySnapshots[index]['location']},${widget.deliverySnapshots[index]['city']},${widget.deliverySnapshots[index]['state']}"
                                      .substring(0, 37) +
                                  "...",
                        ),
                        value: index,
                        groupValue: selectedIndex,
                        onChanged: (int? value) {
                          setState(() {
                            selectedIndex = value!;
                            location =
                                widget.deliverySnapshots[index]['location'];
                            city = widget.deliverySnapshots[index]['city'];
                            state = widget.deliverySnapshots[index]['state'];
                            name =
                                widget.deliverySnapshots[index]['projectname'];
                            imageurl =
                                widget.deliverySnapshots[index]['imageURl'];
                            projecttype =
                                widget.deliverySnapshots[index]['projecttype'];
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
