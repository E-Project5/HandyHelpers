import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handy_helpers/services/database_conn.dart';
import 'package:handy_helpers/user_side/detail.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: select_services(
      key_id: "yes",
    ),
  ));
}

// ignore: must_be_immutable
class select_services extends StatefulWidget {
  final String? key_id;
  select_services({required this.key_id});

  @override
  _select_servicesState createState() => _select_servicesState();
}

class _select_servicesState extends State<select_services> {
  Stream<QuerySnapshot>? service_data;
  getdata() async {
    service_data = await databasemodel().services(widget.key_id!);

    setState(() {});
  }

  String? categoryname;
  getcat() async {
    categoryname = await databasemodel().fetchCategoryName(widget.key_id!);
    setState(() {});
  }
  

  @override
  void initState() {
    getcat();
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Service",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 25,
              color: const Color.fromARGB(255, 12, 78, 133)),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                categoryname != null ?
                Text(
                  categoryname!,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 13, 63, 104)),
                )
                :
                CircularProgressIndicator(),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: service_data,
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
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds = snapshot.data.docs[index];

                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: (){
                                         Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                   Detail(service_id: ds['Id'])
                                              ));
                                      },
                                        title: Text(
                                          ds["Service_title"],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        tileColor: Colors.blue.shade50,
                                        subtitle: Text(
                                            ds["sub_title"]),
                                        trailing: Icon(Icons.navigate_next),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        leading: Container(
                                          height: 40,
                                          child: Image.network(ds['Service_icon']),
                                        )
                                        ),
                                        SizedBox(height: 10,)
                                  ],
                                );
                                   
                              }
                              
                              ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                }),
          ],
        ),
      ),
    );
  }
}
