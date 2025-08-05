import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildOrderItem(
              imagePath: 'assets/images/dress_jeans.jpg',
              title: 'Classic Jeans',
              orderDate: '2024-07-01',
              receiveDate: '2024-07-05',
              status: 'Delivered',
            ),
            SizedBox(height: 20),
            buildOrderItem(
              imagePath: 'assets/images/dress_western_classic.jpg',
              title: 'Western Dress Classic',
              orderDate: '2024-07-10',
              receiveDate: '2024-07-15',
              status: 'Pending',
            ),
            SizedBox(height: 20),
            buildOrderItem(
              imagePath: 'assets/images/dress_silk_saree.jpg',
              title: 'Silk Saree',
              orderDate: '2024-07-12',
              receiveDate: '2024-07-17',
              status: 'Delivered',
            ),
            SizedBox(height: 20),
            buildOrderItem(
              imagePath: 'assets/images/dress_floral.jpg',
              title: 'Floral Dress',
              orderDate: '2024-07-20',
              receiveDate: '2024-07-25',
              status: 'Pending',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderItem({
    required String imagePath,
    required String title,
    required String orderDate,
    required String receiveDate,
    required String status,
  }) {
    const double imageSize = 60.0; // Set the image size to be consistent with ListTile

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            imagePath,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Date: $orderDate'),
            Text('Receive Date: $receiveDate'),
            Text(
              'Status: $status',
              style: TextStyle(
                color: status == 'Delivered' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: status == 'Pending'
            ? IconButton(
          icon: Icon(Icons.cancel, color: Colors.red),
          onPressed: () {
            _showCancelDialog(context);
          },
        )
            : null,
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Order'),
          content: Text('Are you sure you want to cancel this order?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Handle the order cancellation here
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
