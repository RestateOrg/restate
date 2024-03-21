// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restate/Builder/Searchresults.dart';

class ChooseMachCat extends StatefulWidget {
  final List<String> images;
  final List<String> names;
  final String headerText;

  ChooseMachCat({
    required this.images,
    required this.names,
    required this.headerText,
  });

  @override
  _ChooseMachCatState createState() => _ChooseMachCatState();
}

class _ChooseMachCatState extends State<ChooseMachCat> {
  final User? _user = FirebaseAuth.instance.currentUser;
  String city = '';

  @override
  void initState() {
    setState(() {
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: width * 0.02, top: width * 0.02),
          child: Text(
            widget.headerText,
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
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 30.0,
                mainAxisExtent: 100,
              ),
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    CollectionReference reference = FirebaseFirestore.instance
                        .collection('machinery inventory');
                    Query query = reference
                        .where(
                          'machinery_type',
                          isEqualTo: widget.names[index],
                        )
                        .where('status', isEqualTo: "Available");

                    // Handle tap on each item
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Searchresults(
                          query: query,
                          type: "machinery",
                          searchkey: widget.names[index],
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
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(90)),
                            border: Border.all(
                              color: Colors.amber,
                              width: 2.0,
                            ),
                          ),
                          child: AspectRatio(
                            aspectRatio: 5 / 5,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(90)),
                              child: Image.asset(
                                widget.images[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                      //SizedBox(height: 5), // Add some spacing between image and text
                      Text(
                        widget.names[index],
                        textAlign: TextAlign.center,
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

class BuilderMachine extends StatefulWidget {
  const BuilderMachine({Key? key}) : super(key: key);

  @override
  State<BuilderMachine> createState() => _BuilderMachineState();
}

class _BuilderMachineState extends State<BuilderMachine> {
  List<String> machCategoriesNames = [
    'For you',
    'Construction and Finishing',
    'Construction site services',
    'Cranes',
    'Drilling Machinery',
    'Earth moving equipment',
    'Lifting Machinery',
    'Road Equipment',
  ];

  List<String> machCategoriesImages = [
    'assets/images/foryouMach/Foryou.jpg',
    'assets/images/machinery/truckConMIx.png',
    'assets/images/machinery/Construction_site_services_logo.jpg',
    'assets/images/machinery/Crane.jpg',
    'assets/images/machinery/drill.jpg',
    'assets/images/machinery/backhoeLoager.jpg',
    'assets/images/machinery/Lifters.jpg',
    'assets/images/machinery/road.jpg',
  ];

  List<String> forYouMachNames = [
    'Direct Rotary Rigs',
    'Wick Drain Machine',
    'Rough Terrain Forklift',
    'Nail guns',
    'Rough terrain Crane',
    'Single Drum Roller',
    'Tractor',
  ];

  List<String> foryouMachImages = [
    'assets/images/foryouMach/direct rotary rigs.jpg',
    'assets/images/foryouMach/drain.jpg',
    'assets/images/foryouMach/forklift.png',
    'assets/images/foryouMach/nailDrill.jpg',
    'assets/images/foryouMach/roughTCraine.jpg',
    'assets/images/foryouMach/singleDrumRoller.jpg',
    'assets/images/foryouMach/tractor.jpg',
  ];

  List<String> Construction_and_FinishingNames = [
    'Concrete Mixer',
    'Concrete pump',
    'Concrete Vibrator',
    'Mortar Mixer',
    'Nail guns',
    'Ride On Trowels',
    'Shotcrete',
  ];

  List<String> Construction_and_FinishingImages = [
    'assets/images/machinery/ConstructionandFinishing/concreteMixer.jpg',
    'assets/images/machinery/ConstructionandFinishing/concrete-pump.jpg',
    'assets/images/machinery/ConstructionandFinishing/ConcreteVibrator.jpg',
    'assets/images/machinery/ConstructionandFinishing/MortarMixer.jpg',
    'assets/images/machinery/ConstructionandFinishing/Nailguns.jpg',
    'assets/images/machinery/ConstructionandFinishing/RideOnTrowels.jpg',
    'assets/images/machinery/ConstructionandFinishing/Shotcrete.png',
  ];

  List<String> Construction_site_services_Names = [
    'Diesel Generator',
    'Storage container',
    'Light tower',
    'Air Compressor',
    'Grout Plants',
    'Hydralic Pump',
    'Wick Drain Machine',
    'Spot Cooler',
  ];
  List<String> Construction_site_services_Images = [
    'assets/images/machinery/Construction_site_services/Diesel Generator.jpg',
    'assets/images/machinery/Construction_site_services/Storage container.jpg',
    'assets/images/machinery/Construction_site_services/Light tower.jpg',
    'assets/images/machinery/Construction_site_services/Air Compressor.jpg',
    'assets/images/machinery/Construction_site_services/Grout Plants.jpg',
    'assets/images/machinery/Construction_site_services/Hydralic_Pump.png',
    'assets/images/machinery/Construction_site_services/Wick Drain Machine.png',
    'assets/images/machinery/Construction_site_services/Spot Cooler.png',
  ];

  List<String> Cranes_Names = [
    'Mobile Crane',
    'Tower Crane',
    'Rough terrain Crane',
    'Pipe layer',
    'All Terrain Crane',
    'Launching Gantry',
    'Crawler Crane'
  ];

  List<String> Cranes_Images = [
    'assets/images/machinery/Cranes/Mobile Crane.jpg',
    'assets/images/machinery/Cranes/Tower Crane.jpg',
    'assets/images/machinery/Cranes/Rough terrain Crane.jpg',
    'assets/images/machinery/Cranes/Pipe layer.jpg',
    'assets/images/machinery/Cranes/All Terrain Crane.jpg',
    'assets/images/machinery/Cranes/Launching Gantry.jpg',
    'assets/images/machinery/Cranes/Crawler Crane.jpg',
  ];
  List<String> Drilling_Machinery_Names = [
    'Auger Drill',
    'Pile drill rig',
    'Cable Tool Rigs',
    'Direct Rotary rigs',
    'Rotary Drill',
    'Down The Hole Hammer',
    'Pile Driver',
    'Soil Nail Rig',
  ];

  List<String> Drilling_Machinery_Images = [
    'assets/images/machinery/Drilling_Machinery/Auger Drill.jpg',
    'assets/images/machinery/Drilling_Machinery/Pile drill rig.jpg',
    'assets/images/machinery/Drilling_Machinery/Cable Tool Rigs.jpg',
    'assets/images/machinery/Drilling_Machinery/Direct Rotary rigs.png',
    'assets/images/machinery/Drilling_Machinery/Rotary Drill.jpg',
    'assets/images/machinery/Drilling_Machinery/Down The Hole Hammer.jpg',
    'assets/images/machinery/Drilling_Machinery/Pile Driver.jpg',
    'assets/images/machinery/Drilling_Machinery/Soil Nail Rig.jpg',
  ];

  List<String> Earth_moving_equipment_Names = [
    'Backhoe Loader',
    'Articulated Dump Truck',
    'Tractor',
    'Scraper',
    'Bulldozer',
    'Excavator',
    'Mini Excavator',
    'Skid Steer Loader',
    'Skip Loader',
    'Trencher',
    'Wheel Loader',
    'Dump Truck',
  ];

  List<String> Earth_moving_equipment_Images = [
    'assets/images/machinery/Earth_moving_equipment/Backhoe Loader.jpg',
    'assets/images/machinery/Earth_moving_equipment/Articulated Dump Truck.jpg',
    'assets/images/machinery/Earth_moving_equipment/Tractor.png',
    'assets/images/machinery/Earth_moving_equipment/Scraper.jpg',
    'assets/images/machinery/Earth_moving_equipment/Bulldozer.jpg',
    'assets/images/machinery/Earth_moving_equipment/Excavator.jpg',
    'assets/images/machinery/Earth_moving_equipment/Mini Excavator.jpg',
    'assets/images/machinery/Earth_moving_equipment/Skid Steer Loader.jpg',
    'assets/images/machinery/Earth_moving_equipment/Skip Loader.jpg',
    'assets/images/machinery/Earth_moving_equipment/Trencher.jpg',
    'assets/images/machinery/Earth_moving_equipment/Wheel Loader.jpg',
    'assets/images/machinery/Earth_moving_equipment/Dump Truck.jpg',
  ];

  List<String> Lifting_Machinery_Names = [
    'Electric Scissor Lift',
    'Drivable Single Man Lift',
    'Push around Single Man Lift',
    'Rough Terrain Scissor Lift',
    'Articulating Boom Lift',
    'Telescopic Boom Lift',
    'Warehouse Forkift',
    'Heavy Duty Forklift',
    'Rough Terrain Forklift',
    'Telehandler Forklift',
    'Extendable Counterweight Forklift',
  ];

  List<String> Lifting_Machinery_Images = [
    'assets/images/machinery/Lifting_Machinery/Electric Scissor Lift.jpg',
    'assets/images/machinery/Lifting_Machinery/Drivable Single Man Lift.jpg',
    'assets/images/machinery/Lifting_Machinery/Push around Single Man Lift.jpg',
    'assets/images/machinery/Lifting_Machinery/Rough Terrain Scissor Lift.jpg',
    'assets/images/machinery/Lifting_Machinery/Articulating Boom Lift.jpg',
    'assets/images/machinery/Lifting_Machinery/Telescopic Boom Lift.jpg',
    'assets/images/machinery/Lifting_Machinery/Warehouse Forkift.jpg',
    'assets/images/machinery/Lifting_Machinery/Heavy Duty Forklift.jpg',
    'assets/images/machinery/Lifting_Machinery/Rough Terrain Forklift.png',
    'assets/images/machinery/Lifting_Machinery/Telehandler Forklift.jpg',
    'assets/images/machinery/Lifting_Machinery/Extendable Counterweight Forklift.jpg',
  ];

  List<String> Road_Equipment_Names = [
    'Motor Graders',
    'Vibrating Rollers',
    'Double Drum Rollers',
    'Single Drum Rollers',
    'Planer',
    'Slip Former',
    'Asphalt mill',
    'Paving train',
  ];

  List<String> Road_Equipment_Images = [
    'assets/images/machinery/Road_Equipment/Motor Graders.jpg',
    'assets/images/machinery/Road_Equipment/Vibrating Rollers.jpg',
    'assets/images/machinery/Road_Equipment/Double Drum Rollers.jpg',
    'assets/images/machinery/Road_Equipment/Single Drum Rollers.jpg',
    'assets/images/machinery/Road_Equipment/Planer.jpg',
    'assets/images/machinery/Road_Equipment/Slip Former.jpg',
    'assets/images/machinery/Road_Equipment/Asphalt mill.jpg',
    'assets/images/machinery/Road_Equipment/Paving train.jpg'
  ];

  int tappedIndex = -1;
  int choice = -1;

  Widget chooseMachCat(
      List<String> images, List<String> names, String headerText) {
    return ChooseMachCat(
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
      backgroundColor: Colors.amber,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: width * 0.047, top: width * 0.02),
            child: Container(
              width: width * 0.92,
              child: CupertinoSearchTextField(
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(30),
                padding: EdgeInsets.all(10),
              ),
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
                          color: const Color.fromARGB(255, 224, 169, 2),
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
                                itemCount: machCategoriesNames.length,
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
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(70)),
                                                border: Border.all(
                                                  color: Colors.amber,
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(70)),
                                                child: Image.asset(
                                                  machCategoriesImages[index],
                                                ),
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
                                              right: width * 0.01,
                                              top: width * 0.01,
                                              bottom: width * 0.02),
                                          child: Text(
                                            machCategoriesNames[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color:
                                            const Color.fromARGB(21, 0, 0, 0),
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
                    // Adjust the height of the Divider
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Container(
                      width: width * 0.77,
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: choice != -1
                          ? choice == 0
                              ? chooseMachCat(foryouMachImages, forYouMachNames,
                                  machCategoriesNames[choice])
                              : choice == 1
                                  ? chooseMachCat(
                                      Construction_and_FinishingImages,
                                      Construction_and_FinishingNames,
                                      machCategoriesNames[choice])
                                  : choice == 2
                                      ? chooseMachCat(
                                          Construction_site_services_Images,
                                          Construction_site_services_Names,
                                          machCategoriesNames[choice])
                                      : choice == 3
                                          ? chooseMachCat(
                                              Cranes_Images,
                                              Cranes_Names,
                                              machCategoriesNames[choice])
                                          : choice == 4
                                              ? chooseMachCat(
                                                  Drilling_Machinery_Images,
                                                  Drilling_Machinery_Names,
                                                  machCategoriesNames[choice])
                                              : choice == 5
                                                  ? chooseMachCat(
                                                      Earth_moving_equipment_Images,
                                                      Earth_moving_equipment_Names,
                                                      machCategoriesNames[
                                                          choice])
                                                  : choice == 6
                                                      ? chooseMachCat(
                                                          Lifting_Machinery_Images,
                                                          Lifting_Machinery_Names,
                                                          machCategoriesNames[
                                                              choice])
                                                      : choice == 7
                                                          ? chooseMachCat(
                                                              Road_Equipment_Images,
                                                              Road_Equipment_Names,
                                                              machCategoriesNames[
                                                                  choice])
                                                          : Container()
                          : chooseMachCat(
                              foryouMachImages,
                              forYouMachNames,
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
}

void main() {
  runApp(MaterialApp(
    home: BuilderMachine(),
  ));
}
