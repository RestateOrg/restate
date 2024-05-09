import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restate/Utils/hexcolor.dart';

class EditPage extends StatefulWidget {
  final dynamic snapshot;
  const EditPage({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List<XFile>? images = [];
  List<String> items = [];
  List<String> brand = [];
  bool isLoading = false;
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
  CollectionReference CollectionRef =
      FirebaseFirestore.instance.collection('materials_inventory');
  late List<String> downloadurls;
  String per = 'KG';
  void initState() {
    super.initState();
    setState(() {
      create_list();
      create_list2();
      _materialname.text = widget.snapshot['Material_name'];
      _priceper.text = widget.snapshot['Price_per'];
      _zipCode.text = widget.snapshot['Zipcode'];
      brandname = widget.snapshot['Brand_name'];
      materialtype = widget.snapshot['Material_type'];
      per = widget.snapshot['Price_per_unit'];
    });
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
        title: Text("Edit Page",
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
              setState(() {
                isLoading = true;
              });
              FirebaseFirestore.instance
                  .collection('materials')
                  .doc(useremail)
                  .collection('items')
                  .doc(widget.snapshot.id)
                  .update({
                'Material_name': _materialname.text,
                'Brand_name': brandname,
                'Material_type': materialtype,
                'Price_per': _priceper.text,
                'Price_per_unit': per,
                'Zipcode': _zipCode.text,
              }).then((value) {
                Query query = CollectionRef.where('Images',
                    isEqualTo: (widget.snapshot['Images']));
                query.get().then((querySnapshot) {
                  querySnapshot.docs.forEach((document) {
                    document.reference.update({
                      'Material_name': _materialname.text,
                      'Brand_name': brandname,
                      'Material_type': materialtype,
                      'Price_per': _priceper.text,
                      'Price_per_unit': per,
                      'Zipcode': _zipCode.text,
                    }).then((value) {
                      isLoading = false;
                      Navigator.pop(context);
                    });
                  });
                });
              });
            },
            child: Padding(
              padding: EdgeInsets.only(right: width * 0.06),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor('#2A2828'),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Text("Update",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                        fontSize: width * 0.04,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          )
        ],
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.white,
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
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
                                      child: Text("Material Photo",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w600))),
                                ],
                              ),
                            )),
                            Padding(
                              padding: EdgeInsets.only(top: width * 0.1),
                              child: Container(
                                child: Center(
                                    child: PageView.builder(
                                        itemCount:
                                            widget.snapshot['Images'].length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              child: Image.network(widget
                                                  .snapshot['Images'][index]));
                                        })),
                              ),
                            ),
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
