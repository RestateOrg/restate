import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:restate/Utils/getlocation.dart';
import 'package:restate/Utils/hexcolor.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class UploadMachinery extends StatefulWidget {
  const UploadMachinery({super.key});

  @override
  State<UploadMachinery> createState() => _UploadMachineryState();
}

class _UploadMachineryState extends State<UploadMachinery> {
  List<XFile>? images = [];
  List<String> items = [];
  final List<String> _dropdownValues = [
    'Excellent',
    'Good',
    'Average',
    'Poor',
  ];
  final List<String> _dropdownValues2 = [
    'Mini',
    'Standard',
    'Large',
    'Extra Large',
  ];
  String? machinerytype;
  String? useremail = FirebaseAuth.instance.currentUser?.email;
  TextEditingController search = TextEditingController();
  TextEditingController _machineryname = TextEditingController();
  TextEditingController _brandname = TextEditingController();
  TextEditingController _specifications = TextEditingController();
  TextEditingController _rentonhourlybasis = TextEditingController();
  TextEditingController _rentondaybasis = TextEditingController();
  TextEditingController _rentonweeklybasis = TextEditingController();
  TextEditingController _rentonmonthlybasis = TextEditingController();
  TextEditingController _zipCode = TextEditingController();
  TextEditingController _deliveredwithin = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  late List<String> downloadurls;
  String condition = 'Excellent';
  String backhoeSize = 'Standard';
  @override
  void initState() {
    super.initState();
    create_list();
  }

