import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handy_helpers/admin/dashboard.dart';
import 'package:handy_helpers/start/screens/forget_passsword_screen.dart';
import 'package:handy_helpers/start/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:handy_helpers/services/database_conn.dart';
import 'package:handy_helpers/user_side/side.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Mainscreen(
      page: "signup",
    ),
  ));
}

class Mainscreen extends StatefulWidget {
  String? page;
  Mainscreen({required this.page});

  @override
  _MainscreenState createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  bool pswdisHidden = true;
  //----controllers
  // ignore: non_constant_identifier_names
  TextEditingController login_email = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController login_pwd = TextEditingController();
  //---controllers
  bool pswdisHiddenText = true;
  bool cpswdisHiddenText = true;

  // ignore: non_constant_identifier_names
  TextEditingController txt_email = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController phone = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController txt_pwd = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController txt_cpwd = TextEditingController();
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.page = "signin";
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(30.0),
                          decoration: BoxDecoration(
                            color: widget.page == "signin"
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                          child: Text(
                            'Sign in',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: widget.page == "signin"
                                  ? lightColorScheme.primary
                                  : Colors.white,
                            ),
                          ),
                        ),
                      )),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.page = "signup";
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(30.0),
                          decoration: BoxDecoration(
                            color: widget.page == "signup"
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(60),
                            ),
                          ),
                          child: Text(
                            'Sign up',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: widget.page == "signup"
                                  ? lightColorScheme.primary
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: widget.page == "signup" ? 80 : 150,
                  ),
                  widget.page == "signup"
                      ? Container(
                          child: Expanded(
                            flex: 7,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                  25.0, 30.0, 25.0, 0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.0),
                                  topRight: Radius.circular(40.0),
                                ),
                              ),
                              child: SingleChildScrollView(
                                // get started form
                                child: Form(
                                  key: _formSignupKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // get started text
                                      Text(
                                        'Get Started',
                                        style: TextStyle(
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.w900,
                                          color: lightColorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30.0,
                                      ),
                                      // full name
                                      TextFormField(
                                        controller: fullname,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Full name';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.person),
                                          label: const Text('Full Name'),
                                          hintText: 'Enter Full Name',
                                          hintStyle: const TextStyle(
                                            color: Colors.black26,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors
                                                  .black12, // Default border color
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors
                                                  .black12, // Default border color
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      //PHONE
                                      TextFormField(
                                        controller: phone,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Full name';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.phone),
                                          label: const Text('Phone'),
                                          hintText: 'Enter Contact number',
                                          hintStyle: const TextStyle(
                                            color: Colors.black26,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors
                                                  .black12, // Default border color
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors
                                                  .black12, // Default border color
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      // email
                                      TextFormField(
                                        controller: txt_email,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Email';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.email),
                                          label: const Text('Email'),
                                          hintText: 'Enter Email',
                                          hintStyle: const TextStyle(
                                            color: Colors.black26,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors
                                                  .black12, // Default border color
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors
                                                  .black12, // Default border color
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      // password
                                      TextFormField(
                                        controller: txt_pwd,
                                        obscureText: pswdisHiddenText,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Password';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                if (pswdisHiddenText == true) {
                                                  pswdisHiddenText = false;
                                                } else {
                                                  pswdisHiddenText = true;
                                                }
                                                setState(() {});
                                              },
                                              icon: pswdisHiddenText
                                                  ? Icon(Icons.visibility)
                                                  : Icon(Icons.visibility_off)),
                                          label: const Text('Password'),
                                          hintText: 'Enter Password',
                                          hintStyle: const TextStyle(
                                            color: Colors.black26,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors
                                                  .black12, // Default border color
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors
                                                  .black12, // Default border color
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      //confirm password
                                      TextFormField(
                                        controller: txt_cpwd,
                                        obscureText: cpswdisHiddenText,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter confirm password';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                if (cpswdisHiddenText == true) {
                                                  cpswdisHiddenText = false;
                                                } else {
                                                  cpswdisHiddenText = true;
                                                }
                                                setState(() {});
                                              },
                                              icon: cpswdisHiddenText
                                                  ? Icon(Icons.visibility)
                                                  : Icon(Icons.visibility_off)),
                                          label: const Text('Confirm Password'),
                                          hintText: 'Enter Confirm Password',
                                          hintStyle: const TextStyle(
                                            color: Colors.black26,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors
                                                  .black12, // Default border color
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors
                                                  .black12, // Default border color
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),

                                      // i agree to the processing
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: agreePersonalData,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                agreePersonalData = value!;
                                              });
                                            },
                                            activeColor:
                                                lightColorScheme.primary,
                                          ),
                                          const Text(
                                            'I agree to the processing of ',
                                            style: TextStyle(
                                              color: Colors.black45,
                                            ),
                                          ),
                                          Text(
                                            'Personal data',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: lightColorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      // signup button
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_formSignupKey.currentState!
                                                    .validate() &&
                                                agreePersonalData) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content:
                                                      Text('Processing Data'),
                                                ),
                                              );
                                              createAccount(context);
                                            } else if (_formSignupKey
                                                    .currentState!
                                                    .validate() &&
                                                !agreePersonalData) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Please agree to the processing of personal data')),
                                              );
                                            }
                                            //---calling
                                          },
                                          child: const Text('Sign up'),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30.0,
                                      ),
                                      // sign up divider

                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          child: Expanded(
                            flex: 7,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                  25.0, 30.0, 25.0, 0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Welcome back',
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
                                        controller: login_email,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Email';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.email),
                                          label: const Text('Email'),
                                          hintText: 'Enter Email',
                                          hintStyle: const TextStyle(
                                            color: Colors.black26,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors
                                                  .black12, // Default border color
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors
                                                  .black12, // Default border color
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      TextFormField(
                                        controller: login_pwd,
                                        obscureText: pswdisHidden,
                                        obscuringCharacter: '*',
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Password';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                if (pswdisHidden == true) {
                                                  pswdisHidden = false;
                                                } else {
                                                  pswdisHidden = true;
                                                }
                                                setState(() {});
                                              },
                                              icon: pswdisHidden
                                                  ? Icon(Icons.visibility)
                                                  : Icon(Icons.visibility_off)),
                                          label: const Text('Password'),
                                          hintText: 'Enter Password',
                                          hintStyle: const TextStyle(
                                            color: Colors.black26,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors
                                                  .black12, // Default border color
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors
                                                  .black12, // Default border color
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: rememberPassword,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    rememberPassword = value!;
                                                  });
                                                },
                                                activeColor:
                                                    lightColorScheme.primary,
                                              ),
                                              const Text(
                                                'Remember me',
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (e) =>
                                                        const ForgetPasswordScreen(),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Forget password?',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      lightColorScheme.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_formSignInKey.currentState!
                                                .validate()) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content:
                                                    Text('Processing Data'),
                                              ));
                                              login();
                                            }
                                          },
                                          child: const Text('Sign up'),
                                        ),
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
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void createAccount(BuildContext context) async {
    String userEmail = txt_email.text.trim();
    String userPwd = txt_pwd.text.trim();
    String userCpwd = txt_cpwd.text.trim();

    //-----if else
    if (userEmail == "" || userPwd == "" || userCpwd == "") {
      // print("Plz fill all fields");

      Fluttertoast.showToast(
          msg: "Plz fill all fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (userPwd != userCpwd) {
      // print("Password does not match");

      Fluttertoast.showToast(
          msg: "Password does not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      // print("all ok!!!");

      //----try catch and credetials
      try {
        UserCredential usercred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: userEmail, password: userPwd);
        String uid = usercred.user!.uid;
        // String u_id = randomAlphaNumeric(10);
        Map<String, dynamic> userdata = {
          "Id": uid,
          "Fullname": fullname.text,
          "email": txt_email.text,
          "contact": phone.text,
          "address": "",
          "status": "logged_out",
          "image": fullname.text.toUpperCase().substring(0, 1),
          "aggrement": false
        };

        await databasemodel().add_user(userdata, uid);
        //
        // Send verification email
        await usercred.user?.sendEmailVerification();

        // Show confirmation dialog
        bool isEmailVerified = false;

        // Show the dialog
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent closing the dialog
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Email Verification'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'A verification link has been sent to your email. Please verify your email before logging in.'),
                  SizedBox(height: 20),
                  CircularProgressIndicator(), // Show a loading spinner
                ],
              ),
              actions: [
                // No 'OK' button to close the dialog manually
              ],
            );
          },
        );

        // Periodically check if the email is verified
        while (!isEmailVerified) {
          await Future.delayed(Duration(seconds: 5)); // Check every 5 seconds

          User? user = FirebaseAuth.instance.currentUser;
          await user?.reload(); // Reload user data
          isEmailVerified =
              user?.emailVerified ?? false; // Check verification status

          if (isEmailVerified) {
            // Close the dialog and navigate to the login page
            Navigator.of(context).pop(); // Close the dialog

            Fluttertoast.showToast(
              msg: "Email verified. You can now log in.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );

            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Mainscreen(page: "signin"),
            ));
          }
        }
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(msg: e.code.toString());
      }
    }
  }

