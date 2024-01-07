import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restate/Utils/hexcolor.dart';

class UploadProject extends StatefulWidget {
  const UploadProject({super.key});

  @override
  State<UploadProject> createState() => _UploadProjectState();
}

class _UploadProjectState extends State<UploadProject> {
  TextEditingController _fromdate = TextEditingController();
  TextEditingController _todate = TextEditingController();
  File? _image;
  @override
  void dispose() {
    _fromdate.dispose();
    _todate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Text("New Project",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              fontSize: 20,
            )),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.only(right: width * 0.06),
              child: Text("Upload",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    fontSize: width * 0.04,
                  )),
            ),
          )
        ],
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.amber,
      body: SingleChildScrollView(
        child: Column(children: [
          _image != null
              ? Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.04,
                    top: width * 0.02,
                    right: width * 0.04,
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                        color: HexColor('#F2F2F2'),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: width * 0.78,
                      child: Stack(
                        children: [
                          Positioned(
                              child: Container(
                            decoration: BoxDecoration(
                              color: HexColor('#2A2828'),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            height: width * 0.10,
                            child: Stack(
                              children: [
                                Positioned(
                                    top: width * 0.02,
                                    left: width * 0.03,
                                    child: Text("Project Photo",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w600))),
                                Positioned(
                                    right: width * 0.03,
                                    top: width * 0.02,
                                    child: GestureDetector(
                                      onTap: () {
                                        _pickImageFromGallery();
                                      },
                                      child: Text("Edit",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w500)),
                                    )),
                              ],
                            ),
                          )),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: width * 0.1),
                              child: Container(
                                width: width,
                                child: Image.file(
                                  _image!,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: width * 0.02,
                              left: width * 0.02,
                              child: GestureDetector(
                                  onTap: () {
                                    _pickImageFromCamera();
                                  },
                                  child: FaIcon(FontAwesomeIcons.camera,
                                      size: width * 0.06)))
                        ],
                      )),
                )
              : Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.04,
                    top: width * 0.02,
                    right: width * 0.04,
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                        color: HexColor('#F2F2F2'),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: width * 0.78,
                      child: Stack(
                        children: [
                          Positioned(
                              child: Container(
                            decoration: BoxDecoration(
                              color: HexColor('#2A2828'),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            height: width * 0.10,
                            child: Stack(
                              children: [
                                Positioned(
                                    top: width * 0.02,
                                    left: width * 0.03,
                                    child: Text("Project Photo",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w600))),
                                Positioned(
                                    right: width * 0.03,
                                    top: width * 0.02,
                                    child: GestureDetector(
                                      onTap: () {
                                        _pickImageFromGallery();
                                      },
                                      child: Text("Edit",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w500)),
                                    )),
                              ],
                            ),
                          )),
                          Positioned(
                              top: width * 0.38,
                              left: width * 0.39,
                              child: GestureDetector(
                                onTap: () {
                                  _pickImageFromGallery();
                                },
                                child: Image.asset(
                                  'assets/images/Addphoto2.png',
                                  width: width * 0.13,
                                  height: width * 0.13,
                                ),
                              )),
                          Positioned(
                              bottom: width * 0.02,
                              left: width * 0.02,
                              child: GestureDetector(
                                  onTap: () {
                                    _pickImageFromCamera();
                                  },
                                  child: FaIcon(FontAwesomeIcons.camera,
                                      size: width * 0.06)))
                        ],
                      )),
                ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.06,
              top: width * 0.024,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Project name",
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.02,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    EdgeInsets.only(right: width * 0.04, left: width * 0.04),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter the project Name',
                    hintStyle: TextStyle(fontSize: 14.0),
                    contentPadding: const EdgeInsets.only(
                      left: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.06,
              top: width * 0.024,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Project Description",
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.02,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    EdgeInsets.only(right: width * 0.04, left: width * 0.04),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter the project description',
                    hintStyle: TextStyle(fontSize: 14.0),
                    contentPadding: const EdgeInsets.only(
                      left: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.06,
              top: width * 0.024,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Location",
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.02,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    EdgeInsets.only(right: width * 0.04, left: width * 0.04),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter the project location',
                    hintStyle: TextStyle(fontSize: 14.0),
                    contentPadding: const EdgeInsets.only(
                      left: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.06,
              top: width * 0.024,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Contact Number",
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.02,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    EdgeInsets.only(right: width * 0.04, left: width * 0.04),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter the contact number',
                    hintStyle: TextStyle(fontSize: 14.0),
                    contentPadding: const EdgeInsets.only(
                      left: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.06,
              top: width * 0.024,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Site Conditions",
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.02,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    EdgeInsets.only(right: width * 0.04, left: width * 0.04),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Describe about site conditions',
                    hintStyle: TextStyle(fontSize: 14.0),
                    contentPadding: const EdgeInsets.only(
                      left: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.06,
              top: width * 0.024,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Delivery and Pickup",
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.02,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    EdgeInsets.only(right: width * 0.04, left: width * 0.04),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter delivery and pickup points',
                    hintStyle: TextStyle(fontSize: 14.0),
                    contentPadding: const EdgeInsets.only(
                      left: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.06,
              top: width * 0.024,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Timeline",
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.02,
              bottom: width * 0.03,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.07,
                        top: width * 0.024,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "From",
                          style: TextStyle(
                            fontSize: width * 0.038,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.4,
                        top: width * 0.024,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "To",
                          style: TextStyle(
                            fontSize: width * 0.038,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(left: width * 0.03),
                    child: Row(children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          width: 150,
                          height: 40,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15)),
                                    color: Colors.white),
                                width: 120,
                                height: 40,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, bottom: 4),
                                  child: TextField(
                                    readOnly: true,
                                    controller: _fromdate,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    onTap: () {
                                      _selectDate();
                                    },
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _selectDate();
                                },
                                child: FaIcon(
                                  FontAwesomeIcons.calendarDay,
                                  size: width * 0.06,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 7),
                      Container(
                        height: 1,
                        width: 10,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          width: 150,
                          height: 40,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15)),
                                    color: Colors.white),
                                width: 120,
                                height: 40,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, bottom: 4),
                                  child: TextField(
                                    readOnly: true,
                                    controller: _todate,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    onTap: () {
                                      _selectDate2();
                                    },
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _selectDate2();
                                },
                                child: FaIcon(
                                  FontAwesomeIcons.calendarDay,
                                  size: width * 0.06,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ])),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        _fromdate.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _selectDate2() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        _todate.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future _pickImageFromGallery() async {
    final pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedimage!.path);
    });
  }

  Future _pickImageFromCamera() async {
    final pickedimage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedimage!.path);
    });
  }
}
