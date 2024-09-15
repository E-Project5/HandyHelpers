import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:handy_helpers/start/widgets/custom_scaffold.dart';
import 'package:handy_helpers/start/theme/theme.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _sendPasswordResetEmail() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your email",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
       bool emailExists = await _checkEmailExists(email);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
       if (emailExists) {
        // Attempt to send the password reset email
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        Fluttertoast.showToast(
          msg:
              "A reset link has been sent.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pop(context); // Go back to the login page
      } else {
        Fluttertoast.showToast(
          msg: "No account associated with this email.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? "Failed to send password reset email.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
   Future<bool> _checkEmailExists(String email) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('User') // Collection name in Firestore
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return result.docs.isNotEmpty;
    } catch (e) {
      // Handle error (e.g., network issues)
      print(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
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
                  // key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Reset Account Pasword',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Enter your Email we will send you a link for resting your password',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                          color: Color.fromARGB(255, 2, 2, 2),
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      //----password field
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter correct email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Enter correct email',
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _sendPasswordResetEmail();
                          },
                          child: const Text('Send Email'),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Expanded(
                      //       child: Divider(
                      //         thickness: 0.7,
                      //         color: Colors.grey.withOpacity(0.5),
                      //       ),
                      //     ),
                      //     const Padding(
                      //       padding: EdgeInsets.symmetric(
                      //         vertical: 0,
                      //         horizontal: 10,
                      //       ),
                      //       child: Text(
                      //         'Sign up with',
                      //         style: TextStyle(
                      //           color: Colors.black45,
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Divider(
                      //         thickness: 0.7,
                      //         color: Colors.grey.withOpacity(0.5),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 25.0,
                      // ),

                      const SizedBox(
                        height: 25.0,
                      ),
                      // don't have an account
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     const Text(
                      //       'Don\'t have an account? ',
                      //       style: TextStyle(
                      //         color: Colors.black45,
                      //       ),
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {

                      //       },
                      //       child: Text(
                      //         'Sign up',
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           color: lightColorScheme.primary,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 20.0,
                      // ),
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
