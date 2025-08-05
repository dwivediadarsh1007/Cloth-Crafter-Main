import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tailor_app/utility.dart';
import 'package:tailor_app/services/token_storage.dart';  // For storing token
import '../constants.dart';
  // To access CurrentState class

Future<String?> loginUser(String email, String password) async {
  final url = Uri.parse('$apiUrl/login');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];

      // Save token locally
      await TokenStorage.saveToken(token);

      // Decode the token and update the CurrentState
      await getUserDetails();

      return token;
    } else {
      print('Login failed: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error occurred: $e');
    return null;
  }
}
