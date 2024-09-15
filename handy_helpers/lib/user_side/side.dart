import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handy_helpers/start/screens/mainscreen.dart';
import 'package:handy_helpers/user_side/about.dart';
import 'package:handy_helpers/user_side/aggrement.dart';
import 'package:handy_helpers/user_side/wishlist.dart';
import 'package:handy_helpers/user_side/my_bookings.dart';
import 'package:handy_helpers/user_side/cart.dart';
import 'package:handy_helpers/user_side/faq.dart';
import 'package:handy_helpers/user_side/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:handy_helpers/user_side/contact.dart';
import 'package:slide_rating_dialog/slide_rating_dialog.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Side(),
  ));
}

class Side extends StatefulWidget {
  String? userId;
  int? page_index;
  Side({this.userId, this.page_index});

  @override
  _SideState createState() => _SideState();
}

class _SideState extends State<Side> {
  TextEditingController editable = TextEditingController();
  var page_list = [Home_page(), MyBookings(), Wishlist(), ContactUsForm()];

  int currentIndex = 0;
  String? checking;
  chek_login() async {
    SharedPreferences shared = await SharedPreferences.getInstance();

    setState(() {
      checking = shared.getString("login");
      print(checking);
    });
  }

  String? userName;
  String? userEmail;
  String? userStatus;
  String? userImg;
  String? userAddress;
  Position? address;
  String? userPhone;
  String? userLOGO;
  String? u;
  var aggrement;
  getuserData() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    checking = shared.getString("login");
    if (widget.userId != null) {
      u = widget.userId;
    } else {
      u = checking;
    }
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('User').doc(u).get();
    setState(() {
      // u = widget.userId ;
      userName = userDoc.get('Fullname');
      userEmail = userDoc.get('email');
      userStatus = userDoc.get('status');
      userPhone = userDoc.get('contact');
      userLOGO = userDoc.get('Fullname').toUpperCase().substring(0, 1);
      aggrement = userDoc.get('aggrement');
    });
    // Extract user data from the document
  }

  List<String> list = [
    'Worst',
    'Not Good',
    'Good',
    'Excellent',
    'Out Standing',
    'Out Standing',
  ];
  String selected_value = "Excellent";
  void checkFeedbackStatus(String? userId) async {
    // Reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query the orders collection where feedback_status is 'pending'
    QuerySnapshot querySnapshot = await firestore
        .collection('Orders')
        .where('userId', isEqualTo: checking)
        .where('status', isEqualTo: "Completed")
        .where('rating_status', isEqualTo: 'Pending')
        .get();

    // Check if there are any pending feedbacks
    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        String orderId = doc.id;
        QuerySnapshot details = await firestore
            .collection('Orders')
            .doc(orderId)
            .collection("OrderDetails")
            .get();

        print('Order ID: $orderId has pending feedback.');
        // You can show the feedback dialog here
        if (details.docs.isNotEmpty) {
          for (QueryDocumentSnapshot element in details.docs) {
            print(' services : ${element['serviceId']}');
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext cont) => SlideRatingDialog(
                      title: "Feedback",
                      subTitle: "How was the ${element['service']} Service",
                      onRatingChanged: (rating) {
                        // if (rating.toString() == "1") {
                        //   print("Worst");
                        // }

                        setState(() {
                          selected_value = list[rating.toInt()];
                          print(selected_value);
                          print(rating.toString());
                        });
                      },
                      buttonOnTap: () async {
                        await  FirebaseFirestore.instance
                    .collection('Orders')
                    .doc(orderId)
                    .update({'rating_status': 'Done'});
                        await element.reference.update({
                          'rating': selected_value,
                        }).then(
                          (value) {
                            Navigator.pop(context);
                          },
                        );
                      },
                    )).then((value) async {
              // This callback is triggered when the dialog is dismissed
              if (selected_value.isEmpty) {
                print("not selected");
                await FirebaseFirestore.instance
                    .collection('Orders')
                    .doc(orderId)
                    .update({'rating_status': 'Not given'});
  await element.reference.update({
                          'rating': "Not given",
                        });
                // If no rating was selected, save as "not given"
                // saveRating(orderId, "not given");
              }
            });
          }
        } else {
          print('No pending service.');
        }
      }
    } else {
      print('No pending feedback.');
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Timer(Duration(seconds: 3), () {
    //   startup = "yes";
    // });
    chek_login().then((value) => getuserData()
            .then((value) => {
                  if (aggrement == "false")
                    {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Agreement_page(
                              aggrement_accepted: false,
                            ),
                          )),
                    }
                })
            .then((value) {
          checkFeedbackStatus(checking);
        }));

    if (widget.page_index != null) {
      currentIndex = widget.page_index!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // title: Text("hello"),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Cart(),
                  ));
            },
            icon: Icon(Icons.shopping_bag_outlined),
          )
        ],
      ),
      body: page_list[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,

        buttonBackgroundColor: Colors.indigo[900],
        color: Colors.indigo.shade900,
        animationDuration: const Duration(milliseconds: 300),
        items: [
          Icon(
            Icons.home,
            size: 26,
            color: Colors.white,
          ),
          Icon(
            Icons.shopping_cart_outlined,
            size: 26,
            color: Colors.white,
          ),
          Icon(
            Icons.favorite,
            size: 26,
            color: Colors.white,
          ),
          Icon(
            Icons.call,
            size: 26,
            color: Colors.white,
          ),
        ],
        // currentIndex: index,
        index: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Stack(children: [
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                height: 200,
                color: Colors.indigo[900],
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      userName != null
                          ? Text(
                              userName!,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          : Text("N/A")
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white),
                    child: Center(
                        child: userLOGO != null
                            ? Text(userLOGO!, style: TextStyle(fontSize: 30))
                            : Text("N/A")),
                  ),
                ),
              )
            ]),
            ListTile(
              title: Text(
                "Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: userName != null ? Text(userName!) : Text("N/A"),
              trailing: Icon(
                Icons.edit,
                size: 20,
              ),
              onTap: () {
                setState(() {
                  editable.text = userName!;
                  getUpdateData(context, "Fullname");
                });
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                "Phone",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: userPhone != null ? Text(userPhone!) : Text("N/A"),
              trailing: Icon(
                Icons.edit,
                size: 20,
              ),
              onTap: () {
                setState(() {
                  editable.text = userPhone!;
                  getUpdateData(context, "contact");
                });
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: userEmail != null ? Text(userEmail!) : Text("N/A"),
              trailing: Icon(
                Icons.edit,
                size: 20,
              ),
              onTap: () {
                setState(() {
                  editable.text = userEmail!;
                  getUpdateData(context, "email");
                });
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                "About Us",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => About(),
                      ));
                });
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.description),
              title: Text(
                "FAQ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Faq(),
                      ));
                });
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.description),
              title: Text(
                "Terms & Conditions",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Agreement_page(
                          aggrement_accepted: true,
                        ),
                      ));
                });
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                "Logout",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    headerAnimationLoop: false,
                    animType: AnimType.bottomSlide,
                    title: 'Question',
                    desc: 'Do you want to logout?',
                    buttonsTextStyle: const TextStyle(color: Colors.black),
                    showCloseIcon: true,
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      await FirebaseFirestore.instance
                          .collection('User')
                          .doc(u)
                          .update({
                        'status': 'logged_out',
                      });
                      SharedPreferences shared =
                          await SharedPreferences.getInstance();
                      shared.remove("login").then(
                        (value) {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => Mainscreen(
                                        page: "signin",
                                      )));
                        },
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You are logout'),
                        ),
                      );
                    },
                  ).show();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future getUpdateData(BuildContext context, String field) async {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => BottomSheet(
        constraints: BoxConstraints(maxHeight: 550),
        backgroundColor: Color.fromRGBO(226, 233, 249, 1),
        onClosing: () {},
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close)),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Update ${field}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: editable,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.green, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: TextButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('User')
                                    .doc(u)
                                    .update({
                                  field: editable.text,
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Your ${field} Updated'),
                                  ),
                                );
                                getuserData();
                              },
                              child: Text("Update Data")),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
