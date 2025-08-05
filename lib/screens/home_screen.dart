import 'package:flutter/material.dart';
import 'package:tailor_app/screens/account/measurement_controller.dart';
import 'package:tailor_app/screens/alter_clothes_screen.dart';
import 'package:tailor_app/screens/customize_clothes_screen.dart';
import 'package:tailor_app/screens/fabric_collection_screen.dart';
import 'package:tailor_app/screens/help_support_screen.dart';
import 'package:tailor_app/utility.dart';
import 'package:tailor_app/services/token_storage.dart';

import '../dress_collection_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    // Call the getUserDetails function from utility.dart
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    await getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.menu),
                    Row(
                      children: [
                        InkWell(
                            child: Icon(Icons.exit_to_app),
                          onTap: (){
                              print("logout button pressed");
                              var result=TokenStorage.clearToken();
                              if(result!=null){
                                Navigator.popAndPushNamed(context,'/login');
                              }

                          },
                        ),
                        SizedBox(width: 16),
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, '/profile');
                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/images/person.webp'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Grid Items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 28,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    buildGridItem(context, Icons.accessibility_new_outlined, 'Give Measurement', Color(0xFFF4EFD3),MeasurementController()),
                    buildGridItem(context, Icons.collections_bookmark_outlined, 'Fabric Collection', Color(0xFFFBECE1),FabricCollectionScreen()),
                    buildGridItem(context, Icons.scale_outlined, 'Alter Clothes', Color(0xFFD8F3F5),AlterClothesScreen()),
                    buildGridItem(context, Icons.create_outlined, 'Customize Clothes', Color(0xFFE2EFE1),CustomizeClothesScreen()),
                    buildGridItem(context, Icons.assignment_ind_outlined, 'Tailor Made Clothes', Color(0xFFF2EBF8),DressCollectionScreen()),
                    buildGridItem(context, Icons.support_agent_sharp, 'Help & Support', Color(0xFFF6D6D6),HelpSupportScreen()),

                  ],
                ),
              ),
              SizedBox(height: 6),
              // Fabric Collection Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Our Fabric Collection',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_){
                          return FabricCollectionScreen();
                        }));
                      },
                      child: Text('View All',style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              buildHorizontalList(context, fabricCollection),
              // Best Selling Products Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Best Selling Products',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_){
                          return DressCollectionScreen();
                        }));
                      },
                      child: Text('View All',style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              buildHorizontalList(context, bestSellingProducts),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridItem(BuildContext context, IconData icon, String text, Color bgcolor, Widget destinationScreen) {
    return InkWell(
      onTap: () {
        // Navigate to the corresponding screen when the grid item is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  spreadRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16), // Added text styling
                ),
              ),
            ),
          ),
          Positioned(
            top: -15,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgcolor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    spreadRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHorizontalList(BuildContext context, List<Map<String, String>> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        height: 175, // Increased height to ensure items are not cut off
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 5, top: 5, left: 8),
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // Action on tap
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                      spreadRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                      child: Image.asset(
                        items[index]['image']!,
                        height: 105, // Adjusted height for image to fit well
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        items[index]['title']!,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '\$20.00',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
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

  final List<Map<String, String>> fabricCollection = [
    {'image': 'assets/images/fabric_silk.jpg', 'title': 'Silk Fabric'},
    {'image': 'assets/images/fabric_yarn.jpg', 'title': 'Yarn Fabric'},
    {'image': 'assets/images/fabric_cotton.jpg', 'title': 'Cotton Fabric'},
    {'image': 'assets/images/fabric_pinksilk.webp', 'title': 'Pink Silk Fabric'},
    {'image': 'assets/images/fabric_jute.jpg', 'title': 'Jute Fabric'},
    {'image': 'assets/images/fabric_floral.jpg', 'title': 'Cambay Fabric'},
    {'image': 'assets/images/fabric_denim.jpg', 'title': 'Denim Fabric'},
  ];

  final List<Map<String, String>> bestSellingProducts = [
    {'image': 'assets/images/dress_denim_jacket.jpg', 'title': 'Denim Jacket'},
    {'image': 'assets/images/dress_western_classic.jpg', 'title': 'Western Classic'},
    {'image': 'assets/images/dress_yarn_classic.jpg', 'title': 'Yarn Classic'},
    {'image': 'assets/images/dress_silk_saree.jpg', 'title': 'Silk Saree'},
    {'image': 'assets/images/dress_jeans.jpg', 'title': 'Handcrafted Jeans'},
    {'image': 'assets/images/dress_floral.jpg', 'title': 'Floral Dress'},
  ];
}
