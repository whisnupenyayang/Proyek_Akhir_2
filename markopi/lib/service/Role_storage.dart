import 'package:shared_preferences/shared_preferences.dart';

class RoleStorage {
  // ngambil role
  static Future<String?> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role'); // Retrieve the token from shared preferences
  }

  // nyimpan role
  static Future<void> saveRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('role', role);
  }

  //menghapus role
  static Future<void> clearRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('role'); 
  }
}    