import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:handy_helpers/admin/add_category.dart';
import 'package:handy_helpers/admin/dashboard.dart';
import 'package:handy_helpers/services/database_conn.dart';
import 'package:random_string/random_string.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ShowCategory(),
  ));
}

class ShowCategory extends StatefulWidget {
  const ShowCategory({Key? key}) : super(key: key);

  @override
  _ShowCategoryState createState() => _ShowCategoryState();
}

class _ShowCategoryState extends State<ShowCategory> {
    TextEditingController category_name = TextEditingController();
  TextEditingController editCategory = TextEditingController();
   PlatformFile? pickedfiles;
  Uint8List? Bytes;
  UploadTask? uploadfile;
  var img_url;
  Future upload_img() async {
    try {
      if (pickedfiles == null || pickedfiles!.bytes == null) {
        return;
      }
      final path_ = 'categories/${pickedfiles!.name}';
      final ref = FirebaseStorage.instance.ref().child(path_);
      print(path_);
      setState(() {
        uploadfile = ref.putData(pickedfiles!.bytes!);
        // img_url = path_;
      });
      final snapshot = await uploadfile!.whenComplete(
        () => {},
      );
      final url_download = await snapshot.ref.getDownloadURL();
      print("Your URL lin is ${url_download}");
      setState(() {
        img_url = url_download;
        uploadfile = null;
      });
    } on FirebaseException catch (e) {
      print(e.code.toString());
    }
  }

  Future selectfile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    final platform_file = result.files.first;
    Bytes = platform_file.bytes;
    setState(() {
      pickedfiles = result.files.first;
    });
  }

  Stream? categorystream;
  getload() async {
    categorystream = await databasemodel().getcategories();
    setState(() {});
  }

  @override
  void initState() {
    getload();
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: StreamBuilder(
          stream: categorystream,
          builder: (context, AsyncSnapshot snapshot) {
            return snapshot.hasData
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Categories",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          // IconButton(onPressed: (){
                          //    addcategory(context);
                          // }, icon:  Icon(Icons.add,color: Colors.white),)
                        ],
                      ),
                      SizedBox(height: 30),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.docs[index];
                            return FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection("Services")
                                  .where("Service_cat",
                                      isEqualTo: ds['Category'])
                                  .get(),
                              builder: (context, AsyncSnapshot checkSnapshot) {
                                if (checkSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                if (checkSnapshot.hasError) {
                                  return Text('Error: ${checkSnapshot.error}');
                                }

                                var check = checkSnapshot.data.docs.length;
                                return 
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(width: 1)),
                                padding: EdgeInsets.all(10),
                                child: ListTile(
                                  leading: Image.network(
                                        ds['C_image'],
                                        width: 40,
                                        height: 40,
                                      ), 
                                  title: Text("Category : ${ds["Category"]}"),
                                  subtitle: Text("services : ${check}"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                                         IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.edit)),
                                                IconButton(
                                                    onPressed: () {
                                                      AwesomeDialog(
                                                        context: context,
                                                        dialogType:
                                                            DialogType.error,
                                                        headerAnimationLoop:
                                                            false,
                                                        animType: AnimType
                                                            .bottomSlide,
                                                        title: 'Question',
                                                        desc:
                                                            'Are you sure? You want delete this data',
                                                        buttonsTextStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .black),
                                                        showCloseIcon: true,
                                                        btnCancelOnPress: () {},
                                                        btnOkOnPress: () async {
                                                          await databasemodel()
                                                              .deletecategory(
                                                                  ds["Id"]);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'Category has been deleted successfully'),
                                                            ),
                                                          );
                                                        },
                                                      ).show();
                                                    },
                                                    icon: Icon(Icons.delete))
                                    ],
                                  ),
                                ),
                                
                                );
                                
                                
                              },
                            );
                          }),

                           GestureDetector(
                        onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context) => dashboard(page: 2)));
                        },
                        child: Container(
                          width: 200,
                          height: 60,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue[900]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add,color: Colors.white),
                              Text("Add Category",style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : Container();
          }),
    );
  }
 
}
