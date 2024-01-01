// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restate/screens/hexcolor.dart';
import 'package:restate/screens/signIn.dart';

class BuilderRegistration extends StatefulWidget {
  const BuilderRegistration({super.key});

  @override
  State<BuilderRegistration> createState() => _BuilderRegistrationState();
}

class _BuilderRegistrationState extends State<BuilderRegistration> {
  bool isChecked = false;
  String selectedGender = 'Male';
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController licenseNumberController = TextEditingController();
  void _showDocumentIdPopup(String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Account Created'),
          content: Text('The Account Was Created Successfully'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                ); // Close the dialog
              },
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _storeUserData() async {
    try {
      // Access Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a new document reference
      DocumentReference documentReference =
          await firestore.collection('builders').add({
        'fullName': fullNameController.text,
        'email': emailController.text,
        'contactNumber': contactNumberController.text,
        'password': passwordController.text,
        'addressLine1': addressLine1Controller.text,
        'addressLine2': addressLine2Controller.text,
        'zipCode': zipCodeController.text,
        'companyName': companyNameController.text,
        'licenseNumber': licenseNumberController.text,
        'gender': selectedGender,
        'acceptedTerms': isChecked,
      });
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      String documentId = documentReference.id;
      _showDocumentIdPopup(documentId);
    } catch (e) {
      print('Error storing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.amber,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.04,
                top: width * 0.03,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Builder Sign Up",
                  style: TextStyle(
                    fontSize: width * 0.0835,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
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
                  "Full name",
                  style: TextStyle(
                    fontSize: width * 0.039,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.04,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: width * 0.8,
                  child: TextField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Full Name',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
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
                  "Email Id",
                  style: TextStyle(
                    fontSize: width * 0.039,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.04,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: width * 0.8,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email Id',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
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
                  "Contact number",
                  style: TextStyle(
                    fontSize: width * 0.039,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.04,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: width * 0.8,
                  child: TextField(
                    controller: contactNumberController,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Mobile Number',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
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
                  "Password",
                  style: TextStyle(
                    fontSize: width * 0.039,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.04,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: width * 0.8,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
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
                  "Confirm Password",
                  style: TextStyle(
                    fontSize: width * 0.039,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.04,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: width * 0.8,
                  child: TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm Your Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
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
                  "Address Line 1",
                  style: TextStyle(
                    fontSize: width * 0.039,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.04,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: width * 0.8,
                  child: TextField(
                    controller: addressLine1Controller,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Address',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
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
                  "Address Line 2",
                  style: TextStyle(
                    fontSize: width * 0.039,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.04,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: width * 0.8,
                  child: TextField(
                    controller: addressLine2Controller,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Address',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
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
                  "Zip Code",
                  style: TextStyle(
                    fontSize: width * 0.039,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.04,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: width * 0.8,
                  child: TextField(
                    controller: zipCodeController,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Zip Code',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
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
                  "Company Name",
                  style: TextStyle(
                    fontSize: width * 0.039,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.04,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: width * 0.8,
                  child: TextField(
                    controller: companyNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your Company Name',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
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
                child: RichText(
                  text: TextSpan(
                    text: "Builder License Number  ",
                    style: TextStyle(
                      fontSize: width * 0.039,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.04,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: width * 0.8,
                  child: TextField(
                    controller: licenseNumberController,
                    decoration: InputDecoration(
                      hintText: 'Enter your License Number',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
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
                    fontSize: width * 0.038,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
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
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.02,
                top: width * 0.001,
              ),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: CheckboxListTile(
                    title: Text('Accept Terms & Conditions',
                        style: TextStyle(
                          fontSize: width * 0.039,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        )),
                    value: isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isChecked = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.blue,
                    checkColor: Colors.white,
                  )),
            ),
            Padding(
                padding: EdgeInsets.only(
                  top: width * 0.024,
                  bottom: width * 0.05,
                ),
                child: TextButton(
                  onPressed: () {
                    _storeUserData();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: HexColor('#242424'),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: Text("Create Account",
                      style: TextStyle(
                        fontSize: width * 0.039,
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
