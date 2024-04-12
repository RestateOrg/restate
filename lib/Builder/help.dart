import 'package:flutter/material.dart';

class HelpSection extends StatefulWidget {
  @override
  _HelpSectionState createState() => _HelpSectionState();
}

class _HelpSectionState extends State<HelpSection> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Help'),
          backgroundColor: Colors.amber,
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 15.0),
                child: Text(
                  "What issue are you facing?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(),
            DropdownMenu(
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                label: Text("How to upload projects?"),
                width: width * 0.95,
                dropdownMenuEntries: <DropdownMenuEntry>[
                  DropdownMenuEntry(
                      value: 1,
                      label:
                          "By clicking on the the +new button in the home screen you will be redirected to upload project form fill the details and upload the projects."),
                ]),
            Divider(),
            DropdownMenu(
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                label: Text("How to book machinery?"),
                width: width * 0.95,
                dropdownMenuEntries: <DropdownMenuEntry>[
                  DropdownMenuEntry(
                      value: 1,
                      label:
                          "By clicking on the machinery icon in the navigation bar in the home screen you will be shown categories of machinery available in our application. you can select your desired machinery and rent it."),
                ]),
            Divider(),
            DropdownMenu(
                label: Text("How to buy materials?"),
                width: width * 0.95,
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                dropdownMenuEntries: const <DropdownMenuEntry>[
                  DropdownMenuEntry(
                      value: 1,
                      label:
                          "by clicking on the box icon in the navigation bar in the home screen you will be shown categories of materials available in our application. you can select your desired materials and buy it."),
                ]),
            Divider(),
            DropdownMenu(
                label: Text("What if I miss my Restate order pickup ?"),
                width: width * 0.95,
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                dropdownMenuEntries: const <DropdownMenuEntry>[
                  DropdownMenuEntry(
                      value: 1,
                      label:
                          "Do not worry, the delivery agent will try to pick up again on the next working day."),
                ]),
            Divider(),
            DropdownMenu(
                label: Text("I want to contact the seller?"),
                width: width * 0.95,
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                dropdownMenuEntries: const <DropdownMenuEntry>[
                  DropdownMenuEntry(
                      value: 1,
                      label:
                          "Restatebuild.com is a marketplace on which third-party sellers sell products to customers.To contact a seller, please send a letter with the below address on the envelope and include product page URL so it can be forwarded to the seller."),
                ]),
            Divider(),
          ],
        ));
  }
}
