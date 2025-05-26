import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  // Get the saved token
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Retrieve the token from shared preferences
  }

  // Save token in SharedPreferences
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  // Clear the saved token from SharedPreferences
  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token'); // This will remove the stored token
  }

  // Get the saved userId
  static Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); // Retrieve the userId from shared preferences
  }

  // Save userId in SharedPreferences
  static Future<void> saveUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', userId);
  }
}
