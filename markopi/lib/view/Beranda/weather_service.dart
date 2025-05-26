import 'dart:convert'; // Untuk decode JSON
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '9a202bb365cb4707f20af75c65891e90';  // Ganti dengan API key yang kamu dapatkan
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // Fungsi untuk mengambil data cuaca berdasarkan kota
  Future<Map<String, dynamic>> getWeatherData(String city) async {
    final response = await http.get(Uri.parse(
      '$baseUrl?q=$city&units=metric&appid=$apiKey'
    ));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal mendapatkan data cuaca');
    }
  }

  // Fungsi untuk mengambil data cuaca berdasarkan koordinat
  Future<Map<String, dynamic>> getWeatherDataByCoordinates(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
      '$baseUrl?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey'
    ));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal mendapatkan data cuaca');
    }
  }
}
