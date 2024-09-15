import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handy_helpers/user_side/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "cat",
    home: Wishlist(),
  ));
}

class Wishlist extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Wishlist> {
  var checking;
  Future<void> checkLogin() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    setState(() {
      checking = shared.getString("login");
    });
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(226, 233, 249, 1),
      body: SafeArea(
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Wishlisht',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            // flex: 5,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('User')
                      .doc(checking)
                      .collection('wishlist')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    var  check = snapshot.data.docs;

                    if (check == null || check.isEmpty) {
                      return Center(child: Text("Wishlist empty"));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot wishlist = snapshot.data.docs[index];
                        
                        return snapshot.hasData
                            ? Column(
                                children: [
                                  Container(
                                    // height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(122, 155, 201, 232),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Detail(
                                                  service_id:
                                                      wishlist['ID']),
                                            ));
                                      },
                                      leading: Image.network(
                                        wishlist['serviceImg'],
                                      ),
                                      title: Text(
                                        wishlist['servicename'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Category : ${wishlist['categoryname']}",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('User')
                                                    .doc(checking)
                                                    .collection('wishlist')
                                                    .doc(wishlist['serviceId'])
                                                    .delete();

                                                setState(() {});

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Removed from wishlist')),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.favorite,
                                                size: 20,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            : Center(child: CircularProgressIndicator());
                      },
                    );
                  },
                )),
          ),
        ]),
      ),
    );
  }
}

class CustomDottedDivider extends StatelessWidget {
  const CustomDottedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(400 ~/ 10, (index) {
      return Expanded(
        child: Container(
          color: index % 2 == 0 ? Colors.transparent : Colors.grey,
          height: 1.5,
        ),
      );
    }));
  }
}
