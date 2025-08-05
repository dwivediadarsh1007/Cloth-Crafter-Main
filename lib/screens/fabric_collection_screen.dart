import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tailor_app/constants.dart';
import 'order_fabric_screen.dart'; // Import the OrderFabricScreen

class FabricCollectionScreen extends StatefulWidget {
  const FabricCollectionScreen({super.key});

  @override
  State<FabricCollectionScreen> createState() => _FabricCollectionScreenState();
}

class _FabricCollectionScreenState extends State<FabricCollectionScreen> {
  List<dynamic> fabrics = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchFabrics();
  }

  Future<void> fetchFabrics() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/fabric')); // Adjust your API URL

      if (response.statusCode == 200) {
        setState(() {
          fabrics = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load fabrics. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching fabrics: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fabric Collection"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: fabrics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                print('fabric id tapped ');
                print(fabrics[index]['fabric_id']);
                // Navigate to OrderFabricScreen with fabric ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderFabricScreen(fabricId: fabrics[index]['fabric_id']),
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
                          fabrics[index]['image'],  // Use the image URL from API
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
                            Text(
                              fabrics[index]['name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${fabrics[index]['cost'] } Rs.',
                              style: TextStyle(color: Colors.grey),
                            ),
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
