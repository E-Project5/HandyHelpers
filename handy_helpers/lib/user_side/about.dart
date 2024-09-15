import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "About Us",
    home: About(),
  ));
}

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight * 0.3, // 30% of screen height
              child: Stack(
                children: [
                  // Background image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/2.PNG',
                      //  'assets/images/about.PNG',
                      fit: BoxFit.cover,
                      width: screenWidth,
                      height: screenHeight * 0.3,
                    ),
                  ),
                  // Overlay text
                  Positioned(
                    top: 30,
                    left: screenWidth * 0.25,
                    right: screenWidth * 0.25,
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Center(
                        child: Text(
                          'About Us',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heading
                  Text(
                    'ABOUT OUR COMPANY',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0), // Space between heading and body

                  // Subheading
                  Text(
                    'More than 10 years of cleaning experience',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: const Color.fromARGB(255, 43, 42, 42),
                    ),
                  ),
                  SizedBox(height: 16.0), // Space between subheading and body

                  // Body text
                  Text(
                    'The Cleaner is a fully integrated Rapid cleaning services company that provides comprehensive, high-quality, reliable cleaning solutions to commercial, corporate, industrial and residential clients. We are committed to ensuring your home is not only clean but also a healthier environment for you and your loved ones.',
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "A New Solution For Your Home Help",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: MissionAndValuesCards(),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class MissionAndValuesCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * 0.28; // 28% of screen width
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCard(
              image: "assets/images/mission.png",
              title: 'Mission',
              description: 'High-quality cleaning services.',
              cardWidth: cardWidth,
            ),
            _buildCard(
              image: "assets/images/vission.png",
              title: 'Vision',
              description: 'Leading nationwide cleaning.',
              cardWidth: cardWidth,
            ),
            _buildCard(
              image: "assets/images/values.png",
              title: 'Values',
              description: ' Respect, Integrity,      Innovation.',
              cardWidth: cardWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(
      {required String image,
      required String title,
      required String description,
      required double cardWidth}) {
    return Container(
      width: cardWidth,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image,
                  width: cardWidth * 0.6), // Adjust size to fit card
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
