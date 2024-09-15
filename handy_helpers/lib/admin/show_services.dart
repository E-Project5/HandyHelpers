import 'dart:async';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handy_helpers/services/database_conn.dart';

class ShowServices extends StatefulWidget {
  const ShowServices({Key? key}) : super(key: key);

  @override
  _ShowServicesState createState() => _ShowServicesState();
}

class _ShowServicesState extends State<ShowServices> {
  TextEditingController edit_title = TextEditingController();
  TextEditingController edit_price = TextEditingController();
  TextEditingController edit_desc = TextEditingController();
  TextEditingController edit_subtitle = TextEditingController();
  Stream? servicesstream;
  Stream? categoriesData;
  // Stream? categorystream;

  getload() async {
    servicesstream = await databasemodel().getservices();
    categoriesData = await databasemodel().getcategories();

    setState(() {});
  }

  @override
  void initState() {
    getload();

    super.initState();
  }

  var categoryname;
  getcat(i_d) async {
    categoryname = await databasemodel().fetchCategory(i_d);
    setState(() {});
  }

  String? image_url;
  String? icon_url;
  Uint8List? img_Bytes;
  PlatformFile? pickedfiles;
  UploadTask? uploadfile;
  Future selectimgfile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return print("object");
    final platform_file = result.files.first;
    img_Bytes = platform_file.bytes;
    image_url = null;
    setState(() {
      pickedfiles = result.files.first;
    });
  }

  Widget allservices() {
    return StreamBuilder(
        stream: servicesstream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    // getcat(ds["Service_cat"]);
                    // String? xyz;
                    // if (categoryname['id'] == ds["Service_cat"]) {
                    //   xyz = categoryname['name'];
                    // } else {
                    //   xyz = "xx";
                    // }

                    return Container(
                      width: double.infinity,
                      child: Card(
                        child: Row(
                          children: [
                            Image.network(
                              ds['Service_img'],
                              width: 120,
                              height: 120,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name : \n ${ds["Service_title"]}"),
                                  Text("Price : ${ds["Service_price"]}"),
                                  // Text("Category:${xyz}"),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            getUpdateData(context, ds["Id"]);
                                            edit_title.text =
                                                ds['Service_title'];
                                            edit_price.text =
                                                ds['Service_price'];
                                            edit_subtitle.text =
                                                ds['sub_title'];
                                            edit_desc.text = ds['description'];
                                            
                                            image_url = ds['Service_img'];
                                            icon_url = ds['Service_icon'];
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.error,
                                              headerAnimationLoop: false,
                                              animType: AnimType.bottomSlide,
                                              title: 'Question',
                                              desc:
                                                  'Are you sure? You want delete this data',
                                              buttonsTextStyle: const TextStyle(
                                                  color: Colors.black),
                                              showCloseIcon: true,
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () async {
                                                await databasemodel()
                                                    .deleteservices(ds["Id"]);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Service has been deleted successfully'),
                                                  ),
                                                );
                                              },
                                            ).show();
                                          },
                                          icon: Icon(Icons.delete))
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: allservices(),
      ),
    );
  }

//--------------------------------update data
  Future getUpdateData(BuildContext context, String editid) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(
              "Update service",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close),
              alignment: Alignment.topRight,
            ),
          ],
        ),

        // icon: IconButton(onPressed: (){

        // }, icon: Icon(Icons.close),alignment: Alignment.topRight,),

        content: SingleChildScrollView(
          child: Container(
            // height: 350,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                //-----------------------------username
                TextField(
                  // keyboardType: TextInputType.name,
                  controller: edit_title,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                //------------------------------------------email
                TextField(
                  controller: edit_price,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                //---------------------------phone
                TextField(
                    controller: edit_subtitle,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                    )),

                SizedBox(
                  height: 10,
                ),
                //---------------------------phone
                TextField(
                    controller: edit_desc,
                    minLines:
                        6, // any number you need (It works as the rows for the textarea)
                    keyboardType: TextInputType.multiline,
                    maxLines: 100,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                    )),

                SizedBox(
                  height: 10,
                ),
                img_Bytes != null
                    ? Image.memory(
                        img_Bytes!,
                        height: 120,
                        width: 120,
                      )
                    : Image.network(
                        image_url!,
                        height: 120,
                        width: 120,
                      ),

                ElevatedButton(
                    onPressed: () {
                      selectimgfile();
                    },
                    child: Text("Upload  image")),
                SizedBox(
                  height: 10,
                ),
                Image.network(
                  icon_url!,
                  height: 120,
                  width: 120,
                ),
                ElevatedButton(onPressed: () {}, child: Text("Upload  Icon")),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: () {
                        Map<String, dynamic> updatedata = {
                          "Service_title": edit_title.text,
                          "Service_price": edit_price.text,
                          "sub_title": edit_subtitle.text,
                          "description": edit_desc.text,
                          "Service_icon": icon_url,
                          "Service_img": image_url,
                        };
                        databasemodel().updateservice(updatedata, editid).then(
                            (value) => AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                headerAnimationLoop: false,
                                animType: AnimType.bottomSlide,
                                title: "Sucess",
                                desc:
                                    "Your data has been successfully Updated .....",
                                buttonsTextStyle:
                                    TextStyle(color: Colors.black),
                                showCloseIcon: true,
                                btnOkOnPress: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Update Record successfully'),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }).show());
                      },
                      child: Text("Update Record")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
