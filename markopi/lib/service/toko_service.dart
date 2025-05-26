import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/toko.dart';               // Pastikan path model benar
import '../providers/connection.dart';         // Path sesuaikan folder project kamu

class TokoService {
  // Endpoint API untuk toko
  static const String _endpoint = '/tokos';

  // Fetch semua toko
  static Future<List<Toko>>? getAllTokos() async {
    try {
      final url = Connection.buildUrl(_endpoint);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Toko.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load toko data');
      }
    } catch (e) {
      throw Exception('Error fetching all tokos: $e');
    }
  }

  // Fetch toko berdasarkan ID
  static Future<Toko?> getTokoById(int id) async {
    try {
      final url = Connection.buildUrl('$_endpoint/$id');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return Toko.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load toko with ID: $id');
      }
    } catch (e) {
      throw Exception('Error fetching toko by ID: $e');
    }
  }
}
