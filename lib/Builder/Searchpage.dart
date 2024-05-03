import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restate/Builder/Searchresults.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _searchFocusNode = FocusNode();
  final User? _user = FirebaseAuth.instance.currentUser;
  String city = '';
  String search = '';
  List<String> items = [];
  List<String> searchList = [];
  List<String> machinery = [];
  List<String> materials = [];
  void initState() {
    setState(() {
      create_list();
      getCity();
    });

    super.initState();
  }

  void getCity() {
    var userDocument = FirebaseFirestore.instance
        .collection('builders')
        .doc(_user?.email)
        .collection('userinformation')
        .doc('userinfo')
        .get();
    userDocument.then((value) {
      setState(() {
        city = value['city'];
      });
    });
    print(city);
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
        machinery.addAll(values);
      });
    }).then((value) {
      setState(() {
        items.addAll(machinery);
        searchList = items;
      });
    }).catchError((error) {
      // Handle errors here
      print('Error fetching data: $error');
    });
    FirebaseFirestore.instance
        .collection('Material_types')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> fields = doc.data() as Map<String, dynamic>;
        List<String> values =
            fields.values.cast<String>().toList(); // Cast to strings
        materials.addAll(values);
      });
    }).then((value) {
      setState(() {
        items.addAll(materials);
        searchList = items;
      });
    }).then((value) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    }).catchError((error) {
      // Handle errors here
      print('Error fetching data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: width * 0.7,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(30),
            ),
            child: CupertinoSearchTextField(
              focusNode: _searchFocusNode,
              placeholder: 'Search',
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(30),
              onChanged: (context) {
                setState(() {
                  if (context.isEmpty) {
                    searchList = items;
                  } else {
                    searchList = items
                        .where((element) => element
                            .toLowerCase()
                            .contains(context.toLowerCase()))
                        .toList();
                  }
                });
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: searchList.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: ListTile(
                trailing: Icon(Icons.arrow_outward_outlined),
                title: Text(
                  searchList[index],
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  if (machinery.contains(searchList[index])) {
                    CollectionReference reference = FirebaseFirestore.instance
                        .collection('machinery inventory');
                    Query query = reference
                        .where(
                          'machinery_type',
                          isEqualTo: searchList[index],
                        )
                        .where(
                          'city',
                          isEqualTo: city,
                        )
                        .where('status', isEqualTo: "Available");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Searchresults(
                          query: query,
                          type: 'machinery',
                          searchkey: searchList[index],
                          index: 0,
                        ),
                      ),
                    );
                  } else {
                    CollectionReference reference = FirebaseFirestore.instance
                        .collection('materials_inventory');
                    Query query = reference
                        .where(
                          'Material_type',
                          isEqualTo: searchList[index],
                        )
                        .where(
                          'city',
                          isEqualTo: city,
                        )
                        .where('status', isEqualTo: "In Stock");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Searchresults(
                            query: query,
                            type: 'material',
                            searchkey: searchList[index],
                            index: 0),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
