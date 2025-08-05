import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tailor_app/screens/search_tailor_screen.dart';
import 'package:tailor_app/utility.dart';
import 'dart:convert';
import 'package:tailor_app/widgets/rounded_button.dart';
import 'package:tailor_app/constants.dart';

class AlterClothesScreen extends StatefulWidget {
  @override
  _AlterClothesScreenState createState() => _AlterClothesScreenState();
}

class _AlterClothesScreenState extends State<AlterClothesScreen> {
  String selectedCategory = 'Jeans';
  List<String> categories = ['Jeans', 'Top', 'Shirt', 'Western', 'Others'];
  late BuildContext curr;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _messageController = TextEditingController();

  Future<void> _uploadAlterClothes() async {
    final uri = Uri.parse('$apiUrl/alter_clothes');
    final request = http.MultipartRequest('POST', uri)
      ..fields['email'] = CurrentState.email // Replace with actual email
      ..fields['category'] = selectedCategory
      ..fields['description'] = _messageController.text;

    if (_selectedImage != null) {
      final imageStream = http.ByteStream(_selectedImage!.openRead());
      final imageLength = await _selectedImage!.length();
      final imageFile = http.MultipartFile('image', imageStream, imageLength, filename: basename(_selectedImage!.path));
      request.files.add(imageFile);
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString(); // Get the response body as a string

      if (response.statusCode == 201) {
        showSnackbarMessage(curr, 'Alter request successful!');
        Navigator.pop(curr);
      } else {
        showSnackbarMessage(curr, 'Failed to submit alteration request: ${responseBody}');
      }
    } catch (e) {
      showSnackbarMessage(curr, 'An error occurred: ${e.toString()}');
    }
  }



  @override
  Widget build(BuildContext context) {
    curr=context;
    return Scaffold(
      appBar: AppBar(title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Alter Clothes"),
          InkWell(onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (_){
              return TailorSearchScreen();
            }));
          },child: Icon(Icons.person_search_rounded),)
        ],
      )),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDropdown('Set category', selectedCategory, categories, (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    }),
                    SizedBox(height: 40),
                    buildImageUploadSection(),
                    SizedBox(height: 20),
                    buildMessageTextField(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RoundedButton(
              title: 'Alter It',
              onTap: () async {
                if (_selectedImage == null || _messageController.text.trim().isEmpty) {
                  // Show error message if no image or description is provided
                  showSnackbarMessage(context, "Please provide necessary details");
                } else {
                  // Post the data
                  await _uploadAlterClothes();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to show the scaffold messenger message
  void showSnackbarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
      ),
    );
  }


  Widget buildDropdown(String title, String currentValue, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: currentValue,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            dropdownColor: Colors.white,
            underline: Container(height: 2, color: Colors.transparent),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Widget buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Attach your product image",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: _pickImage,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.add, size: 30),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 150,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _selectedImage == null
                      ? Center(child: Text("No image selected"))
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildMessageTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _messageController,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: "Write your message ...",
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }


}
