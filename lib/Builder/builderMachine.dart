import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restate/Builder/showMachCatogory.dart';

class BuilderMachine extends StatefulWidget {
  const BuilderMachine({Key? key}) : super(key: key);

  @override
  State<BuilderMachine> createState() => _BuilderMachineState();
}

class _BuilderMachineState extends State<BuilderMachine> {
  List<String> machCatogoriesNames = [
    'excavators',
    'bulldozers',
    'concrete mixers',
    'cranes',
    'backhoe loader',
    'tractors',
  ];

  List<String> machCatogiesImages = [
    'assets/images/excavators.png',
    'assets/images/bulldozers.png',
    'assets/images/concriteMixers.png',
    'assets/images/cranes.png',
    'assets/images/BackHoleLoder.png',
    'assets/images/tractors.png',
  ];

  int tappedIndex = -1;

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
              padding: EdgeInsets.only(left: width * 0.02, top: width * 0.02),
              child: Text(
                'catagrioes',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - kToolbarHeight,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 8.0,
                ),
                padding: EdgeInsets.all(8.0),
                itemCount: machCatogiesImages.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        tappedIndex = index;
                      });

                      // Delay the appearance of the transparent container by 1 second
                      Future.delayed(Duration(milliseconds: 1000), () {
                        setState(() {
                          tappedIndex = -1;

                          // Navigate to another screen after the delay
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowMachCatogory(
                                categoryName: machCatogoriesNames[index],
                              ),
                            ),
                          );
                        });
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(machCatogiesImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (tappedIndex == index)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                              child: Center(
                                child: Text(
                                  machCatogoriesNames[index],
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