  @override
  void dispose() {
    search.dispose();
    _machineryname.dispose();
    _brandname.dispose();
    _specifications.dispose();
    _rentonhourlybasis.dispose();
    _rentondaybasis.dispose();
    _rentonweeklybasis.dispose();
    _rentonmonthlybasis.dispose();
    _zipCode.dispose();
    _deliveredwithin.dispose();
    _quantity.dispose();
    super.dispose();
  }

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
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, String>? locationInfo = await getLocationInfo(_zipCode.text);
    Timestamp myTimeStamp = Timestamp.now();
    DateTime dateTime = myTimeStamp.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    try {
      DocumentReference projectRef = firestore
          .collection('machinery')
          .doc(useremail)
          .collection('inventory')
          .doc(_machineryname.text);

      if (images!.isEmpty ||
          _machineryname.text.isEmpty ||
          _brandname.text.isEmpty ||
          machinerytype!.isEmpty ||
          _specifications.text.isEmpty ||
          _zipCode.text.isEmpty ||
          _rentonhourlybasis.text.isEmpty ||
          _rentondaybasis.text.isEmpty) {
        throw Exception("Fields must not be empty");
      }
      _showDocumentIdPopup2("Data Upload Sucessful",
          "Your Machinery has been uploaded sucessfully");
      downloadurls = await uploadImages(images!);
      (machinerytype == "Backhoe Loader")
          ? await projectRef.set({
              'machinery_name': _machineryname.text,
              'brand_name': _brandname.text,
              'machinery_type': machinerytype,
              'specifications': _specifications.text,
              'back_hoe_size': backhoeSize,
              'condition': condition,
              'city': locationInfo?['city'],
              'state': locationInfo?['state'],
              'country': locationInfo?['country'],
              'hourly': _rentonhourlybasis.text,
              'day': _rentondaybasis.text,
              'week': _rentonweeklybasis.text,
              'month': _rentonmonthlybasis.text,
              'zip_code': _zipCode.text,
              'image_urls': downloadurls,
              'status': 'Available',
              'rating': 0,
              'rating_count': 0,
              'timestamp': formattedDate,
              'delivered_within': _deliveredwithin.text,
            })
          : await projectRef.set({
              'machinery_name': _machineryname.text,
              'brand_name': _brandname.text,
              'machinery_type': machinerytype,
              'specifications': _specifications.text,
              'condition': condition,
              'city': locationInfo?['city'],
              'state': locationInfo?['state'],
              'country': locationInfo?['country'],
              'hourly': _rentonhourlybasis.text,
              'day': _rentondaybasis.text,
              'week': _rentonweeklybasis.text,
              'month': _rentonmonthlybasis.text,
              'zip_code': _zipCode.text,
              'image_urls': downloadurls,
              'status': 'Available',
              'rating': 0,
              'rating_count': 0,
              'timestamp': formattedDate,
              'delivered_within': _deliveredwithin.text,
            });
      uploadData2();
    } catch (e) {
      _showDocumentIdPopup(
          "All Fields Must Not Be Empty", 'Error Uploading Data');
    }
  }

  Future<void> uploadData2() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, String>? locationInfo = await getLocationInfo(_zipCode.text);
    DocumentReference projectRef =
        firestore.collection('machinery inventory').doc();
    Timestamp myTimeStamp = Timestamp.now();
    DateTime dateTime = myTimeStamp.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    (machinerytype == "Backhoe Loader")
        ? await projectRef.set({
            'machinery_name': _machineryname.text,
            'brand_name': _brandname.text,
            'machinery_type': machinerytype,
            'specifications': _specifications.text,
            'back_hoe_size': backhoeSize,
            'condition': condition,
            'city': locationInfo?['city'],
            'state': locationInfo?['state'],
            'country': locationInfo?['country'],
            'hourly': _rentonhourlybasis.text,
            'day': _rentondaybasis.text,
            'week': _rentonweeklybasis.text,
            'month': _rentonmonthlybasis.text,
            'image_urls': downloadurls,
            'status': 'Available',
            'rating': 0,
            'rating_count': 0,
            'useremail': useremail,
            'timestamp': formattedDate,
            'delivered_within': _deliveredwithin.text,
          })
        : await projectRef.set({
            'machinery_name': _machineryname.text,
            'brand_name': _brandname.text,
            'machinery_type': machinerytype,
            'specifications': _specifications.text,
            'condition': condition,
            'city': locationInfo?['city'],
            'state': locationInfo?['state'],
            'country': locationInfo?['country'],
            'hourly': _rentonhourlybasis.text,
            'day': _rentondaybasis.text,
            'week': _rentonweeklybasis.text,
            'month': _rentonmonthlybasis.text,
            'image_urls': downloadurls,
            'status': 'Available',
            'rating': 0,
            'rating_count': 0,
            'useremail': useremail,
            'timestamp': formattedDate,
            'delivered_within': _deliveredwithin.text,
          });
  }

  Future<List<String>> uploadImages(List<XFile> images) async {
    final storageRef = FirebaseStorage.instance.ref();
    final urls = <String>[]; // Create a list to store the download URLs

    try {
      for (var image in images) {
        final imageRef = storageRef
            .child('images/${DateTime.now()}.${image.name.split('.').last}');
        final uploadTask = imageRef.putFile(File(image.path));

        final snapshot = await uploadTask;
        final downloadURL = await snapshot.ref.getDownloadURL();
        urls.add(downloadURL); // Add the download URL to the list
      }

      return urls; // Return the list of download URLs
    } catch (error) {
      print('Error uploading images: $error');
      rethrow; // Rethrow the error to be handled by the caller
    }
  }

  void create_list() {
    FirebaseFirestore.instance
        .collection('Machinery types')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> fields = doc.data() as Map<String, dynamic>;
        List<String> values =
            fields.values.cast<String>().toList(); // Cast to strings
        items.addAll(values);
      });
      setState(() {});
    }).catchError((error) {
      // Handle errors here
      print('Error fetching data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Text("New Machinery",
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
            onTap: () {
              uploadData();
            },
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
        child: Column(
          children: [
            images!.isEmpty
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
                                      child: Text(
                                          "Machinery Photo (${images!.length}/4)",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w600))),
                                  Positioned(
                                      right: width * 0.03,
                                      top: width * 0.02,
                                      child: GestureDetector(
                                        onTap: () {
                                          pickImages();
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
                                top: width * 0.35,
                                left: width * 0.33,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        pickImages();
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
                                      child: Text(
                                          "Machinery Photo (${images!.length}/4)",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w600))),
                                  Positioned(
                                      right: width * 0.03,
                                      top: width * 0.02,
                                      child: GestureDetector(
                                        onTap: () {
                                          pickImages();
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
                            Padding(
                              padding: EdgeInsets.only(top: width * 0.1),
                              child: Container(
                                child: Center(
                                    child: PageView.builder(
                                        itemCount: images!.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              child: Image.file(
                                                  File(images![index].path)));
                                        })),
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
                  ),
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.06,
                top: width * 0.024,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Machinery name",
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
                    controller: _machineryname,
                    decoration: InputDecoration(
                      hintText: 'Enter the machinery Name',
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
                  "Brand name",
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
                    controller: _brandname,
                    decoration: InputDecoration(
                      hintText: 'Enter the Brand Name',
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
                  "Machinery Type",
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
                left: width * 0.03,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      'Select Type',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: items
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    value: machinerytype,
                    onChanged: (value) {
                      setState(() {
                        machinerytype = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 40,
                      width: 200,
                    ),
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 200,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: search,
                      searchInnerWidgetHeight: 50,
                      searchInnerWidget: Container(
                        height: 50,
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 4,
                          right: 8,
                          left: 8,
                        ),
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: search,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Search for an item...',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return item.value
                            .toString()
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      },
                    ),
                    //This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        search.clear();
                      }
                    },
                  ),
                ),
              ),
            ),
            (machinerytype == "Backhoe Loader")
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.06,
                          top: width * 0.024,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Horse power",
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
                              controller: _specifications,
                              decoration: InputDecoration(
                                hintText: 'Enter the Horse Power of Machinery',
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
                            "Backhoe size",
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
                            child: DropdownButton<String>(
                              underline: Container(
                                height: 1,
                                decoration: BoxDecoration(color: Colors.black),
                              ),
                              value: backhoeSize,
                              items: _dropdownValues2.map((value) {
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
                                  backhoeSize = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : (machinerytype == "Excavator")
                    ? Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: width * 0.06,
                              top: width * 0.024,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Operating Capacity",
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
                                  controller: _specifications,
                                  decoration: InputDecoration(
                                    hintText: 'Enter The operating capacity',
                                    hintStyle: TextStyle(fontSize: 14.0),
                                    contentPadding: const EdgeInsets.only(
                                      left: 5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : (machinerytype == "Bulldozer")
                        ? Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: width * 0.06,
                                  top: width * 0.024,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Horse power",
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
                                        right: width * 0.04,
                                        left: width * 0.04),
                                    child: TextField(
                                      controller: _specifications,
                                      decoration: InputDecoration(
                                        hintText: 'Enter the Horse power',
                                        hintStyle: TextStyle(fontSize: 14.0),
                                        contentPadding: const EdgeInsets.only(
                                          left: 5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : machinerytype != null
                            ? machinerytype!.contains('Crane') ||
                                    machinerytype!.contains('Forklift')
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: width * 0.06,
                                          top: width * 0.024,
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Lifting Capacity",
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
                                                right: width * 0.04,
                                                left: width * 0.04),
                                            child: TextField(
                                              controller: _specifications,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Enter the lifting capacity',
                                                hintStyle:
                                                    TextStyle(fontSize: 14.0),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                  left: 5,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : machinerytype!.contains('Rollers')
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: width * 0.06,
                                              top: width * 0.024,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Drum Width",
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
                                                    right: width * 0.04,
                                                    left: width * 0.04),
                                                child: TextField(
                                                  controller: _specifications,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Enter the Drum Width',
                                                    hintStyle: TextStyle(
                                                        fontSize: 14.0),
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                      left: 5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : machinerytype!.contains('Mixer') ||
                                            machinerytype!
                                                .contains('Tractor') ||
                                            machinerytype!.contains('Loader')
                                        ? Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: width * 0.06,
                                                  top: width * 0.024,
                                                ),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Capacity",
                                                    style: TextStyle(
                                                      fontSize: width * 0.045,
                                                      fontWeight:
                                                          FontWeight.w900,
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: width * 0.04,
                                                        left: width * 0.04),
                                                    child: TextField(
                                                      controller:
                                                          _specifications,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Enter the Capacity',
                                                        hintStyle: TextStyle(
                                                            fontSize: 14.0),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 5,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: width * 0.06,
                                                  top: width * 0.024,
                                                ),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Specifications",
                                                    style: TextStyle(
                                                      fontSize: width * 0.045,
                                                      fontWeight:
                                                          FontWeight.w900,
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: width * 0.04,
                                                        left: width * 0.04),
                                                    child: TextField(
                                                      controller:
                                                          _specifications,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Enter the Specifications',
                                                        hintStyle: TextStyle(
                                                            fontSize: 14.0),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 5,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                            : Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: width * 0.06,
                                      top: width * 0.024,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Specifications",
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
                                            right: width * 0.04,
                                            left: width * 0.04),
                                        child: TextField(
                                          controller: _specifications,
                                          decoration: InputDecoration(
                                            hintText:
                                                'Enter the Specifications',
                                            hintStyle:
                                                TextStyle(fontSize: 14.0),
                                            contentPadding:
                                                const EdgeInsets.only(
                                              left: 5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.06,
                top: width * 0.024,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Condition",
                  style: TextStyle(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.09),
              child: Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton<String>(
                  underline: Container(
                    height: 1,
                    decoration: BoxDecoration(color: Colors.black),
                  ),
                  value: condition,
                  items: _dropdownValues.map((value) {
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
                      condition = newValue!;
                    });
                  },
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
                  padding:
                      EdgeInsets.only(right: width * 0.04, left: width * 0.04),
                  child: TextField(
                    controller: _zipCode,
                    decoration: InputDecoration(
                      hintText: 'Enter the Zipcode',
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
                  "Delivered within",
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
                    controller: _deliveredwithin,
                    decoration: InputDecoration(
                      hintText: 'Enter how much time will it take to deliver',
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
                  "Quantity Available",
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
                    controller: _deliveredwithin,
                    decoration: InputDecoration(
                      hintText: 'Enter How Many Machinery You Have',
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
                  "Hourly",
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
                    controller: _rentonhourlybasis,
                    decoration: InputDecoration(
                      hintText: 'Enter Rent on Hourly Basis',
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
                  "Day",
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
                    controller: _rentondaybasis,
                    decoration: InputDecoration(
                      hintText: 'Enter Rent on Day Basis',
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
                  "Week",
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
                    controller: _rentonweeklybasis,
                    decoration: InputDecoration(
                      hintText: 'Enter Rent on Weekly Basis',
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
                  "Month",
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      EdgeInsets.only(right: width * 0.04, left: width * 0.04),
                  child: TextField(
                    controller: _rentonmonthlybasis,
                    decoration: InputDecoration(
                      hintText: 'Enter Rent on Monthly Basis',
                      hintStyle: TextStyle(fontSize: 14.0),
                      contentPadding: const EdgeInsets.only(
                        left: 5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//multiple image picker function from gallery
  Future<void> pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();
    final limitedImages = pickedImages.take(4).toList();
    setState(() {
      if (images!.length < 4 && (images!.length + limitedImages.length) <= 4) {
        images = [...?images, ...limitedImages];
      } else {
        images = [...limitedImages];
      }
    });
  }

//multiple image picker function from camera
  Future _pickImageFromCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        if (images!.length < 4) {
          images = [...?images, pickedImage];
        } else {
          images = [pickedImage];
        }
      });
    }
  }
}
