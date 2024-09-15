import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:handy_helpers/admin/dashboard.dart';
import 'package:handy_helpers/start/screens/onboard.dart';
import 'package:handy_helpers/user_side/side.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  bool isinitialize = false;
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAasYmWQBIz57Towi89oRRBx-ZQ6YlwmC0",
            appId: "1:248221189596:android:6ff853b039f1580270bb19",
            storageBucket: "handyhelpers-5f587.appspot.com",
            messagingSenderId: "248221189596",
            projectId: "handyhelpers-5f587"));
    isinitialize = true;
  } catch (exception) {
    print("Erroe for Connection ${exception}");
    isinitialize = false;
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Main_page(
      connection: isinitialize,
    ),
  ));
}

// ignore: must_be_immutable
class Main_page extends StatefulWidget {
  bool connection;
  Main_page({required this.connection});

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main_page> {
  String? checking;
  chek_login() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    checking = shared.getString("login");
    setState(() {});
  }

  String? timecheck = null;
  @override
  void initState() {
    chek_login();
    Timer(Duration(seconds: 5), () {
      timecheck = "Change the page";
      setState(() {
        
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: timecheck == "null"
          ? Stack(children: [
              Image.asset(
                "assets/images/bg1.png",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Color.fromARGB(115, 6, 221, 232),
              ),
              Center(
                  child: Lottie.asset("assets/lottie_files/Main_Scene.json",
                      width: 300, height: 300))
            ])
          : widget.connection && checking == null
              ? Onboarding()
              // ? Detail(service_id: "0379925697",)
              : widget.connection && checking == "admin"
                  ? dashboard(
                      page: 0,
                    )
                  : widget.connection && checking != "admin"
                      ? Side()
                      // ?OrderDetails(order_ID: "1695968U48")

                      : Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 200,
                        ),
    );
  }
}
