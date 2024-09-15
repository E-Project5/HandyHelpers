import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handy_helpers/user_side/detail.dart';

class SearchResultsPage extends StatefulWidget {
  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  Stream<QuerySnapshot>? _searchResults;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Request focus after the widget build is complete
      _focusNode.requestFocus();
    });
  }

  void _onSearchChanged() {
    setState(() {
      _searchResults = FirebaseFirestore.instance
          .collection('Services')
          .where('Service_title',
              isGreaterThanOrEqualTo: _searchController.text)
          .where('Service_title',
              isLessThanOrEqualTo: _searchController.text + '\uf8ff')
          .snapshots();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 50,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                focusNode: _focusNode,
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: "Search...",
                    suffixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Color.fromARGB(123, 200, 201, 201),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    )),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No results found'));
                  }

                  var results = snapshot.data!.docs;

                  return ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      var data = results[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['Service_title']),
                        leading: Image.network(data['Service_icon']),
                        subtitle: Text("Price: PKR ${data['Service_price']}"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Detail(service_id: data['Id']),
                              ));
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
