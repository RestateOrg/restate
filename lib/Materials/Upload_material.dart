import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:restate/Utils/getlocation.dart';
import 'package:restate/Utils/hexcolor.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

enum DeliveryOption { yes, no }

class UploadMaterial extends StatefulWidget {
  const UploadMaterial({super.key});

  @override
  State<UploadMaterial> createState() => _UploadMaterialState();
}

class _UploadMaterialState extends State<UploadMaterial> {
  List<XFile>? images = [];
  List<String> items = [];
  List<String> brand = [];
  final List<String> _dropdownValues = [
    'KG',
    'Piece',
    'Bag',
    'Meter',
    'Roll',
    'Tonne',
    'Feet'
  ];
  String? brandname;
  String? materialtype;
  String? useremail = FirebaseAuth.instance.currentUser?.email;
  TextEditingController search = TextEditingController();
  TextEditingController _zipCode = TextEditingController();
  TextEditingController _materialname = TextEditingController();
  TextEditingController _priceper = TextEditingController();
  TextEditingController _availablequantity = TextEditingController();
  TextEditingController _bagSize = TextEditingController();
  TextEditingController _deliveredwithin = TextEditingController();
  TextEditingController _priceOutcity = TextEditingController();
  TextEditingController _priceIncity = TextEditingController();
  late List<String> downloadurls;
  String per = 'KG';
  DeliveryOption? _deliveryOption = DeliveryOption.no;
  DeliveryOption? _deliveryOutcity = DeliveryOption.no;
  Position? _currentUserPosition;
  bool _isUploading = false;
  @override
  void initState() {
    super.initState();
    _getTheDistance();
    create_list();
    create_list2();
  }

  @override
  void dispose() {
    search.dispose();
    _zipCode.dispose();
    _materialname.dispose();
    _priceper.dispose();
    _availablequantity.dispose();
    _bagSize.dispose();
    _deliveredwithin.dispose();
    _priceOutcity.dispose();
    _priceIncity.dispose();
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

  Future _getTheDistance() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    _currentUserPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> uploadData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, String>? locationInfo = await getLocationInfo(_zipCode.text);
    Timestamp myTimeStamp = Timestamp.now();
    DateTime dateTime = myTimeStamp.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    await Future.delayed(Duration(seconds: 2));
    try {
      if (_materialname.text.isEmpty ||
          _priceper.text.isEmpty ||
          _zipCode.text.isEmpty ||
          brandname == null ||
          materialtype == null ||
          images!.isEmpty) {
        throw Exception("All fields must be filled");
      }
      downloadurls = await uploadImages(images!);
      DocumentReference projectRef = firestore
          .collection('materials')
          .doc(useremail)
          .collection('items')
          .doc(_materialname.text);
      per == 'Bag'
          ? _deliveryOption == DeliveryOption.yes
              ? _deliveryOutcity == DeliveryOption.yes
                  ? projectRef.set({
                      'Material_name': _materialname.text,
                      'Brand_name': brandname,
                      'Material_type': materialtype,
                      'Price_per': _priceper.text,
                      'Price_per_unit': per,
                      'Zipcode': _zipCode.text,
                      'city': locationInfo?['city'],
                      'state': locationInfo?['state'],
                      'country': locationInfo?['country'],
                      'Images': downloadurls,
                      'status': 'In Stock',
                      'rating': 0,
                      'rating_count': 0,
                      'bag_size': _bagSize.text,
                      'latitude': _currentUserPosition?.latitude,
                      'longitude': _currentUserPosition?.longitude,
                      'available_quantity': _availablequantity.text,
                      'delivered_within': _deliveredwithin.text,
                      'delivery_inside_city': _priceIncity.text,
                      'delivery_outside_city': _priceOutcity.text,
                      'useremail': useremail,
                      'timestamp': formattedDate,
                    })
                  : projectRef.set({
                      'Material_name': _materialname.text,
                      'Brand_name': brandname,
                      'Material_type': materialtype,
                      'Price_per': _priceper.text,
                      'Price_per_unit': per,
                      'Zipcode': _zipCode.text,
                      'city': locationInfo?['city'],
                      'state': locationInfo?['state'],
                      'country': locationInfo?['country'],
                      'Images': downloadurls,
                      'status': 'In Stock',
                      'rating': 0,
                      'rating_count': 0,
                      'bag_size': _bagSize.text,
                      'latitude': _currentUserPosition?.latitude,
                      'longitude': _currentUserPosition?.longitude,
                      'available_quantity': _availablequantity.text,
                      'delivered_within': _deliveredwithin.text,
                      'delivery_inside_city': _priceIncity.text,
                      'useremail': useremail,
                      'timestamp': formattedDate,
                    })
              : _deliveryOutcity == DeliveryOption.yes
                  ? projectRef.set({
                      'Material_name': _materialname.text,
                      'Brand_name': brandname,
                      'Material_type': materialtype,
                      'Price_per': _priceper.text,
                      'Price_per_unit': per,
                      'Zipcode': _zipCode.text,
                      'city': locationInfo?['city'],
                      'state': locationInfo?['state'],
                      'country': locationInfo?['country'],
                      'Images': downloadurls,
                      'status': 'In Stock',
                      'rating': 0,
                      'rating_count': 0,
                      'bag_size': _bagSize.text,
                      'latitude': _currentUserPosition?.latitude,
                      'longitude': _currentUserPosition?.longitude,
                      'available_quantity': _availablequantity.text,
                      'delivered_within': _deliveredwithin.text,
                      'delivery_outside_city': _priceOutcity.text,
                      'useremail': useremail,
                      'timestamp': formattedDate,
                    })
                  : projectRef.set({
                      'Material_name': _materialname.text,
                      'Brand_name': brandname,
                      'Material_type': materialtype,
                      'Price_per': _priceper.text,
                      'Price_per_unit': per,
                      'Zipcode': _zipCode.text,
                      'city': locationInfo?['city'],
                      'state': locationInfo?['state'],
                      'country': locationInfo?['country'],
                      'Images': downloadurls,
                      'status': 'In Stock',
                      'rating': 0,
                      'rating_count': 0,
                      'bag_size': _bagSize.text,
                      'latitude': _currentUserPosition?.latitude,
                      'longitude': _currentUserPosition?.longitude,
                      'available_quantity': _availablequantity.text,
                      'delivered_within': _deliveredwithin.text,
                      'useremail': useremail,
                      'timestamp': formattedDate,
                    })
          : projectRef.set({
              'Material_name': _materialname.text,
              'Brand_name': brandname,
              'Material_type': materialtype,
              'Price_per': _priceper.text,
              'Price_per_unit': per,
              'Zipcode': _zipCode.text,
              'city': locationInfo?['city'],
              'state': locationInfo?['state'],
              'country': locationInfo?['country'],
              'Images': downloadurls,
              'status': 'In Stock',
              'latitude': _currentUserPosition?.latitude,
              'longitude': _currentUserPosition?.longitude,
              'available_quantity': _availablequantity.text,
              'delivered_within': _deliveredwithin.text,
              'rating': 0,
              'rating_count': 0,
              'timestamp': formattedDate,
            });
      uploadData2();
    } catch (e) {
      _showDocumentIdPopup(
          "All Fields must not be empty", 'Error uploading data');
    }
  }

