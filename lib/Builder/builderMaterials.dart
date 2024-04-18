// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restate/Builder/Searchpage.dart';
import 'package:restate/Builder/Searchresults.dart';

// ignore: must_be_immutable, camel_case_types
class Choose_Materials_Catagories extends StatelessWidget {
  final List<String> images;
  final List<String> names;
  String headerText;

  Choose_Materials_Catagories(
      {required this.images, required this.names, required this.headerText});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: width * 0.02, top: width * 0.02),
          child: Text(
            headerText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - kToolbarHeight,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 7.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // Handle tap on each item
                    CollectionReference reference = FirebaseFirestore.instance
                        .collection('materials_inventory');
                    Query query = reference
                        .where(
                          'Material_type',
                          isEqualTo: names[index],
                        )
                        .where('status', isEqualTo: "In Stock");

                    // Handle tap on each item
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Searchresults(
                          query: query,
                          type: "material",
                          searchkey: names[index],
                          index: 1,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 214, 214, 214),
                            borderRadius: BorderRadius.all(Radius.circular(90)),
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          child: AspectRatio(
                            aspectRatio: 8 / 8,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              child: Image.asset(
                                images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //SizedBox(height: 5), // Add some spacing between image and text
                      Text(
                        names[index],
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class BuilderMaterials extends StatefulWidget {
  const BuilderMaterials({Key? key});

  @override
  State<BuilderMaterials> createState() => _BuilderMaterialsState();
}

class _BuilderMaterialsState extends State<BuilderMaterials> {
  List<String> Materials_Catagories_Names = [
    'For you',
    'Aggregates',
    'Bricks',
    'Cement',
    'Concrete',
    'Electrical',
    'Plumbing',
    'Steels',
  ];

  List<String> Materials_Catagories_Images = [
    'assets/images/foryouMach/Foryou.jpg',
    'assets/images/Materials/catagires/Aggregates.jpg',
    'assets/images/Materials/catagires/Bricks_logo.jpg',
    'assets/images/Materials/catagires/Cement_logo.jpg',
    'assets/images/Materials/catagires/Concrete_Logo.jpg',
    'assets/images/Materials/catagires/Electrical_logo.jpg',
    'assets/images/Materials/catagires/Plumbing_Logo.jpg',
    'assets/images/Materials/catagires/Steels_logo.jpg',
  ];

  List<String> For_You_Materials_Names = [
    'Sand',
    'Red Bricks',
    'Ordinary Portland Cement (OPC)',
    'Ready-Mix Concrete',
    'Switches',
    'Steel Rebars',
    'PVC Pipes',
  ];

  List<String> For_You_Materials_Images = [
    'assets/images/Materials/for_you_mat/Sand.jpg',
    'assets/images/Materials/for_you_mat/Red Bricks.jpg',
    'assets/images/Materials/for_you_mat/Ordinary Portland Cement (OPC).jpg',
    'assets/images/Materials/for_you_mat/Ready-Mix Concrete.jpg',
    'assets/images/Materials/for_you_mat/Switches.png',
    'assets/images/Materials/for_you_mat/Steel Rebars.jpg',
    'assets/images/Materials/for_you_mat/PVC Pipes.jpg',
  ];

  List<String> Aggregates_Names = [
    'Sand',
    'Gravel',
    'Crushed Stone',
  ];

  List<String> Aggregates_Images = [
    'assets/images/Materials/Aggregates/Sand.JPG',
    'assets/images/Materials/Aggregates/Gravel.jpg',
    'assets/images/Materials/Aggregates/Crushed Stone.jpg'
  ];

  List<String> Bricks_Names = [
    'Red Bricks',
    'Concrete Bricks',
    'Light Weight Bricks',
    'Paving Bricks',
    'Fire Bricks',
    'Engineering Bricks',
  ];

  List<String> Bricks_Images = [
    'assets/images/Materials/Bricks/Red Bricks.jpg',
    'assets/images/Materials/Bricks/Concrete Bricks.jpg',
    'assets/images/Materials/Bricks/Light Weight Bricks.jpg',
    'assets/images/Materials/Bricks/Paving Bricks.jpg',
    'assets/images/Materials/Bricks/Fire Bricks.jpg',
    'assets/images/Materials/Bricks/Engineering Bricks.jpg',
  ];

  List<String> Cement_Names = [
    'Ordinary Portland Cement (OPC)',
    'Portland Pozzolona Cement(PPC)',
    'Rapid Hardening Cement',
    'Low Heat Cement',
    'White Cement',
  ];

  List<String> Cement_Images = [
    'assets/images/Materials/Cement/Ordinary Portland Cement (OPC).jpg',
    'assets/images/Materials/Cement/Portland Pozzolona Cement(PPC).jpg',
    'assets/images/Materials/Cement/Rapid Hardening Cement.jpg',
    'assets/images/Materials/Cement/Low Heat Cement.jpg',
    'assets/images/Materials/Cement/White Cement.jpg',
  ];

  List<String> Concrete_Names = [
    'Concrete',
    'Ready-Mix Concrete',
    'Reinforced Concrete',
    'Lightweight Concrete',
    'Quick-Setting Concrete',
    'Prestressed Concrete',
  ];

  List<String> Concrete_Images = [
    'assets/images/Materials/Concrete/Concrete.jpg',
    'assets/images/Materials/Concrete/Ready-Mix Concrete.jpg',
    'assets/images/Materials/Concrete/Reinforced Concrete.jpeg',
    'assets/images/Materials/Concrete/Lightweight Concrete.jpg',
    'assets/images/Materials/Concrete/Quick-Setting Concrete.jpg',
    'assets/images/Materials/Concrete/Prestressed Concrete.jpg',
  ];

  List<String> Electrical_Names = [
    'PVC Conduit Pipes',
    'Tube Lights',
    'Distributions Panels',
    'Subpanels',
    'Circuit Breakers',
    'Switches',
    'Switch Boards',
    'THHN Wires',
    'THWN Wires',
    'Fans',
  ];

  List<String> Electrical_Images = [
    'assets/images/Materials/Electrical/PVC Conduit Pipes.jpg',
    'assets/images/Materials/Electrical/Tube Lights.jpg',
    'assets/images/Materials/Electrical/Distributions Panels.jpg',
    'assets/images/Materials/Electrical/Subpanels.jpg',
    'assets/images/Materials/Electrical/Circuit Breakers.jpg',
    'assets/images/Materials/Electrical/Switch.jpg',
    'assets/images/Materials/Electrical/Switch Boards.jpg',
    'assets/images/Materials/Electrical/THHN Wires.jpg',
    'assets/images/Materials/Electrical/THWN Wires.jpg',
    'assets/images/Materials/Electrical/Fans.jpg',
  ];

  List<String> Plumbing_Names = [
    'PVC Pipes',
    'Water Tanks',
    'Pumps',
    'Toilet Basin',
    'Sinks',
    'Showers',
    'Faucets And Taps',
    'CPVC Pipes',
    'Plumbing PIpes',
    'Borewell Pipes',
    'PVC Elbows',
    'PVC Tees',
    'PVC Coupllings',
    'Valves',
    'Flanges',
  ];

  List<String> Plumbing_Images = [
    'assets/images/Materials/Plumbing/PVC Pipes.jpg',
    'assets/images/Materials/Plumbing/Water Tanks.jpg',
    'assets/images/Materials/Plumbing/Pumps.jpg',
    'assets/images/Materials/Plumbing/Toilet Basin.jpg',
    'assets/images/Materials/Plumbing/Sinks.jpg',
    'assets/images/Materials/Plumbing/Showers.jpg',
    'assets/images/Materials/Plumbing/Faucets And Taps.jpg',
    'assets/images/Materials/Plumbing/CPVC Pipes.jpg',
    'assets/images/Materials/Plumbing/Plumbing PIpes.png',
    'assets/images/Materials/Plumbing/Borewell Pipes.jpg',
    'assets/images/Materials/Plumbing/PVC Elbows.jpg',
    'assets/images/Materials/Plumbing/PVC Tees.jpg',
    'assets/images/Materials/Plumbing/PVC Coupllings.jpg',
    'assets/images/Materials/Plumbing/Valves.jpg',
    'assets/images/Materials/Plumbing/Flanges.png',
  ];

  List<String> Steels_Names = [
    'Steel Rebars',
    'Steel Frames',
    'Steel Mesh',
  ];

  List<String> Steels_Images = [
    'assets/images/Materials/Steels/Steel Rebars.jpg',
    'assets/images/Materials/Steels/Steel Frames.jpg',
    'assets/images/Materials/Steels/Steel Mesh.jpg',
  ];

  int choice = -1;

  Widget choose_Materials_Catagories(
      List<String> images, List<String> names, String headerText) {
    return Choose_Materials_Catagories(
      images: images,
      names: names,
      headerText: headerText,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: Colors.amber,
            width: width,
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: searchWidget(width, context),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: width * 0.02),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.02),
                    child: Container(
                        width: width * 0.20,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(55, 253, 198, 0),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Catagories',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: Materials_Catagories_Names.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            choice = index;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                              child: Image.asset(
                                                Materials_Catagories_Images[
                                                    index],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: width * 0.01,
                                              bottom: width * 0.02),
                                          child: Text(
                                            Materials_Catagories_Names[index],
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.black26,
                                        height: 1,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        )),
                  ),
                  Divider(
                    color: Colors.black12,
                    height: height * 0.75, // Adjust the height of the Divider
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Container(
                      width: width * 0.77,
                      height: height,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: choice != -1
                          ? choice == 0
                              ? choose_Materials_Catagories(
                                  For_You_Materials_Images,
                                  For_You_Materials_Names,
                                  Materials_Catagories_Names[choice])
                              : choice == 1
                                  ? choose_Materials_Catagories(
                                      Aggregates_Images,
                                      Aggregates_Names,
                                      Materials_Catagories_Names[choice])
                                  : choice == 2
                                      ? choose_Materials_Catagories(
                                          Bricks_Images,
                                          Bricks_Names,
                                          Materials_Catagories_Names[choice])
                                      : choice == 3
                                          ? choose_Materials_Catagories(
                                              Cement_Images,
                                              Cement_Names,
                                              Materials_Catagories_Names[
                                                  choice])
                                          : choice == 4
                                              ? choose_Materials_Catagories(
                                                  Concrete_Images,
                                                  Concrete_Names,
                                                  Materials_Catagories_Names[
                                                      choice])
                                              : choice == 5
                                                  ? choose_Materials_Catagories(
                                                      Electrical_Images,
                                                      Electrical_Names,
                                                      Materials_Catagories_Names[
                                                          choice])
                                                  : choice == 6
                                                      ? choose_Materials_Catagories(
                                                          Plumbing_Images,
                                                          Plumbing_Names,
                                                          Materials_Catagories_Names[
                                                              choice])
                                                      : choice == 7
                                                          ? choose_Materials_Catagories(
                                                              Steels_Images,
                                                              Steels_Names,
                                                              Materials_Catagories_Names[
                                                                  choice])
                                                          : Container()
                          : choose_Materials_Catagories(
                              For_You_Materials_Images,
                              For_You_Materials_Names,
                              'For You',
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector searchWidget(double width, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200),
            pageBuilder: (_, __, ___) => SearchPage(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Container(
        width: width * 0.92,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.search, color: Colors.grey),
            ),
            Text('Search', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
