import 'package:flutter/material.dart';
import 'package:restate/screens/hexcolor.dart';

class BuilderRegistration extends StatefulWidget {
  const BuilderRegistration({Key? key}) : super(key: key);

  @override
  State<BuilderRegistration> createState() => _BuilderRegistrationState();
}

class _BuilderRegistrationState extends State<BuilderRegistration> {
  bool isChecked = false;
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
                    decoration: InputDecoration(
                      hintText: 'Enter Your Full Name',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
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
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email Id',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
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
                    decoration: InputDecoration(
                      hintText: 'Enter Your Mobile Number',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
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
                    decoration: InputDecoration(
                      hintText: 'Enter Your Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
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
                    decoration: InputDecoration(
                      hintText: 'Confirm Your Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
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
                    decoration: InputDecoration(
                      hintText: 'Enter Your Address',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
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
                child: Container(
                  width: width * 0.8,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Your Address',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
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
                child: Container(
                  width: width * 0.8,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Your Zip Code',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
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
                child: Container(
                  width: width * 0.8,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your Company Name',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
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
                child: Container(
                  width: width * 0.8,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your License Number',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
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
              child: GenderDropdown(),
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
                  onPressed: () {},
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

class GenderDropdown extends StatefulWidget {
  @override
  _GenderDropdownState createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  String selectedGender = 'Male'; // Default value

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
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
        Align(
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
      ],
    );
  }
}
