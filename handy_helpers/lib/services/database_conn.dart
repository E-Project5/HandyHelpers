import 'package:cloud_firestore/cloud_firestore.dart';
class databasemodel {
  //-----Category Crud-----------
  Future add_category(Map<String, dynamic> category_map, String C_id) async {
    await FirebaseFirestore.instance
        .collection("S_Category")
        .doc(C_id)
        .set(category_map);
  }

  Future<Stream<QuerySnapshot>> getcategories() async {
    return await FirebaseFirestore.instance
        .collection("S_Category")
        .snapshots();
  }

  Future deletecategory(String delid) async {
    await FirebaseFirestore.instance
        .collection("S_Category")
        .doc(delid)
        .delete();
  }

  //-----Category Crud-----------
  //-----Services Crud-----------
  //add services
  Future add_Service(Map<String, dynamic> servicemap, String s_id) async {
    await FirebaseFirestore.instance
        .collection("Services")
        .doc(s_id)
        .set(servicemap);
  }

  //show services
  Future<Stream<QuerySnapshot>> getservices() async {
    return await FirebaseFirestore.instance.collection("Services").snapshots();
  }

  //-----update services
  Future updateservice(Map<String, dynamic> servicemap, String sid) async {
    await FirebaseFirestore.instance
        .collection("Services")
        .doc(sid)
        .update(servicemap);
  }

  //---------CAtegory fetching for services user side
  Future<String> fetchCategoryName(String categoryId) async {
    DocumentSnapshot categorySnapshot = await FirebaseFirestore.instance
        .collection('S_Category')
        .doc(categoryId)
        .get();

    if (categorySnapshot.exists) {
      return categorySnapshot['Category'];
    } else {
      return 'Category Not Found';
    }
  }

  Future<Map> fetchCategory(String categoryId) async {
    // var data = [];
    DocumentSnapshot categorySnapshot = await FirebaseFirestore.instance
        .collection('S_Category')
        .doc(categoryId)
        .get();
    var data = {
      "id": categorySnapshot['Id'],
      "name": categorySnapshot['Category']
    };
    return data;
  }

  Future deleteservices(String delid) async {
    await FirebaseFirestore.instance.collection("Services").doc(delid).delete();
  }

  //-----Services Crud-----------

  //------------User Side
  Future<Stream<QuerySnapshot>> services(String cat_id) async {
    return await FirebaseFirestore.instance
        .collection('Services')
        .where('Service_cat', isEqualTo: cat_id)
        .snapshots();
  }

//----------ADd user
  Future add_user(Map<String, dynamic> user_data, String id) async {
    await FirebaseFirestore.instance.collection("User").doc(id).set(user_data);
  }
  // Future<Map> changestatus(String email) async {
  //   // var data = [];
  //   DocumentSnapshot usersnapshot = await FirebaseFirestore.instance
  //       .collection('User')
  //       .doc(email)
  //       .get();
  //   var u_data = {
  //     "id": usersnapshot['Id'],
  //     "status": usersnapshot['status'],

  //   };
  //   return u_data;
  // }
  Future<DocumentSnapshot> changestatus(String email) async {
    return await FirebaseFirestore.instance
        .collection('User')
        .doc(email)
        .get();
  }


  // Future<void> sendVerificationCode(String email) async {
  //   try {
  //     final HttpsCallable callable =
  //         FirebaseFunctions.instance.httpsCallable('sendVerificationCode');
  //     await callable.call(<String, dynamic>{
  //       'email': email,
  //     });
  //     Fluttertoast.showToast(
  //         msg: "Verification code sent to your email.",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   } on FirebaseFunctionsException catch (e) {
  //     Fluttertoast.showToast(
  //         msg: e.message ?? "Failed to send verification code.");
  //   }
  // }
}
