import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restate/Utils/getlocation.dart';
import 'package:restate/Utils/hexcolor.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
  late List<String> downloadurls;
  String per = 'KG';
  @override
  void initState() {
    super.initState();
    create_list();
    create_list2();
  }

  @override
  void dispose() {
    search.dispose();
    _zipCode.dispose();
    _materialname.dispose();
    _priceper.dispose();
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
    try {
      if (_materialname.text.isEmpty ||
          _priceper.text.isEmpty ||
          _zipCode.text.isEmpty ||
          brandname == null ||
          materialtype == null ||
          images!.isEmpty) {
        throw Exception("All fields must be filled");
      }
      _showDocumentIdPopup2("Data Upload Sucessful",
          "Your Material has been uploaded sucessfully");
      downloadurls = await uploadImages(images!);
      DocumentReference projectRef = firestore
          .collection('materials')
          .doc(useremail)
          .collection('items')
          .doc(_materialname.text);

      projectRef.set({
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
    try {
      projectRef.set({
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
      });
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
            onTap: () {
              try {
                uploadData();
              } catch (e) {
                print(e);
              }
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
                                          "Material Photos (${images!.length}/4)",
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
                                          "Material Photos (${images!.length}/4)",
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
                  padding:
                      EdgeInsets.only(right: width * 0.04, left: width * 0.04),
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
                  padding:
                      EdgeInsets.only(right: width * 0.04, left: width * 0.01),
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
                  padding:
                      EdgeInsets.only(right: width * 0.04, left: width * 0.04),
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
                bottom: width * 0.03,
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
