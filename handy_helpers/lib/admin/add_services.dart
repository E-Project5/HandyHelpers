import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handy_helpers/admin/dashboard.dart';
import 'package:handy_helpers/services/database_conn.dart';
import 'package:random_string/random_string.dart';

class AddServices extends StatefulWidget {
  const AddServices({Key? key}) : super(key: key);

  @override
  _AddServicesState createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  TextEditingController servicename = TextEditingController();
  TextEditingController subtitle = TextEditingController();
  TextEditingController serviceprice = TextEditingController();
  TextEditingController desc = TextEditingController();
//----------Category on dropdown
  String? dropdown_Selected;
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

  //-------------image
  PlatformFile? pickedfiles;
  Uint8List? Bytes;
  UploadTask? uploadfile;
  var img_url;
  //image uploading
  Future upload_img() async {
    try {
      if (pickedfiles == null || pickedfiles!.bytes == null) {
        return;
      }
      final path_ = 'services/${pickedfiles!.name}';
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

  // image selecting
  Future selectfile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    final platform_file = result.files.first;
    Bytes = platform_file.bytes;
    setState(() {
      pickedfiles = result.files.first;
    });
  }

  //-------------icon
  Uint8List? icon_file;
  PlatformFile? picked_icon;
  UploadTask? uploadicon;
  var icon_url;
  // ---- select icon
  Future selecticon() async {
    final icon_r = await FilePicker.platform.pickFiles();
    if (icon_r == null) return;
    final platform_icon = icon_r.files.first;
    icon_file = platform_icon.bytes;
    setState(() {
      picked_icon = icon_r.files.first;
    });
  }

//------upload icon
  Future upload_icon() async {
    try {
      if (picked_icon == null || picked_icon!.bytes == null) {
        return;
      }
      final icon_path_ = 'services/icons/${picked_icon!.name}';
      final ref = FirebaseStorage.instance.ref().child(icon_path_);
      print(icon_path_);
      setState(() {
        uploadicon = ref.putData(picked_icon!.bytes!);
      });
      final icon_snapshot = await uploadicon!.whenComplete(
        () => {},
      );
      final icon_url_download = await icon_snapshot.ref.getDownloadURL();
      print("Your URL lin is ${icon_url_download}");
      setState(() {
        icon_url = icon_url_download;
        uploadicon = null;
      });
    } on FirebaseException catch (e) {
      print(e.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Container(
         width: double.infinity,
        child: Center(
          child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Add Service",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.name,
                controller: servicename,
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
                    
                    labelText: "Title",
                    labelStyle: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey)),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.name,
                controller: subtitle,
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
                    labelText: "Sub Title",
                    labelStyle: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey)),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: serviceprice,
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
                    
                    labelText: "Service Price",
                    labelStyle: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey)),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: desc,
                  minLines:
                    6, // any number you need (It works as the rows for the textarea)
                keyboardType: TextInputType.multiline,
                maxLines: 100,
                decoration: InputDecoration(
                   alignLabelWithHint: true,
                    // contentPadding: EdgeInsets.fromLTRB(20, 50, 20, 50),
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
                    
                    labelText: "Service Description",
                    labelStyle: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey)),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: StreamBuilder(
                  stream: categorystream,
                  builder: (context, snapshot) {
                    List<DropdownMenuItem> categoryitems = [];
                    if (!snapshot.hasData) {
                      CircularProgressIndicator();
                    } else {
                      final cat = snapshot.data?.docs.reversed.toList();
                      for (var categories in cat!) {
                        categoryitems.add(DropdownMenuItem(
                            value: categories['Id'],
                            child: Text(categories['Category'])));
                      }
                    }
                    return DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: categoryitems,
                        onChanged: (value) {
                          setState(() {
                            dropdown_Selected = value;
                          });
                          print(dropdown_Selected);
                        },
                        value: dropdown_Selected,
                        isExpanded: true,
                        hint: Text("Select category"),
                      ),
                    );
                  },
                ),
              ),
               SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    selecticon();
                  },
                  child: Text("Upload Icon")),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                  ),
                child: Center(
                  child: icon_file != null
                      ? Image.memory(
                          icon_file!,
                          height: 100,
                          width: 100,
                        )
                      : Container(
                          child: Center(child: Text("No Icon selected")),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    selectfile();
                  },
                  child: Text("Upload File")),
              SizedBox(
height: 10,              ),
              Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),),
                child: Center(
                  child: Bytes != null
                      ? Image.memory(
                          Bytes!,
                          height: 150,
                          width: 150,
                        )
                      : Container(
                          child: Center(child: Text("No Image selected")),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await upload_img();
                    await upload_icon();
                    String s_id = randomAlphaNumeric(10);
                    Map<String, dynamic> service_data = {
                      "Id": s_id,
                      "Service_title": servicename.text,
                      "Service_price": serviceprice.text,
                      "Service_cat": dropdown_Selected,
                      "sub_title": subtitle.text,
                      "description": desc.text,
                      "Service_img": img_url,
                      "Service_icon": icon_url,
                    };

                    await databasemodel().add_Service(service_data, s_id).then(
                        (value) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Service has been added "))));
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => dashboard( page: 4),
                        ));
                    // Navigator.pop(context);
                  },
                  child: Text("Add Service")),
                  SizedBox(
                  height: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
