import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_app/screens/cart_screen.dart';
import 'package:tailor_app/screens/home_screen.dart';
import 'account/account_screen.dart';

class ControllerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ControllerScreenState();
  }
}

class _ControllerScreenState extends State<ControllerScreen> {
  var currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return buildUI(context);
  }

  Widget buildUI(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.redAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Colors.white),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.shopping_cart, color: Colors.white),
            icon: Icon(Icons.shopping_cart),
            label: 'My Cart',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person, color: Colors.white),
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
      body: <Widget>[
        HomeScreen(),
        CartScreen(),
        AccountScreen(),
      ][currentPageIndex],
    );
  }
}
