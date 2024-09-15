import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

void main() {}

class OrderDetails extends StatefulWidget {
  String? order_ID;
  OrderDetails({required this.order_ID});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late Future<DocumentSnapshot> OrderFuture;
  Future<DocumentSnapshot> getOrder(String ID) {
    return FirebaseFirestore.instance.collection('Orders').doc(ID).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? OrderDetail_data;
  getOrderDetails(String ID) async {
    OrderDetail_data = await FirebaseFirestore.instance
        .collection('Orders')
        .doc(ID)
        .collection("OrderDetails")
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    OrderFuture = getOrder(widget.order_ID.toString());
    getOrderDetails(widget.order_ID.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: Container(
        color: Color.fromRGBO(226, 233, 249, 1),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: OrderFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('Service not found'));
              }
              var Order = snapshot.data!.data() as Map<String, dynamic>;

              return StreamBuilder<QuerySnapshot>(
                stream: OrderDetail_data,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No Order Details found.'));
                  }

                  var serviceItems = snapshot.data?.docs;
                  Map<String, List<QueryDocumentSnapshot>> groupedItems = {};

                  for (var item in serviceItems) {
                    String category = item['category'] ?? 'Others';
                    if (groupedItems.containsKey(category)) {
                      groupedItems[category]!.add(item);
                    } else {
                      groupedItems[category] = [item];
                    }
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          decoration: BoxDecoration(
                              color: Order['status'] == "Completed"
                                  ? Colors.green[300]
                                  : Colors.red[300],
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            Order['status'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order Id:",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              Text(widget.order_ID.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                          shrinkWrap:
                              true, // Use shrinkWrap to fix layout issues
                          physics:
                              NeverScrollableScrollPhysics(), // Disable scrolling

                          itemCount: groupedItems.keys.length,
                          itemBuilder: (context, index) {
                            String category =
                                groupedItems.keys.elementAt(index);
                            List<QueryDocumentSnapshot> items =
                                groupedItems[category]!;

                            return Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blueAccent),
                                  ),
                                  SizedBox(height: 10),
                                  ...items.map((service) {
                                    return FutureBuilder<DocumentSnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('Services')
                                          .doc(service['serviceId'])
                                          .get(),
                                      builder: (context, serviceSnapshot) {
                                        if (!serviceSnapshot.hasData) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        var serviceData = serviceSnapshot.data!
                                            .data() as Map<String, dynamic>;

                                        return Column(
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(serviceData[
                                                      'Service_title']),
                                                  Text(
                                                    "X ${service['quantity'].toString()}",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            DottedLine(),
                                            SizedBox(height: 20),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Service price"),
                                                  Text(
                                                    "PKR ${serviceData['Service_price']}",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Sub total:"),
                                                  Text(
                                                    "PKR ${service['subtotal'].toString()}",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                          ],
                                        );
                                      },
                                    );
                                  }).toList(),
                                ],
                              ),
                            );
                          },
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Order Time"),
                                  Text(" ${Order['order_DateTime']}")
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
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Seleted Time"),
                                  Text(" ${Order['selectedTime']}")
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
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Seleted Day"),
                                  Text(" ${Order['date'].toString()+" "+ Order['day']}")
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
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("No Of Services"),
                                  Text(" ${Order['numberOfServices']}")
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
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total Amount"),
                                  Text(" ${Order['totalAmount']}")
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Order['status'] == "Pending"
                            ? Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('Orders')
                                          .doc(widget.order_ID)
                                          .update({'status': 'Cancelled'});

                                      // After the update, you might want to give feedback to the user or navigate back
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Order has been cancelled')),
                                      );

                                      // Optionally, refresh the UI after the status update
                                      setState(() {
                                        OrderFuture = getOrder(
                                            widget.order_ID.toString());
                                      });
                                    },
                                    child: Text("Cancel Order")),
                              )
                            : Container()
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