  Future<void> uploadData2() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, String>? locationInfo = await getLocationInfo(_zipCode.text);
    DocumentReference projectRef =
        firestore.collection('materials_inventory').doc();
    Timestamp myTimeStamp = Timestamp.now();
    DateTime dateTime = myTimeStamp.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    try {
      per == 'Bag'
          ? _deliveryOption == DeliveryOption.yes
              ? _deliveryOutcity == DeliveryOption.yes
                  ? projectRef.set({
                      'Material_name': _materialname.text,
                      'Brand_name': brandname,
                      'Material_type': materialtype,
                      'Price_per': _priceper.text,
                      'Price_per_unit': per,
                      'Zipcode': _zipCode.text,
                      'city': locationInfo?['city'],
                      'state': locationInfo?['state'],
                      'country': locationInfo?['country'],
                      'Images': downloadurls,
                      'status': 'In Stock',
                      'rating': 0,
                      'rating_count': 0,
                      'bag_size': _bagSize.text,
                      'latitude': _currentUserPosition?.latitude,
                      'longitude': _currentUserPosition?.longitude,
                      'available_quantity': _availablequantity.text,
                      'delivered_within': _deliveredwithin.text,
                      'delivery_inside_city': _priceIncity.text,
                      'delivery_outside_city': _priceOutcity.text,
                      'useremail': useremail,
                      'timestamp': formattedDate,
                    }).then(
                      (value) {
                        _showDocumentIdPopup2("Data Upload Sucessful",
                            "Your Material has been uploaded sucessfully");
                      },
                    )
                  : projectRef.set({
                      'Material_name': _materialname.text,
                      'Brand_name': brandname,
                      'Material_type': materialtype,
                      'Price_per': _priceper.text,
                      'Price_per_unit': per,
                      'Zipcode': _zipCode.text,
                      'city': locationInfo?['city'],
                      'state': locationInfo?['state'],
                      'country': locationInfo?['country'],
                      'Images': downloadurls,
                      'status': 'In Stock',
                      'rating': 0,
                      'rating_count': 0,
                      'bag_size': _bagSize.text,
                      'latitude': _currentUserPosition?.latitude,
                      'longitude': _currentUserPosition?.longitude,
                      'available_quantity': _availablequantity.text,
                      'delivered_within': _deliveredwithin.text,
                      'delivery_inside_city': _priceIncity.text,
                      'useremail': useremail,
                      'timestamp': formattedDate,
                    }).then(
                      (value) {
                        _showDocumentIdPopup2("Data Upload Sucessful",
                            "Your Material has been uploaded sucessfully");
                      },
                    )
              : _deliveryOutcity == DeliveryOption.yes
                  ? projectRef.set({
                      'Material_name': _materialname.text,
                      'Brand_name': brandname,
                      'Material_type': materialtype,
                      'Price_per': _priceper.text,
                      'Price_per_unit': per,
                      'Zipcode': _zipCode.text,
                      'city': locationInfo?['city'],
                      'state': locationInfo?['state'],
                      'country': locationInfo?['country'],
                      'Images': downloadurls,
                      'status': 'In Stock',
                      'rating': 0,
                      'rating_count': 0,
                      'bag_size': _bagSize.text,
                      'latitude': _currentUserPosition?.latitude,
                      'longitude': _currentUserPosition?.longitude,
                      'available_quantity': _availablequantity.text,
                      'delivered_within': _deliveredwithin.text,
                      'delivery_outside_city': _priceOutcity.text,
                      'useremail': useremail,
                      'timestamp': formattedDate,
                    }).then(
                      (value) {
                        _showDocumentIdPopup2("Data Upload Sucessful",
                            "Your Material has been uploaded sucessfully");
                      },
                    )
                  : projectRef.set({
                      'Material_name': _materialname.text,
                      'Brand_name': brandname,
                      'Material_type': materialtype,
                      'Price_per': _priceper.text,
                      'Price_per_unit': per,
                      'Zipcode': _zipCode.text,
                      'city': locationInfo?['city'],
                      'state': locationInfo?['state'],
                      'country': locationInfo?['country'],
                      'Images': downloadurls,
                      'status': 'In Stock',
                      'rating': 0,
                      'rating_count': 0,
                      'bag_size': _bagSize.text,
                      'latitude': _currentUserPosition?.latitude,
                      'longitude': _currentUserPosition?.longitude,
                      'available_quantity': _availablequantity.text,
                      'delivered_within': _deliveredwithin.text,
                      'useremail': useremail,
                      'timestamp': formattedDate,
                    }).then(
                      (value) {
                        _showDocumentIdPopup2("Data Upload Sucessful",
                            "Your Material has been uploaded sucessfully");
                      },
                    )
          : projectRef.set({
              'Material_name': _materialname.text,
              'Brand_name': brandname,
              'Material_type': materialtype,
              'Price_per': _priceper.text,
              'Price_per_unit': per,
              'Zipcode': _zipCode.text,
              'city': locationInfo?['city'],
              'state': locationInfo?['state'],
              'country': locationInfo?['country'],
              'Images': downloadurls,
              'status': 'In Stock',
              'latitude': _currentUserPosition?.latitude,
              'longitude': _currentUserPosition?.longitude,
              'available_quantity': _availablequantity.text,
              'delivered_within': _deliveredwithin.text,
              'rating': 0,
              'rating_count': 0,
              'useremail': useremail,
              'timestamp': formattedDate,
            }).then(
              (value) {
                _showDocumentIdPopup2("Data Upload Sucessful",
                    "Your Material has been uploaded sucessfully");
              },
            );
    } catch (e) {}
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
        .collection('Material_types')
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

