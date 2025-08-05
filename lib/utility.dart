import 'package:jwt_decoder/jwt_decoder.dart';
import '../services/token_storage.dart'; // Import the token storage

Future<void> getUserDetails() async {
  final token = await TokenStorage.getToken();

  if (token != null) {
    final decodedToken = JwtDecoder.decode(token);

    // Extract details from the token payload with null checks
    final email = decodedToken['email'] ?? 'Unknown Email';
    final username = decodedToken['username'] ?? 'Unknown Username';
    final userType = decodedToken['user_type'] ?? 'Unknown User Type';

    // Set these details in the CurrentState class
    CurrentState.email = email;
    CurrentState.username = username;
    CurrentState.userType = userType;

    // Now, print the values
    print('Email: ${CurrentState.email}');
    print('Username: ${CurrentState.username}');
    print('User Type: ${CurrentState.userType}');
  } else {
    print('No token found');
  }
}

class CurrentState {
  static String _username = "", _email = "", _userType = "";

  CurrentState();

  static String get userType => _userType;
  static String get email => _email;
  static String get username => _username;

  static set userType(String value) {
    _userType = value;
  }

  static set email(String value) {
    _email = value;
  }

  static set username(String value) {
    _username = value;
  }
}
