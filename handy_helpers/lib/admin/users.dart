import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  @override
  _UsersData createState() => _UsersData();
}

class _UsersData extends State<Users> {
  Stream<QuerySnapshot>? user_data;
  getUsers() async {
    user_data = await FirebaseFirestore.instance.collection('User').snapshots();
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    print("USerDAta");
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Users"),
        SizedBox(height: 30,),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: user_data,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
          
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot user = snapshot.data.docs[index];
                          return Card(
                                margin: EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text('User Name: ${user['Fullname']}'),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Email: ${user['email']}'),
                                      Text('Contact: ${user['contact']}'),
                                      // Text('Orders: ${check}'),
                                      Text('Status: ${user['status']}'),
                                    ],
                                  ),
                                  // trailing: Text(order['totalAmount']),
                                ),
                              );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              }),
        ),
      ],
    );
  }
}
