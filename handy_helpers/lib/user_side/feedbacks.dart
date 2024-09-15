import 'package:flutter/material.dart';

import 'package:slide_rating_dialog/slide_rating_dialog.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'feedback ',
    home: rating(
      title: 'rating',
    ),
  ));
}

class rating extends StatefulWidget {
  const rating({super.key, required this.title});

  final String title;

  @override
  State<rating> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<rating> {
  // Create List which store string and this strings show below faces.
  List<String> list = [
    'Worst',
    'Not Good',
    'Good',
    'Excellent',
    'Out Standing'
  ];
  String selected_value = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext cont) => SlideRatingDialog(
                          onRatingChanged: (rating) {
                            // if (rating.toString() == "1") {
                            //   print("Worst");
                            // }
                            selected_value = list[rating.toInt()];
                            print(selected_value);
                            print(rating.toString());
                          },
                          buttonOnTap: () {
                            // Do your Business Logic here;
                          },
                        ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 48.0,
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(12.0)),
                alignment: Alignment.center,
                child: const Text(
                  "Show Dialog",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
