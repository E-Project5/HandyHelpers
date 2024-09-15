import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "FAQ",
    home: Faq(),
  ));
}
// getwidget: ^2.0.4

class Faq extends StatefulWidget {
  const Faq({Key? key}) : super(key: key);

  @override
  _FaqState createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        actions: [
          // GFAvatar(
          //   backgroundImage: AssetImage("images/pg2.png"),
          // )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // SizedBox(
            //   height: 20,
            // ),
            Container(
              height: 200,
              // color: const Color.fromARGB(255, 218, 216, 211),
              child: Center(
                child: RichText(
                    text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'FREQUENTLY \n',
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ),

                    //  SizedBox(height: 4,),
                    TextSpan(
                      text: 'ASKED ',
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ),
                    TextSpan(
                      text: 'QUESTIONS',
                      style: TextStyle(color: Colors.blue, fontSize: 30),
                    ),
                  ],
                )),
              ),
//
            ),
            SingleChildScrollView(
              child: Container(
                child: GFAccordion(
                  collapsedIcon: Icon(Icons.arrow_drop_down),
                  expandedIcon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  contentBackgroundColor: Color.fromRGBO(243, 244, 247, 0.2),
                  contentBorder: Border.all(
                    color: const Color.fromRGBO(77, 107, 179, 1),
                  ),
                  collapsedTitleBackgroundColor:
                      Color.fromRGBO(236, 236, 237, 0.6),
                  title: "What Residential Services Do You Offer?",
                  content:
                      "We can provide you with a variety of residential cleaning services, from one-time cleanings to weekly cleanings. You can also count on us to help you clean your apartment if you are moving in or out. After meeting with our team, you can be sure that we will clean your home according to your specifications, every time!",
                ),
              ),
            ),
            Container(
              child: GFAccordion(
                  collapsedIcon: Icon(Icons.arrow_drop_down),
                  expandedIcon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  contentBackgroundColor: Color.fromRGBO(243, 244, 247, 0.2),
                  contentBorder: Border.all(
                    color: const Color.fromRGBO(77, 107, 179, 1),
                  ),
                  collapsedTitleBackgroundColor:
                      Color.fromRGBO(236, 236, 237, 0.6),
                  title: "What Types of Cleaning Products Do You Use?",
                  content:
                      "Many of our clients are concerned about the quality of cleaning products we use. You can discuss your specific cleaning needs with us, but you can trust that we use our own safe, eco-friendly cleaning products."),
            ),
            Container(
              child: GFAccordion(
                collapsedIcon: Icon(Icons.arrow_drop_down),
                expandedIcon: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                contentBackgroundColor: Color.fromRGBO(243, 244, 247, 0.2),
                contentBorder: Border.all(
                  color: const Color.fromRGBO(77, 107, 179, 1),
                ),
                collapsedTitleBackgroundColor:
                    Color.fromRGBO(236, 236, 237, 0.6),
                title: "Are Your Cleaning Staff Members Trustworthy?",
                content:
                    "Absolutely. The responsibility we take on when we are allowed into your home is not something we take lightly, and we go above and beyond to ensure that you and your home are safe in the hands of any of our employees. We screen all of our Elite cleaning staff before hiring them to be certain they are trustworthy. Our employees are also given additional training to ensure they meet our high standard",
              ),
            ),
            Container(
              child: GFAccordion(
                collapsedIcon: Icon(Icons.arrow_drop_down),
                expandedIcon: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                contentBackgroundColor: Color.fromRGBO(243, 244, 247, 0.2),
                contentBorder: Border.all(
                  color: const Color.fromRGBO(77, 107, 179, 1),
                ),
                collapsedTitleBackgroundColor:
                    Color.fromRGBO(236, 236, 237, 0.6),
                title: "How can I book a cleaning service?",
                content:
                    "Booking a service is easy! You can book through our app or website. Simply select your desired service, choose a convenient time slot, and provide your contact details. You will receive a confirmation and reminder before the scheduled date.",
              ),
            ),
            Container(
              child: GFAccordion(
                collapsedIcon: Icon(Icons.arrow_drop_down),
                expandedIcon: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                contentBackgroundColor: Color.fromRGBO(243, 244, 247, 0.2),
                contentBorder: Border.all(
                  color: const Color.fromRGBO(77, 107, 179, 1),
                ),
                collapsedTitleBackgroundColor:
                    Color.fromRGBO(236, 236, 237, 0.6),
                title: "Can I reschedule or cancel my booking?",
                content:
                    "Yes, you can reschedule or cancel your booking through our app or by contacting our customer support. Please note that cancellations made within 24 hours of the scheduled service may incure a cancellation fee.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
