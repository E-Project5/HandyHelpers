import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handy_helpers/services/database_conn.dart';
import 'package:handy_helpers/user_side/SearchResultsPage.dart';
import 'package:handy_helpers/user_side/allcatergories.dart';
import 'package:handy_helpers/user_side/detail.dart';
import 'package:handy_helpers/user_side/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Handy Helpers",
    home: Home_page(),
  ));
}

class Home_page extends StatefulWidget {
  const Home_page({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home_page> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    getload();
    super.initState();
  }

  double availableScreenWidth = 0;
  int selectedIndex = 0;
  final myitems = [
    Image.asset('assets/images/ad.png'),
    Image.asset('assets/images/clean.png'),
    Image.asset('assets/images/pat.png'),
  ];
  //----------categories
  Stream? categorystream;
  getload() async {
    categorystream = await databasemodel().getcategories();
    setState(() {});
  }

  String searchQuery = '';
  int myCurrentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color:  Color.fromRGBO(226, 233, 249, 1),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Text(
                  "What you are looking  for today",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
                ),
              ),
              // ---------------------------------search box
              Container(
                  height: 50,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    controller: _searchController,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResultsPage(),
                        ),
                      );
                    },
                    decoration: InputDecoration(
                        hintText: "Search...",
                        suffixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Color.fromARGB(123, 200, 201, 201),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        )),
                  )),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                  child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      height: 200,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayInterval: const Duration(seconds: 2),
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          myCurrentIndex = index;
                        });
                      },
                    ),
                    items: myitems,
                  ),
                  AnimatedSmoothIndicator(
                      activeIndex: myCurrentIndex,
                      count: myitems.length,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 10,
                        dotColor: Colors.grey.shade200,
                        activeDotColor: Colors.blue.shade900,
                        paintStyle: PaintingStyle.fill,
                      ))
                ],
              )),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "    Services",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    child: Text(
                      "See All    ",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Allcatergories()));
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    // Other widgets can go here, if any
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('S_Category')
                          .orderBy("Category", descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        var services = snapshot.data!.docs;
                        return Row(
                          children: services.map((service) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => select_services(
                                            key_id: service['Id'])));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 30),
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: service['Category'] == "Salon"
                                          ? Color.fromARGB(255, 255, 190, 228)
                                          : service['Category'] == "Plumber"
                                              ? Color.fromARGB(
                                                  255, 167, 171, 218)
                                              : service['Category'] ==
                                                      "Repairing"
                                                  ? Color.fromARGB(
                                                      255, 178, 212, 210)
                                                  : service['Category'] ==
                                                          "Cleaning"
                                                      ? Color.fromARGB(
                                                          255, 167, 202, 218)
                                                      : service['Category'] ==
                                                              "Electrician"
                                                          ? Color.fromARGB(255,
                                                              244, 190, 255)
                                                          : Color.fromARGB(255,
                                                              167, 202, 218),
                                    ),
                                    child: Image.network(
                                      service['C_image'],
                                      height: 40,
                                      color: service['Category'] == "Salon"
                                          ? Color.fromARGB(255, 228, 18, 133)
                                          : service['Category'] == "Plumber"
                                              ? Color.fromARGB(255, 24, 19, 95)
                                              : service['Category'] ==
                                                      "Repairing"
                                                  ? Color.fromARGB(
                                                      255, 9, 112, 86)
                                                  : service['Category'] ==
                                                          "Cleaning"
                                                      ? Color.fromARGB(
                                                          255, 5, 119, 172)
                                                      : service['Category'] ==
                                                              "Electrician"
                                                          ? Colors.purple
                                                          : Colors.purple,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  GestureDetector(
                                    child: Text(
                                      "      ${service['Category']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      // Define the action on tap
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),

              SizedBox(
                height: 20,
              ),
              Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('S_Category')
                      .limit(3)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                
                    var category = snapshot.data!.docs;
                    return Column(
                        children: category.map((cat) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("    ${cat['Category']}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                child: Text(
                                  "See All    ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500),
                                ),
                                onTap: () {  
                                     Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => select_services(
                                                  key_id: cat['Id'])));
                                },
                              )
                            ],
                          
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Services')
                                    .where('Service_cat',
                                        isEqualTo: cat['Id'])
                                    //.limit(3)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  var C_services = snapshot.data!.docs;
                                  return Row(
                                      children: C_services.map(
                                    (cleaning) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Detail(
                                                    service_id: cleaning['Id']),
                                              ));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          height: 200,
                                          width: 250,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: const Color.fromARGB(
                                                      0, 0, 0, 0)),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      "${cleaning['Service_img']}"),
                                                  fit: BoxFit.fill)),
                                        ),
                                      );
                                    },
                                  ).toList());
                                }),
                          ),
                        ],
                      );
                      
                    }).toList());
                  },
                ),
              ),
             SizedBox(
                height: 20,
              ),
              ],
          ),
        ),
      ),
    );
  }
}
