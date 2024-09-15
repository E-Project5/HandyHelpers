// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handy_helpers/start/screens/mainscreen.dart';
// import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Page View",
    home: boarding(),
  ));
}

class boarding extends StatefulWidget {
  const boarding({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<boarding> {
  PageController pageController = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Image.asset(
          'images/bg.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Color.fromARGB(134, 18, 40, 163),
        ),
        
        //--dot ind
        //icator
        Container(
          padding: EdgeInsets.symmetric(horizontal: 150,vertical: 20),
          width: double.infinity,
          child: SmoothPageIndicator(
            controller: pageController,
            count: 3,
            effect: WormEffect(
              dotColor: Colors.white,
              activeDotColor: Colors.lightBlue,
            ),
            onDotClicked: (index) {
              pageController.jumpToPage(index);
            },
          ),
        ),
        PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: [
            Center(
                child: Container(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Column(
                  children: [
                    Image.asset("images/pg.png"),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "CLEANING SERVICES",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          shadows: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Color.fromARGB(255, 100, 100, 100),
                                offset: Offset(2, 2))
                          ]),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Center(
                        child: Text(
                          "We take pride in the services of our work. Our services assure guarantee includes a satisfaction guarantee.If you’r not satisfied with our service, please let us know, and we’ll make it right. ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 16.5),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),

            //---
            Center(
                child: Container(
              padding: const EdgeInsets.only(top: 160),
              child: Center(
                child: Column(
                  children: [
                    Image.asset("images/pg4.png"),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Professional Staff",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          shadows: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Color.fromARGB(255, 100, 100, 100),
                                offset: Offset(2, 2))
                          ]),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text(
                        "Our team is dedicated to delivering exceptional results with attention to detail and professionalism.",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            )),

            //---
                 
            Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 90),
                  child: Center(
                   child: Column(
                  children: [
                    Image.asset("images/pg2.png"),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Quality Of Work",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          shadows: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Color.fromARGB(255, 100, 100, 100),
                                offset: Offset(2, 2))
                          ]),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text(
                        "We ensure quality through work. Our team is committed to maintaining high standards in every project.",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                    )
                  ],
                 ),
              ),
              )
            ),
          ],
        ),
        Container(
            alignment: const Alignment(0, 0.75),
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //---skip button
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          pageController.jumpToPage(1);
                        },
                        child: const Text(
                          "BACK",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ))
                    : GestureDetector(
                        onTap: () {
                          pageController.jumpToPage(2);
                        },
                        child: const Text(
                          "SKIP",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        )),


                //---next button
// SizedBox(width: 50,),
                //--done
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          // pageController.nextPage(
                          //     duration: const Duration(milliseconds: 500),
                          //     curve: Curves.easeIn);
                          //---MOVE TO WELCOME PAGE
                          // Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (e) => const WelcomeScreen(),
                          //           ),
                          //         );
                        },
                        // child: const Text("DONE")
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Mainscreen(page: "signup",),
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white
                                .withOpacity(0.6), // Background color
                            shape:
                                const CircleBorder(), // Make the button round
                            padding: const EdgeInsets.all(
                                35), // Padding inside the button
                          ),
                          child: const Icon(
                            Icons.done,color: Colors.black,
                            size: 24,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: const Text(
                          "NEXT",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        )),
              ],
            )),
      ]),
    );
  }
}
