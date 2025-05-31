import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/laporan_kebun.dart';
import '../providers/connection.dart';
import 'package:markopi/service/token_storage.dart';

class LaporanService {
  static const String _endpoint = '/laporan/';

  static Future<LaporanResponse> getAllLaporans() async {
    Dio dio = Dio();
    final String? token = await TokenStorage.getToken();
    final url = Connection.buildUrl(_endpoint);
    
    print('Fetching from URL: $url');
    
    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          Headers.contentTypeHeader: 'application/json',
          Headers.acceptHeader: 'application/json',
        },
      ),
    );
    
    print('Response status code: ${response.statusCode}');
    print('Full response data: ${response.data}'); // Debug full response
    
    if (response.statusCode == 200) {
      final jsonResponse = response.data;
      
      // Debug: Print untuk melihat struktur data
      print('jsonResponse type: ${jsonResponse.runtimeType}');
      print('jsonResponse: $jsonResponse');
      
      if (jsonResponse['data'] != null) {
        final data = jsonResponse['data'];
        print('data type: ${data.runtimeType}');
        print('data content: $data');
        
        // PERBAIKAN: Langsung pass seluruh jsonResponse, bukan hanya 'data'
        return LaporanResponse.fromJson(jsonResponse);
      } else {
        // Jika tidak ada key 'data', return empty response
        return LaporanResponse(laporan: [], totalProduktifitas: 0);
      }
    } else {
      throw Exception('Failed to load laporan data: Status ${response.statusCode}');
    }
  }

  // Method lainnya tetap sama...
  static Future<LaporanDetailKebunModel> getLaporanById(int id) async {
    Dio dio = Dio();
    final String? token = await TokenStorage.getToken();
    final url = Connection.buildUrl('${_endpoint}detail/$id');
    
    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          Headers.contentTypeHeader: 'application/json',
          Headers.acceptHeader: 'application/json',
        },
      ),
    );
    
    if (response.statusCode == 200) {
      return LaporanDetailKebunModel.fromJson(response.data);
    } else {
      debugPrint('detail: ${response.data}');
      throw Exception('Failed to load laporan with ID: $id');
    }
  }

  static Future<Response<dynamic>> addLaporan(
      String namaKebun, String lokasi, String luasKebun) async {
    final String? token = await TokenStorage.getToken();
    final dio = Dio();
    
    return await dio.post(
      Connection.buildUrl('/laporan/store'),
      data: {
        'nama_kebun': namaKebun,
        'lokasi': lokasi,
        'luas_kebun': double.parse(luasKebun),
      },
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}