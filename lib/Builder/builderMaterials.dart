// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restate/Builder/showBuilderMaterial.dart';

class BuilderMaterials extends StatefulWidget {
  const BuilderMaterials({Key? key});

  @override
  State<BuilderMaterials> createState() => _BuilderMaterialsState();
}

class _BuilderMaterialsState extends State<BuilderMaterials> {
  List<String> metalImages = [
    'assets/images/me1.png',
    'assets/images/m2.png',
    'assets/images/m3.png',
  ];

  List<String> aggregatesImages = [
    'assets/images/agg1.png',
    'assets/images/agg2.png',
    'assets/images/agg3.png',
    'assets/images/agg4.png',
    'assets/images/agg5.png',
  ];

  List<String> MasonryImages = [
    'assets/images/man1.png',
    'assets/images/man2.png',
    'assets/images/man3.png',
    'assets/images/man4.png',
  ];

  List<String> plumbingFixturesImages = [
    'assets/images/pf1.png',
    'assets/images/pf2.png',
    'assets/images/pf3.png',
  ];

  List<String> metalNames = [
    'steel rebars',
    'steel frames',
    'wire mesh',
  ];

  List<String> aggregatesNames = [
    'sand',
    'gravel',
    'crushed stones',
    'cement',
    'concrete',
  ];

  List<String> masonryNames = [
    'bricks',
    'concrete blocks',
    'cinder blocks',
    'terracotta',
  ];

  List<String> plumbingFixturesNames = [
    'pvc pipes',
    'valves',
    'fixtures',
  ];

  int mtappedIndex = -1;
  int aggTappedINdex = -1;
  int MasonryTappedIndex = -1;
  int plumbingFixturesIndex = -1;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: width * 0.03),
              child: Row(
                children: [
                  Text(
                    'Metals',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.02),
                    child: FaIcon(
                      FontAwesomeIcons.arrowRightLong,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: width * 0.02),
              child: SizedBox(
                height: width * 0.35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: metalImages.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // Set the tappedIndex when tapped
                        setState(() {
                          mtappedIndex = index;
                        });

                        // Delay the appearance of the transparent container by 1 second
                        Future.delayed(Duration(milliseconds: 1000), () {
                          // Reset tappedIndex after the delay
                          setState(() {
                            mtappedIndex = -1;
                          });

                          // Navigate to another screen after the delay
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BuilderMaterialsDetails(
                                matCatogary: metalNames[index],
                              ),
                            ),
                          );
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: width * 0.03),
                        child: Stack(
                          children: [
                            Container(
                              width: width * 0.4,
                              height: width * 0.35,
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Image.asset(
                                  metalImages[index],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            if (mtappedIndex == index)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      metalNames[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: width * 0.03),
              child: Row(
                children: [
                  Text(
                    'Aggregates',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.02),
                    child: FaIcon(
                      FontAwesomeIcons.arrowRightLong,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: width * 0.02),
              child: SizedBox(
                height: width * 0.35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: aggregatesImages.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          aggTappedINdex = index;
                        });

                        // Delay the appearance of the transparent container by 1 second
                        Future.delayed(Duration(milliseconds: 1000), () {
                          setState(() {
                            aggTappedINdex = -1;
                          });

                          // Navigate to another screen after the delay
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BuilderMaterialsDetails(
                                matCatogary: aggregatesNames[index],
                              ),
                            ),
                          );
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: width * 0.03),
                        child: Stack(
                          children: [
                            Container(
                              width: width * 0.4,
                              height: width * 0.35,
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Image.asset(
                                  aggregatesImages[index],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            if (aggTappedINdex == index)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      aggregatesNames[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: width * 0.03),
              child: Row(
                children: [
                  Text(
                    'Masonry',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.02),
                    child: FaIcon(
                      FontAwesomeIcons.arrowRightLong,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: width * 0.02),
              child: SizedBox(
                height: width * 0.35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: MasonryImages.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          MasonryTappedIndex = index;
                        });

                        // Delay the appearance of the transparent container by 1 second
                        Future.delayed(Duration(milliseconds: 1000), () {
                          setState(() {
                            aggTappedINdex = -1;
                          });

                          // Navigate to another screen after the delay
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BuilderMaterialsDetails(
                                matCatogary: masonryNames[index],
                              ),
                            ),
                          );
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: width * 0.03),
                        child: Stack(
                          children: [
                            Container(
                              width: width * 0.4,
                              height: width * 0.35,
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Image.asset(
                                  MasonryImages[index],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            if (MasonryTappedIndex == index)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      masonryNames[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: width * 0.03),
              child: Row(
                children: [
                  Text(
                    'Plumbing Fixtures',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.02),
                    child: FaIcon(
                      FontAwesomeIcons.arrowRightLong,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: width * 0.02),
              child: SizedBox(
                height: width * 0.35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: plumbingFixturesImages.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          plumbingFixturesIndex = index;
                        });

                        // Delay the appearance of the transparent container by 1 second
                        Future.delayed(Duration(milliseconds: 1000), () {
                          setState(() {
                            plumbingFixturesIndex = -1;
                          });

                          // Navigate to another screen after the delay
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BuilderMaterialsDetails(
                                matCatogary: plumbingFixturesNames[index],
                              ),
                            ),
                          );
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: width * 0.03),
                        child: Stack(
                          children: [
                            Container(
                              width: width * 0.4,
                              height: width * 0.35,
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Image.asset(
                                  plumbingFixturesImages[index],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            if (plumbingFixturesIndex == index)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      plumbingFixturesNames[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
