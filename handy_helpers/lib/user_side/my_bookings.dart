import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:handy_helpers/user_side/order_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: MyBookings(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyBookings extends StatefulWidget {
  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  //----dropdown value by default
  String? dropdown_Selected = "All";

  //---- getting user id
  String? checking;
  Future<void> checkLogin() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    setState(() {
      checking = shared.getString("login");
    });
  }

//--------------------data getting
  Stream<QuerySnapshot>? OrdersData;
  getOrders() async {
    if (dropdown_Selected == "Pending") {
      OrdersData = await FirebaseFirestore.instance
          .collection('Orders')
          .where("userId", isEqualTo: checking)
          .where("status", isEqualTo: "Pending")
          .snapshots();
    } else if (dropdown_Selected == "Completed") {
      OrdersData = await FirebaseFirestore.instance
          .collection('Orders')
          .where("userId", isEqualTo: checking)
          .where("status", isEqualTo: "Completed")
          .snapshots();
    } else if (dropdown_Selected == "Cancel") {
      OrdersData = await FirebaseFirestore.instance
          .collection('Orders')
          .where("userId", isEqualTo: checking)
          .where("status", isEqualTo: "Cancel")
          .snapshots();
    } else {
      OrdersData = FirebaseFirestore.instance
          .collection('Orders')
          .where("userId", isEqualTo: checking)
          .snapshots();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Container(
                  child: Text(
                "My ORDER",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              )),
                  SizedBox(
                height: 20,
              ),
              Container(
                  width: 600,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      items: [
                        DropdownMenuItem(
                          child: Text("All"),
                          value: "All",
                        ),
                        DropdownMenuItem(
                          child: Text("Pending"),
                          value: "Pending",
                        ),
                        DropdownMenuItem(
                          child: Text("Completed"),
                          value: "Completed",
                        ),
                        DropdownMenuItem(
                          child: Text("Cancel"),
                          value: "Cancel",
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          dropdown_Selected = value;
                        });
                        getOrders();
                        print(dropdown_Selected);
                      },
                      value: dropdown_Selected,
                      isExpanded: true,
                      enableFeedback: true,
                    ),
                  )),
              
              SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: OrdersData,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return snapshot.hasData
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot order_data =
                                  snapshot.data.docs[index];
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color.fromRGBO(226, 233, 249, 1),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Order ID :  ${order_data['orderId']}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey),
                                            ),
                                            Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: order_data['status'] ==
                                                          "Completed"
                                                      ? Colors.green[300]
                                                      : Colors.red[300],
                                                ),
                                                child: Text(
                                                  " ${order_data['status']}",
                                                  style: TextStyle(
                                                      color: order_data[
                                                                  'status'] ==
                                                              "Completed"
                                                          ? Colors.green[900]
                                                          : Colors.red[900],
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Center(
                                          child: Container(
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Order Time"),
                                                    Text(
                                                        " ${order_data['orderTime']}")
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                DottedLine(),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("No Of Services"),
                                                    Text(
                                                        " ${order_data['numberOfServices']}")
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                DottedLine(),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Total Amount"),
                                                    Text(
                                                        " ${order_data['totalAmount']}")
                                                  ],
                                                ),
                                              ],
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
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderDetails(order_ID: order_data[
                                                            'orderId'] ,),
                                                    ));
                                              },
                                              child: Text("Order Details")),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  )
                                ],
                              );
                            },
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
