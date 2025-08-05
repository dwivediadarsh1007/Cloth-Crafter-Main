import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tailor_app/constants.dart';
import 'package:tailor_app/screens/order_dress_screen.dart';
import 'package:tailor_app/screens/search_tailor_screen.dart'; // Import the OrderDressScreen

class DressCollectionScreen extends StatefulWidget {
  const DressCollectionScreen({super.key});

  @override
  State<DressCollectionScreen> createState() => _DressCollectionScreenState();
}

class _DressCollectionScreenState extends State<DressCollectionScreen> {
  List<dynamic> dresses = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDressCollection();
  }

  Future<void> fetchDressCollection() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/products'));
      if (response.statusCode == 200) {
        setState(() {
          dresses = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load dress collection. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching dress collection: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      appBar: AppBar(title: Row(
        children: [
          Text("Dress Collection"),
        ],
      )),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: dresses.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                print('Dress Id Tapped: ${dresses[index]["product_id"]}'); // Corrected ID access

                // Navigate to the OrderDressScreen and pass the dress ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDressScreen(dressId: dresses[index]["product_id"]), // Use "product_id"
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                        child: Image.network(
                          dresses[index]["image"],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(dresses[index]["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text("${dresses[index]["cost"]} Rs.", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
