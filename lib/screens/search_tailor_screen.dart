import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TailorSearchScreen extends StatefulWidget {
  @override
  _TailorSearchScreenState createState() => _TailorSearchScreenState();
}

class _TailorSearchScreenState extends State<TailorSearchScreen> {
  bool isTailorSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              isTailorSelected ? 'Search Tailors' : 'Search Boutiques',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toggle buttons for Tailor and Boutique
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isTailorSelected = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: isTailorSelected ? Colors.black : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Tailor',
                          style: TextStyle(
                            color: isTailorSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isTailorSelected = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: !isTailorSelected ? Colors.black : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Boutique',
                          style: TextStyle(
                            color: !isTailorSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Search bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: isTailorSelected ? 'Search Tailors' : 'Search Boutiques',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Display either Tailor or Boutique based on selection
            Expanded(
              child: isTailorSelected ? buildTailorList() : buildBoutiqueList(),
            ),
          ],
        ),
      ),
    );
  }

  // Tailor List
  Widget buildTailorList() {
    return ListView(
      children: [
        buildTailorCard(
          name: 'Shyam Lal Sharma',
          rating: 5,
          specialization: 'Kurti',
          address: 'Saket Nagar',
        ),
        buildTailorCard(
          name: 'Rohan Sharma',
          rating: 5,
          specialization: 'Suiting',
          address: 'LIG',
        ),
      ],
    );
  }

  // Boutique List
  Widget buildBoutiqueList() {
    return ListView(
      children: [
        buildBoutiqueCard(
          name: 'RadhaRani Boutique',
          rating: 5,
          address: 'Saket Nagar',
        ),
        buildBoutiqueCard(
          name: 'Rohan Sharma Boutique',
          rating: 5,
          address: 'LIG',
        ),
      ],
    );
  }

  // Tailor card
  Widget buildTailorCard({required String name, required int rating, required String specialization, required String address}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 40, color: Colors.black),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Row(
                children: [
                  Text('Rating: '),
                  Row(
                    children: List.generate(
                      rating,
                          (index) => Icon(Icons.star, color: Colors.amber, size: 16),
                    ),
                  ),
                ],
              ),
              Text('Specialization: $specialization'),
              Text('Address: $address'),
            ],
          ),
        ],
      ),
    );
  }

  // Boutique card
  Widget buildBoutiqueCard({required String name, required int rating, required String address}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.store, size: 40, color: Colors.black),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Row(
                children: [
                  Text('Rating: '),
                  Row(
                    children: List.generate(
                      rating,
                          (index) => Icon(Icons.star, color: Colors.amber, size: 16),
                    ),
                  ),
                ],
              ),
              Text('Address: $address'),
            ],
          ),
        ],
      ),
    );
  }
}
