import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handy_helpers/user_side/cart.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';

class Detail extends StatefulWidget {
  final String? service_id;
  Detail({required this.service_id});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> with TickerProviderStateMixin {
  late TabController tabController;
  int tab = 1;
  late Future<DocumentSnapshot> categoryFuture;
  Future<DocumentSnapshot> getServiceData(String serviceId) {
    return FirebaseFirestore.instance
        .collection('Services')
        .doc(serviceId)
        .get();
  }

  Future<DocumentSnapshot> getcategory(String catID) async {
    return await FirebaseFirestore.instance
        .collection('S_Category')
        .doc(catID)
        .get();
  }

  String? checking;
  chek_login() async {
    SharedPreferences shared = await SharedPreferences.getInstance();

    setState(() {
      checking = shared.getString("login");
      print(checking);
    });
  }

  bool? check_Wishlish;

  wishlishcheck(String serviceID) async {
    DocumentReference wishlistItemRef = FirebaseFirestore.instance
        .collection('User')
        .doc(checking)
        .collection('wishlist')
        .doc(serviceID);

    DocumentSnapshot wishlistItemSnapshot = await wishlistItemRef.get();

    setState(() {
      if (wishlistItemSnapshot.exists) {
        check_Wishlish = true;
      } else {
        check_Wishlish = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    chek_login().then(
      (value) => wishlishcheck(widget.service_id!),
    );
    tabController = TabController(length: 2, vsync: this);
    categoryFuture = getServiceData(widget.service_id!)
        .then((serviceData) => getcategory(serviceData['Service_cat']));

    // Check if the service is in the wishlist
  }

  var checkcart;
  checkdata(S_id) async {
    QuerySnapshot existingProduct = await FirebaseFirestore.instance
        .collection('User')
        .doc(checking)
        .collection('cart')
        .where('serviceID', isEqualTo: S_id)
        .get();
    if (existingProduct.docs.isEmpty) {
      checkcart = null;
    } else {
      checkcart = "yes ";
    }
    setState(() {});
  }

  String? serviceName;
  String? serviceImg;
  String? categoryId;
  String? categoryName;
  String? price;

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: getServiceData(widget.service_id!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('Service not found'));
            }

            var serviceData = snapshot.data!.data() as Map<String, dynamic>;
            return FutureBuilder<DocumentSnapshot>(
                future: categoryFuture,
                builder: (context, categorySnapshot) {
                  if (categorySnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (categorySnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${categorySnapshot.error}'));
                  }
                  var categoryData =
                      categorySnapshot.data!.data() as Map<String, dynamic>;

                  return Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              // color: Colors.amber
                            ),
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color:
                                          Color.fromARGB(255, 183, 180, 180)),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Color.fromARGB(255, 183, 180, 180),
                                  ),
                                  child: Center(
                                      child: IconButton(
                                          onPressed: () {
                                            if (check_Wishlish == true) {
                                              // If the service is already in the wishlist, you can remove it or handle it as needed
                                              FirebaseFirestore.instance
                                                  .collection('User')
                                                  .doc(checking)
                                                  .collection('wishlist')
                                                  .doc(serviceData['Id'])
                                                  .delete();

                                              setState(() {
                                                check_Wishlish = false;
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Removed from wishlist')),
                                              );
                                            } else {
                                              // If the service is not in the wishlist, add it
                                              String id =
                                                  randomAlphaNumeric(10);
                                              Map<String, dynamic> wishlist = {
                                                'serviceId': serviceData['Id'],
                                                'servicename': serviceData[
                                                    'Service_title'],
                                                'serviceImg':
                                                    serviceData['Service_icon'],
                                                'categoryID':
                                                    categoryData['Category'],
                                                'categoryname':
                                                    categoryData['Category'],
                                                'price': serviceData[
                                                    'Service_price'],
                                              };
                                              FirebaseFirestore.instance
                                                  .collection('User')
                                                  .doc(checking)
                                                  .collection('wishlist')
                                                  .doc(serviceData['Id'])
                                                  .set(wishlist);

                                              setState(() {
                                                wishlishcheck(
                                                    serviceData['Id']);
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Added to wishlist')),
                                              );
                                            }
                                          },
                                          icon: Icon(
                                              check_Wishlish == true
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              size: 30))),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 100, 10, 0),
                            child: Container(
                              height: 300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                      bottom: Radius.circular(20)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        serviceData['Service_img'],
                                      ),
                                      fit: BoxFit.fill)),
                              // child: Image.asset("assets/images/window.png",fit: BoxFit.contain,),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 350, 20, 0),
                            child: Container(
                                padding: EdgeInsets.all(20),
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(50, 3, 3, 3),
                                      offset: const Offset(
                                        0,
                                        6.0,
                                      ),
                                      blurRadius: 6.0,
                                      spreadRadius: 6.0,
                                    ), //BoxShadow
                                    BoxShadow(
                                      color: Color.fromARGB(50, 3, 3, 3),
                                      offset: const Offset(0.0, -6),
                                      blurRadius: 6.0,
                                      spreadRadius: 6.0,
                                    ), //BoxShadow
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 80,
                                      // decoration: BoxDecoration(
                                      //   border: Border(bottom: BorderSide(color: Colors.black,width: 1,style:BorderStyle.solid
                                      //                             )
                                      //   )),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${categoryData['Category']} > ",
                                                  style:
                                                      TextStyle(fontSize: 15)),
                                              Text(
                                                serviceData['Service_title'] ??
                                                    'N/A',
                                                style: TextStyle(
                                                    color: Colors.indigo[900],
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                          DottedBorder(
                                              dashPattern: [8, 4],
                                              strokeWidth: 2,
                                              padding: EdgeInsets.all(10),
                                              borderType: BorderType.Circle,
                                              radius: Radius.circular(50),
                                              child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  child: Image.network(
                                                    categoryData['C_image'],
                                                    width: 20,
                                                    height: 20,
                                                  ))),
                                        ],
                                      ),
                                    ),
                                    DottedLine(
                                      direction: Axis.horizontal,
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          // alignment: Alignment.topLeft,
                                          width: 80,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  right: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Price"),
                                              Text(
                                                "PKR ${serviceData['Service_price'] ?? 'N/A'}",
                                                style: TextStyle(
                                                    color:
                                                        Colors.lightBlue[900]),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                            width: 100,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Duration"),
                                                Text(
                                                  " hour",
                                                  // ${serviceData['duration'] ?? 'N/A'}
                                                  style: TextStyle(
                                                      color: Colors
                                                          .lightBlue[900]),
                                                )
                                              ],
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 80,
                                          height: 50,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Rating"),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                  ),
                                                  Column(children: [
                                                    
                                                    // Text(
                                                    //   // ${serviceData['rating'] ?? 'N/A'}
                                                    //   // "",
                                                    //   style: TextStyle(
                                                    //       color: Colors
                                                    //           .lightBlue[900]),
                                                    // )
                                                  ]),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                        child: Center(
                          child: GFTabBar(
                            width: 200,
                            tabBarColor: Colors.lightBlue,
                            length: 2,
                            indicatorColor: Colors.indigo,
                            controller: tabController,
                            tabs: [
                              Tab(
                                // icon: Icon(Icons.directions_bike),
                                child: Text(
                                  "About",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                              Tab(
                                // icon: Icon(Icons.directions_bus),
                                child: Text(
                                  "Rating",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          height: 300,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(50, 3, 3, 3),
                                  offset: const Offset(
                                    0,
                                    6.0,
                                  ),
                                  blurRadius: 6.0,
                                  spreadRadius: 6.0,
                                ), //BoxShadow
                                BoxShadow(
                                  color: Color.fromARGB(50, 3, 3, 3),
                                  offset: const Offset(0.0, -6),
                                  blurRadius: 6.0,
                                  spreadRadius: 6.0,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: GFTabBarView(
                              controller: tabController,
                              children: <Widget>[
                                Container(
                                    child: Text(
                                        "${serviceData['description'] ?? 'N/A'},")),
                                Container(
                                  child: Text("Rating"),
                                ),
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.indigo[400],
                              borderRadius: BorderRadius.circular(20)),
                          child: TextButton(
                              onPressed: () async {
                                DocumentReference cartItemRef = FirebaseFirestore
                                    .instance
                                    .collection('User')
                                    .doc(
                                        checking) // Replace with the actual user ID variable
                                    .collection('cart')
                                    .doc(serviceData['Id']);
                                DocumentSnapshot cartItemSnapshot =
                                    await cartItemRef.get();
                                if (!cartItemSnapshot.exists) {
                                  serviceName = serviceData['Service_title'];
                                  serviceImg = serviceData['Service_icon'];
                                  categoryId = serviceData['Service_cat'];
                                  categoryName = categoryData['Category'];
                                  price = serviceData['Service_price'];
                                  addToCart(context, serviceData['Id']);
                                  setState(() {});
                                } else {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.info,
                                    borderSide: const BorderSide(
                                      color: Colors.green,
                                      // width: 2,
                                    ),
                                    // width: 280,
                                    buttonsBorderRadius: const BorderRadius.all(
                                      Radius.circular(2),
                                    ),
                                    dismissOnTouchOutside: false,
                                    dismissOnBackKeyPress: false,
                                    headerAnimationLoop: false,
                                    animType: AnimType.bottomSlide,
                                    title: 'Add to cart',
                                    desc:
                                        'The service is already added in your cart',
                                    showCloseIcon: true,
                                    btnOkText: "Check cart",
                                    btnOkOnPress: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Cart(),
                                          ));
                                    },
                                    // ok: () {},
                                  ).show();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Book Now ",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.white,
                                  )
                                ],
                              )),
                        ),
                      )
                    ],
                  );
                });
          },
        ),
      ),
    );
  }

  Future addToCart(BuildContext context, String service_id) async {
    int? count = 1;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.transparent,
          // title:
          content: StatefulBuilder(
            builder: (context, setState) {
              return Stack(
                alignment:
                    Alignment.topCenter, // Align the image to the top center
                clipBehavior: Clip.none,

                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top:
                            50), // Adjust the margin to make space for the image
                    padding: EdgeInsets.only(left: 30, right: 30, top: 60),
                    width: MediaQuery.of(context)
                        .size
                        .width, // Make the width responsive
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 5, 20, 0),
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.indigo, width: 5))),
                          child: Text(
                            "Select Quantity",
                            // widget.category!,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          serviceName!,
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                            width: double.infinity,
                            // color: Colors.amber,
                            child: Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                if (count! >= 2) {
                                                  count = count! - 1;
                                                }
                                              });
                                            },
                                            icon: Icon(Icons.remove))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      count.toString(),
                                      // "1",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                count = count! + 1;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.add,
                                            )))
                                  ]),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Map<String, dynamic> service_data = {
                                      'serviceId': service_id,
                                      'servicename': serviceName,
                                      'serviceImg': serviceImg,
                                      'categoryID': categoryId,
                                      'categoryname': categoryName,
                                      'price': price,
                                      'quantity': count,
                                    };
                                    FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(checking)
                                        .collection('cart')
                                        .doc(service_id)
                                        .set(service_data);
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Cart(),
                                        ));
                                  },
                                  child: Text(
                                    "Add to Cart",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Image.network(
                      serviceImg!,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        Navigator.of(context).pop(); // Closes the dialog
                      },
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }
}
