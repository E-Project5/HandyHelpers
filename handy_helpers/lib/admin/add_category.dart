// import 'dart:ffi';
import 'dart:async';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:handy_helpers/admin/dashboard.dart';
import 'package:handy_helpers/services/database_conn.dart';
import 'package:random_string/random_string.dart';

 
class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController category_name = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Container(
                child: Center(
          child: Column(
            children: [
              Text(
                "Add Category",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.name,
                controller: category_name,
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
                    prefixIcon: Icon(Icons.category),
                    labelText: "Category",
                    labelStyle: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey)),
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
                height: 20,
              ),
              Container(
                height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),),
                child: Center(
                  child: Bytes != null
                      ? Image.memory(Bytes!,height: 100,
                          width: 100,)
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
                    String id = randomAlphaNumeric(10);
                    Map<String, dynamic> category_data = {
                      "Id": id,
                      "Category": category_name.text,
                      "C_image": img_url
                    };
          
                    databasemodel().add_category(category_data, id).then(
                        (value) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Category has been added "))));
                            Navigator.push(context, MaterialPageRoute(builder: (context) => dashboard(page: 1),));
                  },
                  child: Text("Add Category"))
            ],
          ),
                ),
              ),
        );
  }
}
