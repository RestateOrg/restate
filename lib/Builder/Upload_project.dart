import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restate/Utils/getlocation.dart';
import 'package:restate/Utils/hexcolor.dart';

class UploadProject extends StatefulWidget {
  const UploadProject({super.key});

  @override
  State<UploadProject> createState() => _UploadProjectState();
}

class _UploadProjectState extends State<UploadProject> {
  TextEditingController _fromdate = TextEditingController();
  TextEditingController _todate = TextEditingController();
  TextEditingController _machineryrequired = TextEditingController();
  TextEditingController _duration = TextEditingController();
  TextEditingController _pricewilling = TextEditingController();
  TextEditingController _itemrequired = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  TextEditingController _deliverydate = TextEditingController();
  TextEditingController _projectname = TextEditingController();
  TextEditingController _projectdescription = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _zipCode = TextEditingController();
  TextEditingController _siteconditions = TextEditingController();
  TextEditingController _deliveryandpickup = TextEditingController();
  List<List<String>> materialList = [];
  List<List<String>> machineryList = [];
  List<Map> projectrequirements = [];
  File? _image;
  String? useremail = FirebaseAuth.instance.currentUser?.email;
  bool _isUploading = false;

  void _showDocumentIdPopup(String documentId, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(documentId),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  void _showDocumentIdPopup2(String documentId, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(documentId),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadData() async {
    String imageurl = await _getimageUrl();
    Map<String, String>? locationInfo = await getLocationInfo(_zipCode.text);
    try {
      if (_projectname.text.isEmpty ||
          _projectdescription.text.isEmpty ||
          _location.text.isEmpty ||
          _zipCode.text.isEmpty ||
          _siteconditions.text.isEmpty ||
          _deliveryandpickup.text.isEmpty ||
          _fromdate.text.isEmpty ||
          _todate.text.isEmpty ||
          _duration.text.isEmpty ||
          _pricewilling.text.isEmpty ||
          _quantity.text.isEmpty ||
          _deliverydate.text.isEmpty ||
          _image == null) {
        throw Exception('Please fill all the fields');
      }
      // Get a reference to the Firestore database
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference projectRef = firestore
          .collection('builders')
          .doc(useremail)
          .collection('Projects')
          .doc(_projectname.text);
      // Create a document reference with a unique ID
      await projectRef.set({
        'fromdate': _fromdate.text,
        'todate': _todate.text,
        'duration': _duration.text,
        'pricewilling': _pricewilling.text,
        'quantity': _quantity.text,
        'deliverydate': _deliverydate.text,
        'projectname': _projectname.text,
        'projectdescription': _projectdescription.text,
        'location': _location.text,
        'city': locationInfo?['city'],
        'state': locationInfo?['state'],
        'country': locationInfo?['country'],
        'zipCode': _zipCode.text,
        'siteconditions': _siteconditions.text,
        'deliveryandpickup': _deliveryandpickup.text,
        'imageURl': imageurl,
      });
      // Upload materialList and machineryList to Firestore
      for (List<String> material in materialList) {
        projectrequirements.add({
          'Item Name': material[0],
          'Quantity': material[1],
          'Delivery Date': material[2],
        });
      }
      // Upload materialList and machineryList to Firestore
      for (List<String> machinery in machineryList) {
        projectrequirements.add({
          'Item Name': machinery[0],
          'Duration': machinery[1],
          'Price Willing to Pay': machinery[2],
        });
      }
      await projectRef.update({'projectrequirements': projectrequirements});
      await uploadData2();
    } catch (e) {
      _showDocumentIdPopup(
          "All Fields Must Not Be Empty", 'Error Uploading Data');
    }
  }

  Future<void> uploadData2() async {
    String imageurl = await _getimageUrl();
    try {
      // Get a reference to the Firestore database
      Map<String, String>? locationInfo = await getLocationInfo(_zipCode.text);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference projectRef =
          firestore.collection('builder projects').doc();
      // Create a document reference with a unique ID
      await projectRef.set({
        'fromdate': _fromdate.text,
        'todate': _todate.text,
        'duration': _duration.text,
        'pricewilling': _pricewilling.text,
        'quantity': _quantity.text,
        'deliverydate': _deliverydate.text,
        'projectname': _projectname.text,
        'projectdescription': _projectdescription.text,
        'location': _location.text,
        'city': locationInfo?['city'],
        'state': locationInfo?['state'],
        'country': locationInfo?['country'],
        'zipCode': _zipCode.text,
        'siteconditions': _siteconditions.text,
        'deliveryandpickup': _deliveryandpickup.text,
        'email': useremail,
        'imageURl': imageurl,
        'project requirements': projectrequirements,
      }).then(
        (value) {
          _showDocumentIdPopup2("Data Upload Sucessful",
              "Your Material has been uploaded sucessfully");
        },
      );
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  Future<String> _getimageUrl() async {
    if (_image != null) {
      String imageName = _projectname.text;
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$imageName.jpg');
      UploadTask uploadTask = storageReference.putFile(_image!);

      try {
        await uploadTask; // Ensure upload completes before getting URL
        String imageURL = await storageReference.getDownloadURL();
        return imageURL;
      } catch (e) {
        // Handle any errors during upload
        print('Error uploading image: $e');
        return ''; // Return empty string if upload fails
      }
    } else {
      return ''; // No image to upload, return empty string
    }
  }

  @override
  void dispose() {
    _fromdate.dispose();
    _todate.dispose();
    _machineryrequired.dispose();
    _duration.dispose();
    _pricewilling.dispose();
    _itemrequired.dispose();
    _quantity.dispose();
    _deliverydate.dispose();
    _projectname.dispose();
    _projectdescription.dispose();
    _location.dispose();
    _siteconditions.dispose();
    _deliveryandpickup.dispose();
    _zipCode.dispose();
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
            onTap: () async {
              setState(() {
                _isUploading =
                    true; // Start the upload and show progress indicator
              });
              try {
                await uploadData();
              } catch (e) {
                print(e); // Handle or log error
              } finally {
                setState(() {
                  _isUploading =
                      false; // Hide progress indicator once upload is complete
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: width * 0.06),
              child: Container(
                height: width * 0.08,
                width: width * 0.2,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: HexColor('#2A2828'),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text("Upload",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      fontSize: width * 0.04,
                      color: Colors.white,
                    )),
              ),
            ),
          )
        ],
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.amber,
      body: _isUploading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                                                  fontWeight:
                                                      FontWeight.w600))),
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
                                                    fontWeight:
                                                        FontWeight.w500)),
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
                                                  fontWeight:
                                                      FontWeight.w600))),
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
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          )),
                                    ],
                                  ),
                                )),
                                Positioned(
                                    top: width * 0.35,
                                    left: width * 0.33,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _pickImageFromGallery();
                                          },
                                          child: Image.asset(
                                            'assets/images/Addphoto2.png',
                                            width: width * 0.13,
                                            height: width * 0.13,
                                          ),
                                        ),
                                        Text(
                                          "Click to Add Photo",
                                          style: TextStyle(
                                            fontSize: width * 0.03,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ],
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
                      padding: EdgeInsets.only(
                          right: width * 0.04, left: width * 0.04),
                      child: TextField(
                        controller: _projectname,
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
                      padding: EdgeInsets.only(
                          right: width * 0.04, left: width * 0.04),
                      child: TextField(
                        controller: _projectdescription,
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
                      padding: EdgeInsets.only(
                          right: width * 0.04, left: width * 0.04),
                      child: TextField(
                        controller: _location,
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
                      "Zipcode",
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
                      padding: EdgeInsets.only(
                          right: width * 0.04, left: width * 0.04),
                      child: TextField(
                        controller: _zipCode,
                        decoration: InputDecoration(
                          hintText: 'Enter the project Zipcode',
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
                      "Working Conditions",
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
                      padding: EdgeInsets.only(
                          right: width * 0.04, left: width * 0.04),
                      child: TextField(
                        controller: _siteconditions,
                        decoration: InputDecoration(
                          hintText: 'Describe about Working conditions',
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
                      padding: EdgeInsets.only(
                          right: width * 0.04, left: width * 0.04),
                      child: TextField(
                        controller: _deliveryandpickup,
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
                                        padding: const EdgeInsets.only(
                                            left: 8, bottom: 4),
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
                                        padding: const EdgeInsets.only(
                                            left: 8, bottom: 4),
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
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: width * 0.06,
                              top: width * 0.024,
                              bottom: width * 0.05,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Project Requirements",
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
                              left: width * 0.36,
                              top: width * 0.026,
                              bottom: width * 0.05,
                            ),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    _showDialog(context);
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: 27,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildCombinedListView(),
                _buildCombinedListView2(),
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

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showMaterialDialog(context);
                },
                child: Text('Materials'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showMachineryDialog(context);
                },
                child: Text('Machinery'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMaterialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text('Material Fields'),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Container(
                  color: Colors.black,
                  child: GestureDetector(
                    onTap: () {
                      _addToMaterialList(context);
                    },
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _itemrequired,
                decoration: InputDecoration(labelText: 'Item Required'),
              ),
              TextField(
                controller: _quantity,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              TextField(
                controller: _deliverydate,
                decoration: InputDecoration(labelText: 'Delivery Date'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMachineryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text('Machinery Fields'),
              Padding(
                padding: const EdgeInsets.only(left: 26),
                child: Container(
                  color: Colors.black,
                  child: GestureDetector(
                    onTap: () {
                      _addToMachineryList(context);
                    },
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _machineryrequired,
                decoration: InputDecoration(labelText: 'Machinery Required'),
              ),
              TextField(
                controller: _duration,
                decoration: InputDecoration(labelText: 'Duration'),
              ),
              TextField(
                controller: _pricewilling,
                decoration: InputDecoration(labelText: 'Price Willing to Pay'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addToMaterialList(BuildContext context) {
    // Get the text field values
    String itemRequired = _itemrequired
        .text; // Retrieve the value from the corresponding TextField
    String quantity =
        _quantity.text; // Retrieve the value from the corresponding TextField
    String deliveryDate = _deliverydate
        .text; // Retrieve the value from the corresponding TextField

    // Add the values to the nested list
    materialList.add(['$itemRequired', '$quantity', '$deliveryDate']);
    setState(() {});
    // Close the dialog
    Navigator.of(context).pop();
  }

  void _addToMachineryList(BuildContext context) {
    // Get the text field values
    String machineryRequired = _machineryrequired
        .text; // Retrieve the value from the corresponding TextField
    String duration =
        _duration.text; // Retrieve the value from the corresponding TextField
    String priceWillingToPay = _pricewilling
        .text; // Retrieve the value from the corresponding TextField

    // Add the values to the list
    machineryList
        .add(['$machineryRequired', '$duration', '$priceWillingToPay']);
    setState(() {});
    // Close the dialog
    Navigator.of(context).pop();
  }

  Widget _buildCombinedListView() {
    // Combine material and machinery lists
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: materialList.length,
      itemBuilder: (context, index) {
        // Determine whether the item is from material or machinery list
        return _buildListItem(materialList[index]);
      },
    );
  }

  Widget _buildListItem(List<String> item) {
    return Card(
      color: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), // Add rounded corners
      ),
      margin: EdgeInsets.only(left: 15, right: 12, bottom: 8),
      child: ListTile(
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField("Item name", item[0]),
            _buildField("Quantity", item[1]),
            _buildField("Delivery Date", item[2]),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text('$label: $value',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          )),
    );
  }

  Widget _buildCombinedListView2() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: machineryList.length,
      itemBuilder: (context, index) {
        // Determine whether the item is from material or machinery list
        return _buildListItem2(machineryList[index]);
      },
    );
  }

  Widget _buildListItem2(List<String> item) {
    return Card(
      color: Colors.black12,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), // Add rounded corners
      ),
      child: ListTile(
        // Assuming the first element is the item name
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField("Machinery name", item[0]),
            _buildField("Duration", item[1]),
            _buildField("Price Willing to Pay",
                item[2]), // Assuming the remaining elements are fields
          ],
        ),
      ),
    );
  }
}
