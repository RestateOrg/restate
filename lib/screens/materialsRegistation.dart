import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restate/Utils/EmailVerify.dart';
import 'package:restate/Utils/getlocation.dart';
import 'package:restate/Utils/hexcolor.dart';
import 'package:restate/screens/signIn.dart';

class MaterialRegistration extends StatefulWidget {
  const MaterialRegistration({Key? key}) : super(key: key);

  @override
  State<MaterialRegistration> createState() => _MaterialRegistrationState();
}

class _MaterialRegistrationState extends State<MaterialRegistration> {
  bool isChecked = false;
  String selectedGender = 'Male';
  bool _passwordVisible = false;
  bool isLoading = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController companyRegistrationNumberController =
      TextEditingController();
  TextEditingController aadhaarNumberController = TextEditingController();
  @override
  void dispose() {
    // Dispose of all controllers when the widget is disposed
    fullNameController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    zipCodeController.dispose();
    companyRegistrationNumberController.dispose();
    aadhaarNumberController.dispose();

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              },
              child: const Text('Continue'),
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
                Navigator.of(context).pop();
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _storeUserData() async {
    String str = "The Account Was Created Successfully";
    String str2 = "Account Created";
    Map<String, String>? locationInfo =
        await getLocationInfo(zipCodeController.text);
    try {
      if (passwordController.text != confirmPasswordController.text) {
        setState(() {
          isLoading = false;
        });
        throw Exception("The Passwords Doesn't Match");
      }
      if (companyRegistrationNumberController.text.isEmpty) {
        setState(() {
          isLoading = false;
        });
        throw Exception("The GSTIN should be entered");
      }
      if (aadhaarNumberController.text.isEmpty) {
        setState(() {
          isLoading = false;
        });
        throw Exception("The aadhar number should be entered");
      }
      if (emailController.text == "") {
        setState(() {
          isLoading = false;
        });
        throw Exception("The email should be entered");
      }
      if (passwordController.text == "") {
        setState(() {
          isLoading = false;
        });
        throw Exception("The password should be entered");
      }
      if (isChecked == false) {
        setState(() {
          isLoading = false;
        });
        throw Exception("The terms and conditions should be accepted");
      }
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  VerificationPage(email: emailController.text)));
      await firestore
          .collection('materials')
          .doc(emailController.text)
          .collection('userinformation')
          .doc('userinfo')
          .set({
        'fullName': fullNameController.text,
        'email': emailController.text,
        'contactNumber': contactNumberController.text,
        'address': addressController.text,
        'city': locationInfo?['city'],
        'state': locationInfo?['state'],
        'country': locationInfo?['country'],
        'zipCode': zipCodeController.text,
        'gstNumber': companyRegistrationNumberController.text,
        'aadhaarNumber': aadhaarNumberController.text,
        'gender': selectedGender,
        'acceptedTerms': isChecked,
        'label': 'Material',
      });
      str = "The Account Was Created Successfully";
      str2 = "Account Created";
      _showDocumentIdPopup(str, str2);
    } on FirebaseAuthException catch (e) {
      str2 = "Error occured";
      str = "User not found";
      if (e.code == "email-already-in-use") {
        str = "The Email is Already in use";
        _showDocumentIdPopup2(str, str2);
      }
      if (e.code == 'weak-password') {
        str = "The Password is Too Weak";
        _showDocumentIdPopup2(str, str2);
      }
    } catch (e) {
      str2 = "Error occured";
      str = e.toString();
      str = str.replaceAll('Exception: ', '');
      _showDocumentIdPopup2(str, str2);
      await firestore
          .collection('machinery')
          .doc(emailController.text)
          .delete();
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
      backgroundColor: Color.fromARGB(255, 255, 249, 230),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                        "Materials Owner Sign Up",
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
                      child: SizedBox(
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
                      child: SizedBox(
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
                      child: SizedBox(
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
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.04,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: width * 0.8,
                            child: TextField(
                              controller: passwordController,
                              obscureText: !_passwordVisible,
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
                        padding: EdgeInsets.only(left: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          child: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      )
                    ],
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
                      child: SizedBox(
                        width: width * 0.8,
                        child: TextField(
                          controller: confirmPasswordController,
                          obscureText: !_passwordVisible,
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
                        "Address",
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
                          controller: addressController,
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
                      child: RichText(
                        text: TextSpan(
                            text: "Company Registration Number",
                            style: TextStyle(
                              fontSize: width * 0.039,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
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
                          controller: companyRegistrationNumberController,
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
                      child: RichText(
                        text: TextSpan(
                          text: "GST Number",
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
                          controller: aadhaarNumberController,
                          decoration: InputDecoration(
                            hintText: 'Enter your GST Number',
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
                    child: Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (bool? newValue) {
                            setState(() {
                              isChecked = newValue!;
                            });
                          },
                          activeColor: Colors.blue,
                          checkColor: Colors.white,
                        ),
                        Text(
                          'Accept Terms & Conditions',
                          style: TextStyle(
                            fontSize: width * 0.039,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            ' See more',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.normal,
                              fontSize: width * 0.033,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                        top: width * 0.024,
                        bottom: width * 0.05,
                      ),
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await _storeUserData();
                          setState(() {
                            isLoading = false;
                          });
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
