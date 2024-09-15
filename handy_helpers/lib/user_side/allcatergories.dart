import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handy_helpers/user_side/services.dart';

class Allcatergories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Services"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('S_Category').orderBy("Category",descending: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var services = snapshot.data!.docs;

          return Container(
            height: MediaQuery.of(context).size.height -
                kToolbarHeight, // Set height explicitly
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.0, // Adjust as needed
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                var service = services[index];
                return InkWell(
                   onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                select_services(key_id: service['Id'])));
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          
                             color: service['Category'] == "Salon"
                             ?Color.fromARGB(255, 255, 190, 228)
                             : service['Category'] == "Plumber"
                             ?Color.fromARGB(255, 167, 171, 218)
                             :service['Category'] == "Repairing"
                             ? Color.fromARGB(255, 178, 212, 210)
                             :service['Category'] == "Cleaning"
                             ?Color.fromARGB(255, 167, 202, 218)
                             :service['Category'] == "Electrician"
                            ? Color.fromARGB(
                                                  255, 244, 190, 255)
                             : Color.fromARGB(255, 167, 202, 218),
                        ),
                        child: Image.network(
                          service['C_image'],
                          height: 40,
                          color: service['Category'] == "Salon"
                          ?  Color.fromARGB(255, 228, 18, 133)
                          :service['Category'] == "Plumber"
                          ? Color.fromARGB(255, 24, 19, 95)
                          :service['Category'] == "Repairing"
                          ? Color.fromARGB(255, 9, 112, 86)
                           :service['Category'] == "Cleaning"
                           ? Color.fromARGB(255, 5, 119, 172)
                           :service['Category'] == "Electrician"
                           ? Colors.purple
                          :Colors.purple,
                        ),
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        child: Text(
                          service['Category'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          // Define the action on tap
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
