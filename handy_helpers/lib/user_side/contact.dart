import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:handy_helpers/services/database_conn.dart';
import 'package:handy_helpers/start/theme/theme.dart';
import 'package:handy_helpers/user_side/side.dart';
import 'package:random_string/random_string.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Contact Screen",
    home: ContactUsForm(),
  ));
}

class ContactUsForm extends StatefulWidget {
  const ContactUsForm({super.key});

  @override
  State<ContactUsForm> createState() => _ContactUsFormnState();
}

class _ContactUsFormnState extends State<ContactUsForm> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;

  //----controllers
  // ignore: non_constant_identifier_names
  TextEditingController contact_name = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController contact_email = TextEditingController();
  TextEditingController contact_msg = TextEditingController();

  send_Msg() async {
    String msgId = randomAlphaNumeric(10);
    var msg_date = DateTime.now().day.toString() +
        "-" +
        DateTime.now().month.toString() +
        "-" +
        DateTime.now().year.toString();
    var msg_Time = DateTime.now().hour.toString() +
        ":" +
        DateTime.now().minute.toString() +
        ":" +
        DateTime.now().second.toString();
    await FirebaseFirestore.instance.collection("Messaages").doc().set({
      "msgId": msgId,
      "contact_name": contact_name.text,
      "contact_email": contact_email.text,
      "contact_msg": contact_msg.text,
      "Msg_Date": msg_date,
      "Msg_time": msg_Time,
    }).then((value) {
      
   Fluttertoast.showToast(
                  msg: "Thank you for contacting us. Our agent will contact you soon",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.SNACKBAR,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );
    },);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Contact Us',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      //----email field
                      TextFormField(
                        controller: contact_name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Name'),
                          hintText: 'Enter Name',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 25.0,
                      ),
                      //---email field
                      TextFormField(
                        controller: contact_email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      //----message field
                      TextFormField(
                        // onSaved: (value) => _data.message = value!,
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        //Normal textInputField will be displayed
                        maxLines: 10,
                        // when user presses enter it will adapt to it
                        controller: contact_msg,
                        decoration: InputDecoration(
                          label: const Text('Message'),
                          hintText: 'Enter Message',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter you Message';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(77, 107, 179, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () async {
                            send_Msg();
Navigator.push(context,MaterialPageRoute(builder: (context) => Side(),));

                          },
                          child: const Text(
                            'Send Message',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
  //----
  //----contact function
 
