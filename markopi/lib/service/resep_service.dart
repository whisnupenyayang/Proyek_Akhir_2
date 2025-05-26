import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/resep.dart';               // Pastikan path model benar
import '../providers/connection.dart';      // Path sesuai folder project

class ResepService {
  // Endpoint API untuk resep
  static const String _endpoint = '/reseps';

  // Fetch semua resep
  static Future<List<Resep>>? getAllReseps() async {
    try {
      final url = Connection.buildUrl(_endpoint);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Resep.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load resep data');
      }
    } catch (e) {
      throw Exception('Error fetching all reseps: $e');
    }
  }

  // Fetch resep berdasarkan ID
  static Future<Resep?> getResepById(int id) async {
    try {
      final url = Connection.buildUrl('$_endpoint/$id');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return Resep.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load resep with ID: $id');
      }
    } catch (e) {
      throw Exception('Error fetching resep by ID: $e');
    }
  }
}
