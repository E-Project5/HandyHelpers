import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handy_helpers/user_side/side.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Agreement",
    home: Agreement_page(),
  ));
}

class Agreement_page extends StatefulWidget {
  bool? aggrement_accepted;
 Agreement_page({ this.aggrement_accepted});

  @override
  _AgreementState createState() => _AgreementState();
}

class _AgreementState extends State<Agreement_page> {
  bool _isAccepted = false;

  void _Acceptance(bool? value) {
    setState(() {
      _isAccepted = value ?? false;
    });
  }
   String? checking;
  chek_login() async {
    SharedPreferences shared = await SharedPreferences.getInstance();

    setState(() {
      checking = shared.getString("login");
      print(checking);
    });
  }
@override
  void initState() {
   chek_login();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 237, 233, 233),
        title: Text('Terms and Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terms and Conditions',
                      style: TextStyle(color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    //text
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Welcome to ',
                            style: TextStyle(color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: 'Handy Helpers',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromRGBO(77, 107, 179, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                '. By using our app, you agree to the following terms and conditions:',
                            style: TextStyle(color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '1. ',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text: 'Service Agreement\n\n',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text:
                                '   a. Our home cleaning services include regular cleaning, deep cleaning, and specialized cleaning of residential properties. The specifics of the service, including scheduling, scope, and any special requirements, will be detailed in the service agreement prior to booking.\n',
                            style: TextStyle(color: Colors.black,fontSize: 14, height: 1.5),
                          ),
                          TextSpan(
                            text:
                                '   b. Any additional services requested outside the original agreement, such as move-in/move-out cleaning or post-renovation cleaning, may incur additional charges.\n\n',
                            style: TextStyle(color: Colors.black,fontSize: 14, height: 1.5),
                          ),
                          TextSpan(
                            text: '2. ',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text: 'Payment Terms\n\n',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text:
                                '   a. Payment is due upon completion of the service. We accept various payment methods including credit cards, debit cards, and digital wallets.\n',
                            style: TextStyle(color: Colors.black,fontSize: 14, height: 1.5),
                          ),
                          TextSpan(
                            text:
                                '   b. If payment is not made within the agreed time frame, a late fee may be applied.\n\n',
                            style: TextStyle(color: Colors.black,fontSize: 14, height: 1.5),
                          ),
                          TextSpan(
                            text: '3. ',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text: 'Cancellations\n\n',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text:
                                '   a. You may cancel or reschedule your cleaning service up to 24 hours before the scheduled time without any penalty.\n',
                            style: TextStyle(color: Colors.black,fontSize: 14, height: 1.5),
                          ),
                          TextSpan(
                            text:
                                '   b. Cancellations made less than 24 hours before the service will incur a cancellation fee equal to 50% of the scheduled service cost.\n\n',
                            style: TextStyle(color: Colors.black,fontSize: 14, height: 1.5),
                          ),
                          TextSpan(
                            text: '4. ',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text: 'Liability\n\n',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text:
                                '   a. We are not liable for any damages to property or personal items that occur during the cleaning process unless caused by our negligence.\n',
                            style: TextStyle(color: Colors.black,fontSize: 14, height: 1.5),
                          ),
                          TextSpan(
                            text:
                                '   b. Customers must inform us of any pre-existing damage or items requiring special care prior to the service.\n\n',
                            style: TextStyle(color: Colors.black,fontSize: 14, height: 1.5),
                          ),
                          TextSpan(
                            text: '5. ',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text: 'Privacy Policy\n\n',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text:
                                '   a. We protect your personal information, including contact and payment details, and use it only in accordance with our privacy policy.\n',
                            style: TextStyle(color: Colors.black,fontSize: 14, height: 1.5),
                          ),
                          TextSpan(
                            text:
                                '   b. We do not share your information with third parties without your consent, except as required by law.\n\n',
                            style: TextStyle(color: Colors.black,fontSize: 14, height: 1.5),
                          ),
                          TextSpan(
                            text: '6. ',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text: 'Modifications\n\n',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text:
                                '   a. We reserve the right to modify these terms and conditions at any time. Changes will be communicated through the app or via email.\n',
                            style: TextStyle(color: Colors.black,fontSize: 14, height: 1.5),
                          ),
                          TextSpan(
                            text:
                                '   b. Continued use of our services after modifications signifies acceptance of the new terms.\n\n',
                            style: TextStyle(color: Colors.black,fontSize: 14, height: 1.5),
                          ),
                          TextSpan(
                            text: '7. ',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text: 'Governing Law\n\n',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text:
                                '   a. These terms are governed by the laws of [Your Country/State].\n',
                            style: TextStyle(color: Colors.black,fontSize: 14, height: 1.5),
                          ),
                          TextSpan(
                            text:
                                '   b. Any disputes arising from these terms will be resolved in the competent courts of Karachi.\n\n',
                            style: TextStyle(color: Colors.black,fontSize: 14, height: 1.5),
                          ),
                          TextSpan(
                            text: '8. ',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text: 'Contact Information\n\n',
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextSpan(
                            text:
                                '   a. For any questions or concerns regarding these terms and conditions, please contact us at studentsaptech0@gmail.com.\n',
                            style: TextStyle(color: Colors.black,fontSize: 14, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                     widget.aggrement_accepted == false ?  
                     Column(
                      children: [
                          SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _isAccepted,
                          onChanged: _Acceptance,
                        ),
                        Expanded(
                          child: Text(
                            'I have read and agree to the Terms and Conditions',
                            style: TextStyle(color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                      ],
                     ): SizedBox(height: 10,),
                  
                  ],
                ),
              ),
            ),
             widget.aggrement_accepted == false ?            
            Column(
              children: [
            SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(77, 107, 179, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  onPressed: _isAccepted
                      ? () async {
                          await FirebaseFirestore.instance
                              .collection('User')
                              .doc(checking)
                              .update({
                            'aggrement': 'true',
                          });
                          // Handle the accept action
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Terms Accepted')),
                          );
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Side(),));
                        }
                      : null, // Disable button if not accepted
                  child: Text(
                    'Accept Terms and Conditions',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            )
           :
            SizedBox(height: 10),
         
          ],
        ),
      ),
    );
  }
}
