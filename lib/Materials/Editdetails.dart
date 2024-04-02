import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restate/Utils/getlocation.dart';
import 'package:restate/Utils/hexcolor.dart';

class EditDetails extends StatefulWidget {
  final DocumentSnapshot snapshot;
  const EditDetails({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  File? _image;
  String imageurl = '';
  bool _isUploading = false;
  bool imageExists = false;
  bool imagechanged = false;
  String? useremail = FirebaseAuth.instance.currentUser?.email;
  TextEditingController _zipCode = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _contactNumber = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _fullName = TextEditingController();
  TextEditingController _gstNumber = TextEditingController();
  late DocumentReference DocumentRef;
  late List<String> downloadurls;
  late String selectedGender;
  void initState() {
    _zipCode.text = widget.snapshot['zipCode'];
    _address.text = widget.snapshot['address'];
    _contactNumber.text = widget.snapshot['contactNumber'];
    _email.text = widget.snapshot['email'];
    _fullName.text = widget.snapshot['fullName'];
    _gstNumber.text = widget.snapshot['gstNumber'];
    selectedGender = widget.snapshot['gender'];
    if ((widget.snapshot.data() as Map<String, dynamic>)
        .containsKey('profilepicture')) {
      setState(() {
        imageurl = widget.snapshot['profilepicture'];
        imageExists = true;
      });
    }
    setState(() {
      DocumentRef = FirebaseFirestore.instance
          .collection('materials')
          .doc(useremail)
          .collection('userinformation')
          .doc('userinfo');
    });
    super.initState();
  }

  void dispose() {
    _zipCode.dispose();
    _address.dispose();
    _contactNumber.dispose();
    _email.dispose();
    _fullName.dispose();
    _gstNumber.dispose();
    super.dispose();
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

  Future<void> updateData() async {
    Map<String, String>? locationInfo = await getLocationInfo(_zipCode.text);
    if (imagechanged == false) {
      imageurl = widget.snapshot['profilepicture'];
    } else {
      imageurl = await _getimageUrl();
    }
    await DocumentRef.update({
      'profilepicture': imageurl,
      'zipCode': _zipCode.text,
      'address': _address.text,
      'contactNumber': _contactNumber.text,
      'email': _email.text,
      'fullName': _fullName.text,
      'gstNumber': _gstNumber.text,
      'city': locationInfo?['city'],
      'state': locationInfo?['state'],
      'country': locationInfo?['country'],
    }).then(
      (value) {
        _showDocumentIdPopup2("Data Update Sucessful",
            "Your Details have been sucessfully Updated");
      },
    );
  }

  Future<String> _getimageUrl() async {
    if (_image != null) {
      String imageName = useremail!;
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
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Text("Edit Details",
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
                await updateData();
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
                decoration: BoxDecoration(
                  color: HexColor('#2A2828'),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Update",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                        fontSize: width * 0.04,
                      )),
                ),
              ),
            ),
          )
        ],
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.amber,
      body: _isUploading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  imageExists
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
                                            child: Text("Profile Photo",
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
                                                setState(() {
                                                  imageExists = false;
                                                  imagechanged = true;
                                                });
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
                                      padding:
                                          EdgeInsets.only(top: width * 0.1),
                                      child: Container(
                                        width: width,
                                        child: Image.network(
                                          imageurl,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
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
                                            setState(() {
                                              imageExists = false;
                                              imagechanged = true;
                                            });
                                          },
                                          child: FaIcon(FontAwesomeIcons.camera,
                                              size: width * 0.06)))
                                ],
                              )),
                        )
                      : _image != null
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
                                                child: Text("Profile Photo",
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
                                                    setState(() {
                                                      imagechanged = true;
                                                    });
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
                                          padding:
                                              EdgeInsets.only(top: width * 0.1),
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
                                                setState(() {
                                                  imagechanged = true;
                                                });
                                              },
                                              child: FaIcon(
                                                  FontAwesomeIcons.camera,
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
                                                child: Text("Profile Photo",
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
                                                    setState(() {
                                                      imagechanged = true;
                                                    });
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
                                                  setState(() {
                                                    imagechanged = true;
                                                  });
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
                                                setState(() {
                                                  imagechanged = true;
                                                });
                                              },
                                              child: FaIcon(
                                                  FontAwesomeIcons.camera,
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
                        "Full name",
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
                          controller: _fullName,
                          decoration: InputDecoration(
                            hintText: 'Enter the Full Name',
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
                        "Email ID",
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
                          controller: _email,
                          decoration: InputDecoration(
                            hintText: 'Enter New Email ID',
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
                      bottom: width * 0.03,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: width * 0.04, left: width * 0.04),
                        child: TextField(
                          controller: _contactNumber,
                          decoration: InputDecoration(
                            hintText: 'Enter the Contact Number',
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
                        "Address",
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
                        padding: EdgeInsets.only(
                            right: width * 0.04, left: width * 0.04),
                        child: TextField(
                          controller: _address,
                          decoration: InputDecoration(
                            hintText: 'Enter the Address',
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
                        "ZipCode",
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
                        padding: EdgeInsets.only(
                            right: width * 0.04, left: width * 0.04),
                        child: TextField(
                          controller: _zipCode,
                          decoration: InputDecoration(
                            hintText: 'Enter the ZipCode',
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
                        "GST Number",
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
                        padding: EdgeInsets.only(
                            right: width * 0.04, left: width * 0.04),
                        child: TextField(
                          controller: _gstNumber,
                          decoration: InputDecoration(
                            hintText: 'Enter the GST Number',
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
                      left: width * 0.08,
                      top: width * 0.024,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Gender",
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
                      left: width * 0.08,
                      bottom: width * 0.03,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButton<String>(
                        value: selectedGender,
                        underline: Container(
                          height: 2,
                          color: Colors.white54,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        items: <String>['Male', 'Female', 'Other']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
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
