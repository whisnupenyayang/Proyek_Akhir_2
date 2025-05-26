import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/iklan.dart';
import '../providers/connection.dart'; // atau sesuai struktur kamu

class IklanService {
  static const String _endpoint = '/iklans';

  static Future<List<Iklan>> getAllIklan() async {
    final url = Connection.buildUrl(_endpoint);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final data = jsonBody['data'] as List;
      return data.map((json) => Iklan.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load iklan');
    }
  }
}
