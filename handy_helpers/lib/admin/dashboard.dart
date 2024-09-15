import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:handy_helpers/admin/add_category.dart';
import 'package:handy_helpers/admin/add_services.dart';
import 'package:handy_helpers/admin/admin_home.dart';
import 'package:handy_helpers/admin/show_category.dart';
import 'package:handy_helpers/admin/show_services.dart';
import 'package:handy_helpers/admin/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:handy_helpers/admin/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handy_helpers/start/screens/mainscreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Dashboard',
    theme: ThemeData(
      primarySwatch: Colors.indigo,
    ),
    home: dashboard(
      page: 0,
    ),
  ));
}

class dashboard extends StatefulWidget {
  int? page;
  dashboard({required this.page});
  @override
  State<dashboard> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<dashboard> {
  bool isSidebarOpen = false;
  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    print(screenwidth);
    return Scaffold(
      backgroundColor: Color.fromRGBO(226, 233, 249, 1),
      body: Stack(
        children: [
          Container(
              height: screenheight,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 80, 50, 0),
              child: widget.page == 0
                  ? AdminHome()
                  : widget.page == 1
                      ? ShowCategory()
                      : widget.page == 2
                          ? AddCategory()
                          : widget.page == 3
                              ? AddServices()
                              : widget.page == 4
                                  ? ShowServices()
                                  : widget.page == 5
                                      ? Orders()
                                      : widget.page == 6
                                          ? Users()
                                          : null),
          Container(
            height: 150,
            padding: EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Dashboard",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[900]),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            top: 0,
            bottom: 0,
            right: isSidebarOpen ? 0 : -screenwidth,
            left: isSidebarOpen ? 0 : screenwidth - 80,
            child: Row(
              children: [
                Align(
                  alignment: Alignment(5, -0.95),
                  child: Container(
                      width: isSidebarOpen ? 20 : 60,
                      height: isSidebarOpen ? double.infinity : 60,
                      decoration: BoxDecoration(
                          color:
                              !isSidebarOpen ? Colors.blue[900] : Colors.white,
                          borderRadius: !isSidebarOpen
                              ? BorderRadius.only(
                                  bottomLeft: Radius.circular(100),
                                  topLeft: Radius.circular(100))
                              : null),
                      child: !isSidebarOpen
                          ? Center(
                              child: IconButton(
                              onPressed: () {
                                // isSidebarOpen ?
                                //  isSidebarOpen = false
                                // :
                                isSidebarOpen = true;
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            ))
                          : null),
                ),
                Expanded(
                    child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 30),
                      color: Colors.blue[900],
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                "A",
                                style: TextStyle(
                                    color: Colors.blue[900], fontSize: 30),
                              ),
                              radius: 40,
                            ),
                            title: Text(
                              "Admin",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Divider(
                            indent: 30,
                            endIndent: 30,
                            height: 50,
                            thickness: 0.5,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    child: ListTile(
                                      leading: Icon(Icons.dashboard_outlined,
                                          color: Colors.white),
                                      title: Text(
                                        "Dashboard",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      onTap: () {
                                        widget.page = 0;
                                        isSidebarOpen = false;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  Divider(
                                    indent: 30,
                                    endIndent: 30,
                                    height: 50,
                                    thickness: 0.5,
                                    color: Colors.white,
                                  ),
                                    ExpansionTile(
                                    collapsedIconColor: Colors.white,
                                    iconColor: Colors.white,
                                    leading: Icon(Icons.category_outlined,
                                        color: Colors.white),
                                    title: Text(
                                      "Category",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    children: [
                                      Container(
                                        child: ListTile(
                                          leading: Icon(Icons.add,
                                              color: Colors.white),
                                          title: Text(
                                            "Add Category",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                          onTap: () {
                                            widget.page = 2;
                                            isSidebarOpen = false;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      Container(
                                        child: ListTile(
                                          leading: Icon(Icons.list,
                                              color: Colors.white),
                                          title: Text(
                                            "Category List",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                          onTap: () {
                                            widget.page = 1;
                                            isSidebarOpen = false;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    indent: 30,
                                    endIndent: 30,
                                    height: 50,
                                    thickness: 0.5,
                                    color: Colors.white,
                                  ),
                                  ExpansionTile(
                                    collapsedIconColor: Colors.white,
                                    iconColor: Colors.white,
                                    leading: Icon(Icons.bubble_chart,
                                        color: Colors.white),
                                    title: Text(
                                      "Services",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    children: [
                                      Container(
                                        child: ListTile(
                                          leading: Icon(Icons.add,
                                              color: Colors.white),
                                          title: Text(
                                            "Add Service",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                          onTap: () {
                                            widget.page = 3;
                                            isSidebarOpen = false;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      Container(
                                        child: ListTile(
                                          leading: Icon(Icons.list,
                                              color: Colors.white),
                                          title: Text(
                                            "Service List",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                          onTap: () {
                                            widget.page = 4;
                                            isSidebarOpen = false;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    indent: 30,
                                    endIndent: 30,
                                    height: 50,
                                    thickness: 0.5,
                                    color: Colors.white,
                                  ),
                                  ExpansionTile(
                                    collapsedIconColor: Colors.white,
                                    iconColor: Colors.white,
                                    leading: Icon(Icons.person_outline_rounded,
                                        color: Colors.white),
                                    title: Text(
                                      "Customers",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    children: [
                                      Container(
                                        child: ListTile(
                                          leading: Icon(
                                              Icons.account_circle_outlined,
                                              color: Colors.white),
                                          title: Text(
                                            "Users data",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                          onTap: () {
                                            widget.page = 6;
                                            setState(() {
                                              isSidebarOpen = false;
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                        child: ListTile(
                                          leading: Icon(Icons.feedback_outlined,
                                              color: Colors.white),
                                          title: Text(
                                            "Feedbacks",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                          onTap: () {
                                            isSidebarOpen = false;
                                          },
                                        ),
                                      ),
                                      Container(
                                        child: ListTile(
                                          leading: Icon(Icons.message_outlined,
                                              color: Colors.white),
                                          title: Text(
                                            "Messages",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                          onTap: () {
                                            isSidebarOpen = false;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    indent: 30,
                                    endIndent: 30,
                                    height: 50,
                                    thickness: 0.5,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    child: ListTile(
                                      leading: Icon(Icons.description,
                                          color: Colors.white),
                                      title: Text(
                                        "Orders",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      onTap: () {
                                        widget.page = 5;
                                        setState(() {
                                          isSidebarOpen = false;
                                        });
                                      },
                                    ),
                                  ),
                                  Divider(
                                    indent: 30,
                                    endIndent: 30,
                                    height: 50,
                                    thickness: 0.5,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    child: ListTile(
                                      leading: Icon(Icons.logout_outlined,
                                          color: Colors.white),
                                      title: Text(
                                        "Log out",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      onTap: () {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.warning,
                                          headerAnimationLoop: false,
                                          animType: AnimType.bottomSlide,
                                          title: 'Question',
                                          desc: 'Do you want to logout?',
                                          buttonsTextStyle: const TextStyle(
                                              color: Colors.black),
                                          showCloseIcon: true,
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () async {
                                            SharedPreferences shared =
                                                await SharedPreferences
                                                    .getInstance();
                                            shared.remove("login").then(
                                              (value) {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Mainscreen(
                                                                    page:
                                                                        "signin")));
                                              },
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text('admin logout'),
                                              ),
                                            );
                                          },
                                        ).show();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment(-1, -0.95),
                      child: Container(
                        // alignment:!isSidebarOpen ? Alignment(10, -0.9) : null,
                        height: 60,
                        width: 60,
                        //  color: Colors.blue[900],
                        decoration: BoxDecoration(
                            color: !isSidebarOpen
                                ? Colors.blue[900]
                                : Colors.white,
                            borderRadius: isSidebarOpen
                                ? BorderRadius.only(
                                    bottomRight: Radius.circular(100),
                                    topRight: Radius.circular(100))
                                : null),
                        //  color:  !isSidebarOpen ? Colors.blue[900] : Colors.white,
                        child: isSidebarOpen
                            ? IconButton(
                                onPressed: () {
                                  isSidebarOpen = false;
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.blue[900],
                                ))
                            : null,
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
