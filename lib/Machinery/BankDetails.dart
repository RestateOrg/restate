import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restate/Utils/hexcolor.dart';

class BankDetails extends StatefulWidget {
  final DocumentSnapshot snapshot;
  const BankDetails({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  String? useremail = FirebaseAuth.instance.currentUser?.email;
  TextEditingController _accountholdername = TextEditingController();
  TextEditingController _accountnumber = TextEditingController();
  TextEditingController _ifsc = TextEditingController();
  TextEditingController _bankname = TextEditingController();
  bool _isUploading = false;
  late List<String> downloadurls;
  late String selectedGender;
  void initState() {
    _accountholdername.text = widget.snapshot['accountHolderName'];
    _accountnumber.text = widget.snapshot['accountNumber'];
    _ifsc.text = widget.snapshot['ifscCode'];
    _bankname.text = widget.snapshot['bankName'];
    super.initState();
  }

  void dispose() {
    _accountholdername.dispose();
    _accountnumber.dispose();
    _ifsc.dispose();
    _bankname.dispose();
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
    await FirebaseFirestore.instance
        .collection('machinery')
        .doc(useremail)
        .collection('BankDetails')
        .doc('bankinfo')
        .update({
      'accountHolderName': _accountholdername.text,
      'accountNumber': _accountnumber.text,
      'ifscCode': _ifsc.text,
      'bankName': _bankname.text,
    }).then(
      (value) {
        _showDocumentIdPopup2("Data Update Sucessful",
            "Your Details have been sucessfully Updated");
      },
    );
    ;
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
                _isUploading = true;
              });
              try {
                await updateData();
              } catch (e) {
                print(e);
              } finally {
                setState(() {
                  _isUploading = false;
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
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.06,
                      top: width * 0.024,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Account Holder Name",
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
                          controller: _accountholdername,
                          decoration: InputDecoration(
                            hintText: 'Enter the Account Holder Name',
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
                        "Account Number",
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
                          controller: _accountnumber,
                          decoration: InputDecoration(
                            hintText: 'Enter Account Number',
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
                        "IFSC Code",
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
                          controller: _ifsc,
                          decoration: InputDecoration(
                            hintText: 'Enter the IFSC Code',
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
                        "Enter The Bank Name",
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
                          controller: _bankname,
                          decoration: InputDecoration(
                            hintText: 'Enter The Bank Name',
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
