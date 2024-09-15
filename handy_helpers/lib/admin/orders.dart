import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {


  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  Stream<QuerySnapshot>? OrdersData;
  getOrders()async{
             OrdersData = await FirebaseFirestore.instance
          .collection('Orders')
          .snapshots();
          setState(() {
            
          });

  }
  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: OrdersData,
      builder: (context,AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
        return snapshot.hasData?
        ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
               DocumentSnapshot order =
                                  snapshot.data.docs[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Order ID: ${order['orderId']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Date: ${order['order_DateTime']}'),
                      Text('No of Services: ${order['numberOfServices']}'),
                      Text('User ID: ${order['userId']}'),
                      Text('Status: ${order['status']}'),
                      order['status'] == "Pending"?
                      TextButton(onPressed: ()async{ 
                                       await order.reference
                                                           .update({
                                                            'status':
                                                               'Completed',
                                                          });
                                                            

                                      // After the update, you might want to give feedback to the user or navigate back
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Order status changed')),
                                      );

                                      // Optionally, refresh the UI after the status update
                                      setState(() {
                                       
                                      });
                            }, child: Text("Complete")) 
                            : Text(""),
                    ],
                  ),
                  // trailing: Text(order['totalAmount']),
                ),
              );
            },
          ):Center(child: CircularProgressIndicator(),);
      }
    );
  }
}