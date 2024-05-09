import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restate/Utils/getlocation.dart';
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
    'Excellent',
    'Good',
    'Average',
    'Poor',
  ];
  String? machinerytype;
  String? useremail = FirebaseAuth.instance.currentUser?.email;
  TextEditingController search = TextEditingController();
  TextEditingController _machineryname = TextEditingController();
  TextEditingController _brandname = TextEditingController();
  TextEditingController _backhoesize = TextEditingController();
  TextEditingController _specifications = TextEditingController();
  TextEditingController _rentonhourlybasis = TextEditingController();
  TextEditingController _rentondaybasis = TextEditingController();
  TextEditingController _rentonweeklybasis = TextEditingController();
  TextEditingController _rentonmonthlybasis = TextEditingController();
  TextEditingController _zipCode = TextEditingController();
  String? condition;
  Map<String, dynamic> data = {};
  CollectionReference CollectionRef =
      FirebaseFirestore.instance.collection('machinery inventory');
  void initState() {
    super.initState();
    setState(() {
      create_list();
      _machineryname.text = widget.snapshot['machinery_name'];
      _brandname.text = widget.snapshot['brand_name'];
      data = widget.snapshot.data();
      if (data.containsKey('backhoe_size')) {
        _backhoesize.text = data['backhoe_size'];
      }
      machinerytype = widget.snapshot['machinery_type'];
      _specifications.text = widget.snapshot['specifications'];
      _rentonhourlybasis.text = widget.snapshot['hourly'];
      _rentondaybasis.text = widget.snapshot['day'];
      _rentonweeklybasis.text = widget.snapshot['week'];
      _rentonmonthlybasis.text = widget.snapshot['month'];
      _zipCode.text = widget.snapshot['zip_code'];
      condition = widget.snapshot['condition'];
    });
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
            onTap: () async {
              setState(() => isLoading = true);
              Map<String, String>? locationInfo =
                  await getLocationInfo(_zipCode.text);
              FirebaseFirestore.instance
                  .collection('machinery')
                  .doc(useremail)
                  .collection('inventory')
                  .doc(widget.snapshot.id)
                  .update({
                'machinery_name': _machineryname.text,
                'brand_name': _brandname.text,
                'machinery_type': machinerytype,
                'day': _rentondaybasis.text,
                'hourly': _rentonhourlybasis.text,
                'month': _rentonmonthlybasis.text,
                'week': _rentonweeklybasis.text,
                'city': locationInfo?['city'],
                'state': locationInfo?['state'],
                'country': locationInfo?['country'],
                'specifications': _specifications.text,
                if (data.containsKey('backhoe_size'))
                  'backhoe_size': _backhoesize.text,
                'zip_code': _zipCode.text,
              }).then((value) {
                Query query = CollectionRef.where('image_urls',
                    isEqualTo: (widget.snapshot['image_urls']));
                query.get().then((querySnapshot) {
                  querySnapshot.docs.forEach((document) {
                    document.reference.update({
                      'machinery_name': _machineryname.text,
                      'brand_name': _brandname.text,
                      'machinery_type': machinerytype,
                      'day': _rentondaybasis.text,
                      'hourly': _rentonhourlybasis.text,
                      'month': _rentonmonthlybasis.text,
                      'week': _rentonweeklybasis.text,
                      'city': locationInfo?['city'],
                      'state': locationInfo?['state'],
                      'country': locationInfo?['country'],
                      'specifications': _specifications.text,
                      if (data.containsKey('backhoe_size'))
                        'backhoe_size': _backhoesize.text,
                      'zip_code': _zipCode.text,
                    }).then((value) {
                      setState(() {
                        isLoading = false;
                      });
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
                                        itemCount: widget
                                            .snapshot['image_urls'].length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              child: Image.network(
                                                  widget.snapshot['image_urls']
                                                      [index]));
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
                        padding: EdgeInsets.only(
                            right: width * 0.04, left: width * 0.04),
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
                        padding: EdgeInsets.only(
                            right: width * 0.04, left: width * 0.04),
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
                                      hintText:
                                          'Enter the Horse Power of Machinery',
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
                                  child: TextField(
                                    controller: _backhoesize,
                                    decoration: InputDecoration(
                                      hintText: 'Enter the Backhoe Size',
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
                                          right: width * 0.04,
                                          left: width * 0.04),
                                      child: TextField(
                                        controller: _specifications,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Enter The operating capacity',
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
                                      : machinerytype!.contains('Rollers')
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
                                                      "Drum Width",
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
                                                              'Enter the Drum Width',
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
                                          : machinerytype!.contains('Mixer') ||
                                                  machinerytype!
                                                      .contains('Tractor') ||
                                                  machinerytype!
                                                      .contains('Loader')
                                              ? Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: width * 0.06,
                                                        top: width * 0.024,
                                                      ),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Capacity",
                                                          style: TextStyle(
                                                            fontSize:
                                                                width * 0.045,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontFamily:
                                                                'Roboto',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: width * 0.02,
                                                      ),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: width *
                                                                      0.04,
                                                                  left: width *
                                                                      0.04),
                                                          child: TextField(
                                                            controller:
                                                                _specifications,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Enter the Capacity',
                                                              hintStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          14.0),
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
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Specifications",
                                                          style: TextStyle(
                                                            fontSize:
                                                                width * 0.045,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontFamily:
                                                                'Roboto',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: width * 0.02,
                                                      ),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: width *
                                                                      0.04,
                                                                  left: width *
                                                                      0.04),
                                                          child: TextField(
                                                            controller:
                                                                _specifications,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Enter the Specifications',
                                                              hintStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          14.0),
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
                        padding: EdgeInsets.only(
                            right: width * 0.04, left: width * 0.04),
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
                        padding: EdgeInsets.only(
                            right: width * 0.04, left: width * 0.04),
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
                        padding: EdgeInsets.only(
                            right: width * 0.04, left: width * 0.04),
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
                        padding: EdgeInsets.only(
                            right: width * 0.04, left: width * 0.04),
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
}
