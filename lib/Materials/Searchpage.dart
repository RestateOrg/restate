import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restate/Machinery/Searchresults.dart';

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
  List<String> items = ['Commercial', 'Residential', 'Other'];
  List<String> searchList = ['Commercial', 'Residential', 'Other'];
  void initState() {
    setState(() {
      getCity();
    });

    super.initState();
  }

  void getCity() {
    var userDocument = FirebaseFirestore.instance
        .collection('materials')
        .doc(_user?.email)
        .collection('userinformation')
        .doc('userinfo')
        .get();
    userDocument.then((value) {
      setState(() {
        city = value['city'];
      });
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
                  CollectionReference reference =
                      FirebaseFirestore.instance.collection('builder projects');
                  Query query = reference
                      .where(
                        'projecttype',
                        isEqualTo: searchList[index],
                      )
                      .where(
                        'city',
                        isEqualTo: city,
                      );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Searchresults(
                          query: query, searchkey: searchList[index]),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
