import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restate/Utils/hexcolor.dart';

class UploadMachinery extends StatefulWidget {
  const UploadMachinery({super.key});

  @override
  State<UploadMachinery> createState() => _UploadMachineryState();
}

class _UploadMachineryState extends State<UploadMachinery> {
  List<XFile>? images = [];
  String? useremail = FirebaseAuth.instance.currentUser?.email;

  @override
  void dispose() {
    super.dispose();
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
              Navigator.pop(context);
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
        child: Column(children: [
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
        ]),
      ),
    );
  }

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
