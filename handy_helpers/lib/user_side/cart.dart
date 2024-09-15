import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handy_helpers/datemodel.dart' as Date_Utils;
import 'package:handy_helpers/user_side/side.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Cart(),
  ));
}

class TimeModel {
  String? time;
}

List<TimeModel> getTimes() {
  return [
    TimeModel()..time = "12 PM",
    TimeModel()..time = "01 PM",
    TimeModel()..time = "02 PM",
    TimeModel()..time = "04 PM",
    TimeModel()..time = "05 PM",
    TimeModel()..time = "06 PM",
  ];
}

class Cart extends StatefulWidget {
  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Cart> {
  String? checking;
  TextEditingController _locationController = TextEditingController();
  TextEditingController specialNoteController = TextEditingController();
  String? dropdown;
  List<DateTime> currentMonthList = [];
  DateTime selectedDateTime = DateTime.now();
  //  Date_Utils.DateUtils.weekdays[ currentMonthList[index].weekday - 1]
  var selectday = Date_Utils.DateUtils.weekdays[DateTime.now().weekday - 1];
  late ScrollController scrollController;
  List<TimeModel> times = [];
  String? selectedTime = "12 PM";
  String _location = '';
  bool? service_exists ;

  checkcart() async {
    // Get the reference to the cart collection for the specific user
    CollectionReference cartCollectionRef = FirebaseFirestore.instance
        .collection('User')
        .doc(checking) // Replace with the actual user ID variable
        .collection('cart');

    // Fetch all documents in the cart collection
    QuerySnapshot cartSnapshot = await cartCollectionRef.get();
    print(checking);
    print("Number of documents in cart: ${cartSnapshot.docs.length}");
    if (cartSnapshot.docs.isEmpty) {
      service_exists = false; // Cart is empty
    } else {
      service_exists = true; // Cart is not empty
    }
    setState(() {
      // Check if the cart collection is empty or not
    });
  }

 
  Future<void> checkLogin() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    setState(() {
      checking = shared.getString("login");

    });
  }
  Position? _currentLocation;
  String? _currentAddress;
 bool _isLoading = false;
  Future<void> _checklocationPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, re-check after a delay
        Future.delayed(Duration(seconds: 2), () async {
          await _checklocationPermissions();
        });
      } else if (permission == LocationPermission.deniedForever) {
        // Permissions are permanently denied
        _showPermissionDialog();
      } else {
        // Permissions are granted
        setState(() {
          _isLoading = true;
        });
        await _getCurrentLocation();
      }
    } else if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      _showPermissionDialog();
    } else {
      // Permissions are granted
     setState(() {
          _isLoading = true;
        });
        await _getCurrentLocation();
    }
    setState(() {
      
    });
  }

  Future<void> _showPermissionDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Permission Denied"),
          content: Text("Location permissions are permanently denied. Please enable them in settings."),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _openAppSettings();
              },
              child: Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openAppSettings() async {
    const platform = MethodChannel('com.example.admin/settings');
    try {
      await platform.invokeMethod('openAppSettings');
    } on PlatformException catch (e) {
      print("Failed to open app settings: '${e.message}'.");
    }
  }
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = position;
      });
      await _getAddress();
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> _getAddress() async {
    if (_currentLocation == null) return;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
         _locationController.text = _currentAddress!;
          _isLoading = false;


      });
    } catch (e) {
      print(e.toString());
    }
  }
  String? userName;
  String? userEmail;
  getuserData() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    checking = shared.getString("login");

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('User').doc(checking).get();
    setState(() {
      // u = widget.userId ;
      userName = userDoc.get('Fullname');
      userEmail = userDoc.get('email');
    });
    // Extract user data from the document
  }

  int totalamount = 0;

  void updateTotalAmount() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('User')
        .doc(checking)
        .collection('cart')
        .get();

    int newTotalAmount = 0;
    for (var item in snapshot.docs) {
      int quantity = item['quantity'];
      int price = int.parse(item['price']);
      newTotalAmount += quantity * price;
    }

    setState(() {
      totalamount = newTotalAmount;
    });
  }

  completeOrder() async {
    try {
      // Reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final cartItems = await FirebaseFirestore.instance
          .collection('User')
          .doc(checking)
          .collection('cart')
          .get();

      // Order data
      String orderId = randomAlphaNumeric(10); // Generates a new ID
      int numberOfServices = cartItems.docs.length;
      String? userId = checking;
        var orderDate = DateTime.now().day.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString();
  var orderTime =DateTime.now().hour.toString()+":"+DateTime.now().minute.toString()+":"+DateTime.now().second.toString();
      //  var datetime = DateTime.now().day.toString() +
      //     "-" +
      //     DateTime.now().month.toString() +
      //     "-" +
      //     DateTime.now().year.toString();
      // var time=DateTime.now().
      // Add the order to the "Orders" collection
      await firestore.collection('Orders').doc(orderId).set({
        'orderId': orderId,
        'numberOfServices': numberOfServices,
        'userId': userId,
        'username': userName,
        'useremail': userEmail,
        'selectedTime': selectedTime,
        'date': selectedDateTime.day,
        'day': selectday,
        'address': _location,
        'specialNote': specialNoteController.text,
        'totalAmount': totalamount,
        'orderTime': orderTime,
        'orderDATE': orderDate,
        'status': "Pending",
        'rating_status': "Pending",
      });
      // Add service details to "Order Details" collection or subcollection
      for (var item in cartItems.docs) {
        String serviceId = item['serviceId'];
        String service = item['servicename'];
        int quantity = item['quantity'];
        int price = int.parse(item['price']);
        int subtotal = quantity * price;

        // Option 2: Subcollection (uncomment if using this option)
        var subtotal_ = price * quantity;
        await firestore
            .collection('Orders')
            .doc(orderId)
            .collection('OrderDetails')
            .add({
              'orderID':orderId,
          'serviceId': serviceId,
          'service': service,
          'quantity': quantity,
          'price': price,
          'subtotal': subtotal_,
          'category': item['categoryname'],
          "rating":"Not yet"
        }).then(
          (value) async {
            await item.reference.delete();
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }
 @override
  void initState() {
    super.initState();
    checkLogin().then(
      (value) => checkcart().then((value){
getuserData();
      })
    );
    times = getTimes();
    currentMonthList = Date_Utils.DateUtils.daysInMonth(selectedDateTime);
    // currentMonthList = DateUtils.daysInMonth(selectedDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    scrollController =
        ScrollController(initialScrollOffset: 60.0 * selectedDateTime.day);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      backgroundColor: Colors.blueGrey[100],
      body: Stack(
        children:[
           service_exists == true
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('User')
                            .doc(checking)
                            .collection('cart')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
        
                          var cartItems = snapshot.data?.docs;
        
                          if (cartItems == null || cartItems.isEmpty) {
                            return Center(child: Text("Your cart is empty"));
                          }
        
                          // Group cart items by category
                          Map<String, List<QueryDocumentSnapshot>> groupedItems =
                              {};
                          // totalamount = 0;
                          for (var item in cartItems) {
                            String category = item['categoryname'] ?? 'Others';
                            if (groupedItems.containsKey(category)) {
                              groupedItems[category]!.add(item);
                            } else {
                              groupedItems[category] = [item];
                            }
                          }
        
                          return Column(
                            children: groupedItems.entries.map((entry) {
                              String category = entry.key;
                              List<QueryDocumentSnapshot> items = entry.value;
        
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Category Header
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 15),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              left: BorderSide(
                                                  color: Colors.indigo,
                                                  width: 5))),
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.indigo),
                                      ),
                                    ),
                                    Divider(),
                                    // Services under the same category
                                    ...items.map((item) {
                                      int quantity = item['quantity'];
                                      int subtotal =
                                          int.parse(item['price']) * quantity;
                                      updateTotalAmount();
                                      return ExpansionTile(
                                        title: Row(
                                          children: [
                                            Image.network(
                                              item['serviceImg'] ?? '',
                                              width: 50,
                                              height: 50,
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      item['servicename'] ??
                                                          'Service Name',
                                                      style:
                                                          TextStyle(fontSize: 15),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "X $quantity",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 30),
                                                  IconButton(
                                                      onPressed: () async {
                                                        await item.reference
                                                            .delete()
                                                            .then(
                                                              (value) =>
                                                                  checkcart(),
                                                            );
                                                      },
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Service Price: PKR ${item['price']}",
                                                  style: TextStyle(fontSize: 15),
                                                ),
                                                Text(
                                                  "Sub total: PKR ${subtotal.toString()}",
                                                  style: TextStyle(fontSize: 15),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () async {
                                                        // Decrease quantity logic
                                                        if (quantity > 1) {
                                                          await item.reference
                                                              .update({
                                                            'quantity':
                                                                quantity - 1,
                                                          });
                                                        }
                                                      },
                                                      icon: Icon(Icons.remove,
                                                          color: Colors.red),
                                                    ),
                                                    Text(quantity.toString()),
                                                    IconButton(
                                                      onPressed: () async {
                                                        // Increase quantity logic
                                                        await item.reference
                                                            .update({
                                                          'quantity':
                                                              quantity + 1,
                                                        });
                                                      },
                                                      icon: Icon(Icons.add,
                                                          color: Colors.green),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      SizedBox(height: 15),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 15),
        
                              // height: 30,
                              decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        color: Colors.indigo, width: 5)),
                              ),
                              child: Text(
                                "Date & Time",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 100,
                              child: ListView.builder(
                                itemCount: currentMonthList.length,
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                   var today =  DateTime.now();
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if(currentMonthList[index] .day
                                                    .toInt() >= today.day.toInt()){
                                          selectedDateTime =
                                              currentMonthList[index];
                                          selectday = Date_Utils
                                                  .DateUtils.weekdays[
                                              currentMonthList[index].weekday -
                                                  1];
                                        }}
                                        );
                                      },
                                      child: Container(
                                        height: 80,
                                        width: 50,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        decoration: BoxDecoration(
                                          color: (currentMonthList[index].day ==
                                                  selectedDateTime.day)
                                              ? Colors.indigo
                                              : (currentMonthList[index] .day
                                                    .toInt()+1 <= today.day.toInt())?
                                                Colors.grey  
                                              : Colors.white,
                                          border:
                                              Border.all(color: Colors.indigo),
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                currentMonthList[index]
                                                    .day
                                                    .toString(),
                                                style: TextStyle(
                                                  color: currentMonthList[index]
                                                              .day !=
                                                          selectedDateTime.day
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                Date_Utils.DateUtils.weekdays[
                                                    currentMonthList[index]
                                                            .weekday -
                                                        1],
                                                style: TextStyle(
                                                  color: currentMonthList[index]
                                                              .day !=
                                                          selectedDateTime.day
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 110,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 2.0,
                                ),
                                itemCount: times.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedTime = times[index].time;
                                      });
                                    },
                                    child: Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: selectedTime == times[index].time
                                            ? Colors.indigo
                                            : Colors.white,
                                        border: Border.all(color: Colors.indigo),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        times[index].time ?? '',
                                        style: TextStyle(
                                          color: selectedTime == times[index].time
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
                                    height: 30,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: Colors.indigo, width: 5))),
                                    child: Text(
                                      "Address",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(                                
                                  controller: _locationController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 2),
                                      ),
                                      prefixIcon:
                                          Icon(Icons.location_on_outlined),
                                      labelText: "Current Location",
                                      labelStyle: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey)),
                                  onTap: () {
                                     _checklocationPermissions();
                                  },
                                  readOnly: true,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  // keyboardType: TextInputType.phone,
                                  // controller: calender_text,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 2),
                                      ),
                                      prefixIcon: Icon(
                                          Icons.not_listed_location_outlined),
                                      labelText: "Adress note",
                                      labelStyle: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey)),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 15),
        
                                    // height: 30,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: Colors.indigo, width: 5))),
                                    child: Text(
                                      "Payment",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total Amount"),
                                      Text("PKR  ${totalamount.toString()}"),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Payment Method"),
                                      Text("Cash on Delivery"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Side(),
                                ));
                          },
                          child: Text("Back to home"),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            if(_locationController.text != null){
                            completeOrder();
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
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
                              title: 'Booked',
                              desc: 'You have booked service',
                              showCloseIcon: true,
                              btnOkText: "Check booking",
                              btnOkOnPress: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Side(page_index: 1,),
                                    ));
                              },
                              // ok: () {},
                            ).show();
                            }
                          },
                          child: Text("complete order"),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Your Cart is empty",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 30,
                          fontWeight: FontWeight.w700),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Side(),
                              ));
                        },
                        child: Text("Back to Home"))
                  ],
                ),
              ),
          LoadingOverlay(isLoading: _isLoading),
     
      ]),
    );
  }
  

}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const LoadingOverlay({Key? key, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return SizedBox.shrink();
    }

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5), // Semi-transparent background
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