//----
  //----login function
  void login() async {
    String logE = login_email.text.trim();
    String logP = login_pwd.text.trim();
    if (logE == "admin" && logP == "admin") {
      //-----shared prefernces
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("login", "admin"); //set key according to
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => dashboard(page: 0),
          ));
    } else {
      try {
        UserCredential userLogin = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: logE, password: logP);

        if (userLogin.user != null) {
          if (userLogin.user?.emailVerified ?? false) {
            String userId = userLogin.user!.uid;
            print(userId);
            //         // Update the user's status in Firestore to "logged_in"
            await FirebaseFirestore.instance
                .collection('User')
                .doc(userId)
                .update({
              'status': 'logged_in',
            });

            //-----shared prefernces
            SharedPreferences sp = await SharedPreferences.getInstance();
            sp.setString("login", userId);
            //----move to dashboard
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Side(
                    userId: userId,
                  ),
                ));
          } else {
            // Send verification email
            await userLogin.user?.sendEmailVerification();

            // Show confirmation dialog
            bool isEmailVerified = false;
            showDialog(
              context: context,
              barrierDismissible: false, // Prevent closing the dialog
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Email Verification'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          "Your Email isn't verify yet . Again a verification link has been sent to your email. Please verify your email before logging in."),
                      SizedBox(height: 20),
                      CircularProgressIndicator(), // Show a loading spinner
                    ],
                  ),
                  actions: [
                    // No 'OK' button to close the dialog manually
                  ],
                );
              },
            );

            // Periodically check if the email is verified
            while (!isEmailVerified) {
              await Future.delayed(
                  Duration(seconds: 5)); // Check every 5 seconds

              User? user = FirebaseAuth.instance.currentUser;
              await user?.reload(); // Reload user data
              isEmailVerified =
                  user?.emailVerified ?? false; // Check verification status

              if (isEmailVerified) {
                // Close the dialog and navigate to the login page
                Navigator.of(context).pop(); // Close the dialog

                Fluttertoast.showToast(
                  msg: "Email verified. You can now log in.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );

                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Mainscreen(page: "signin"),
                ));
              }
            }
          }
        }
      } on FirebaseException catch (e) {
        Fluttertoast.showToast(msg: e.code.toString());
      }
    }
  }
}