  void create_list2() {
    FirebaseFirestore.instance
        .collection('Brands')
        .doc('Material_Brands') // Specify the document ID directly
        .get()
        .then((DocumentSnapshot docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> fields =
            docSnapshot.data()! as Map<String, dynamic>;
        List<String> values = fields.values.cast<String>().toList();
        brand.addAll(values);
        setState(() {});
      } else {
        // Handle the case where the document doesn't exist
        print('Document "Material_Brands" not found');
      }
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
        title: Text("New Material",
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
                alignment: Alignment.center,
                height: width * 0.08,
                width: width * 0.2,
                decoration: BoxDecoration(
                  color: HexColor('#2A2828'),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text("Upload",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontSize: width * 0.04,
                    )),
              ),
            ),
          )
        ],
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.white,
      body: _isUploading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                                color: Color.fromARGB(255, 255, 249, 222),
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
                                                "Material Photos (${images!.length}/4)",
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
                                                pickImages();
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
                                color: Color.fromARGB(255, 255, 249, 222),
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
                                                "Material Photos (${images!.length}/4)",
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
                                                pickImages();
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
                                  Padding(
                                    padding: EdgeInsets.only(top: width * 0.1),
                                    child: Container(
                                      child: Center(
                                          child: PageView.builder(
                                              itemCount: images!.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                    child: Image.file(File(
                                                        images![index].path)));
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
                        "Material name",
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
                          controller: _materialname,
                          decoration: InputDecoration(
                            hintText: 'Enter the materials Name',
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
                        padding: EdgeInsets.only(
                            right: width * 0.04, left: width * 0.01),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Select Brand',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: brand
                                  .map((item2) => DropdownMenuItem(
                                        value: item2,
                                        child: Text(
                                          item2,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: brandname,
                              onChanged: (value) {
                                setState(() {
                                  brandname = value;
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                searchMatchFn: (item2, searchValue) {
                                  return item2.value
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
                        "Material Type",
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
                          value: materialtype,
                          onChanged: (value) {
                            setState(() {
                              materialtype = value;
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
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.06,
                      top: width * 0.024,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Price Per",
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
                        value: per,
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
                            per = newValue!;
                            _bagSize.clear();
                          });
                        },
                      ),
                    ),
                  ),
                  per == 'Bag'
                      ? Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.06,
                            top: width * 0.024,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Bag Size",
                              style: TextStyle(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  per == 'Bag'
                      ? Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.02,
                          ),
                          child: Padding(
                              padding: EdgeInsets.only(
                                  right: width * 0.04, left: width * 0.04),
                              child: TextField(
                                controller: _bagSize,
                                decoration: InputDecoration(
                                  hintText: 'Enter the Bag Size',
                                  hintStyle: TextStyle(fontSize: 14.0),
                                  contentPadding: const EdgeInsets.only(
                                    left: 5,
                                  ),
                                ),
                              )))
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.06,
                      top: width * 0.024,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Available Quantity",
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
                          controller: _availablequantity,
                          decoration: InputDecoration(
                            hintText: 'Enter the Available Quantity',
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
                        "Price Per $per",
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
                          controller: _priceper,
                          decoration: InputDecoration(
                            hintText: 'Enter the Price per $per',
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
                        "Delivered Within",
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
                          controller: _deliveredwithin,
                          decoration: InputDecoration(
                            hintText: 'Enter the time for Delivery',
                            hintStyle: TextStyle(fontSize: 14.0),
                            contentPadding: const EdgeInsets.only(
                              left: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Delivery Available',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                        )),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: [
                              Radio<DeliveryOption>(
                                value: DeliveryOption.yes,
                                groupValue: _deliveryOption,
                                onChanged: (DeliveryOption? value) {
                                  setState(() {
                                    _deliveryOption = value;
                                  });
                                },
                              ),
                              const Text('Yes'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<DeliveryOption>(
                                value: DeliveryOption.no,
                                groupValue: _deliveryOption,
                                onChanged: (DeliveryOption? value) {
                                  setState(() {
                                    _deliveryOption = value;
                                  });
                                },
                              ),
                              const Text('No'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _deliveryOption == DeliveryOption.yes
                      ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.06,
                                top: width * 0.010,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Price with Delivery Inside The City",
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
                                    controller: _priceIncity,
                                    decoration: InputDecoration(
                                      hintText: 'Enter the Price with Delivery',
                                      hintStyle: TextStyle(fontSize: 14.0),
                                      contentPadding: const EdgeInsets.only(
                                        left: 5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              title:
                                  const Text('Delivery Available Outside City',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Roboto',
                                      )),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Radio<DeliveryOption>(
                                          value: DeliveryOption.yes,
                                          groupValue: _deliveryOutcity,
                                          onChanged: (DeliveryOption? value) {
                                            setState(() {
                                              _deliveryOutcity = value;
                                            });
                                          },
                                        ),
                                        const Text('Yes'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Radio<DeliveryOption>(
                                          value: DeliveryOption.no,
                                          groupValue: _deliveryOutcity,
                                          onChanged: (DeliveryOption? value) {
                                            setState(() {
                                              _deliveryOutcity = value;
                                            });
                                          },
                                        ),
                                        const Text('No'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  _deliveryOutcity == DeliveryOption.yes
                      ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.06,
                                top: width * 0.010,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Price with Delivery Outside The City",
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
                                      left: width * 0.04,
                                      bottom: width * 0.02),
                                  child: TextField(
                                    controller: _priceOutcity,
                                    decoration: InputDecoration(
                                      hintText: 'Enter the Price with Delivery',
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
                      : Container(),
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
