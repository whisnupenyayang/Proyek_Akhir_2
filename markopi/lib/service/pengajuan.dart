import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:markopi/providers/Connection.dart';
import 'package:markopi/service/token_storage.dart';

class PengajuanService {
  static Future<dynamic> submitPengajuan(dio.FormData formData) async {
    final String? token = await TokenStorage.getToken();

    var dioClient = dio.Dio();

    var response = await dioClient.post(
      Connection.buildUrl('/pengajuan/add'),
      data: formData,
      options: dio.Options(headers: {
        'Authorization': 'Bearer $token',
        dio.Headers.contentTypeHeader: 'multipart/form-data',
        dio.Headers.acceptHeader: 'application/json',
      }),
    ).catchError((error) {
      debugPrint('Error submitting pengajuan: ${error.response?.data}');
      throw Exception('Gagal mengirim pengajuan: ${error.message}');
    });

    debugPrint('response data: ${response.data}');

    return response.data;
  }

  static Future<dynamic> checkPengajuanStatus() async {
    final String? token = await TokenStorage.getToken();

    var dioClient = dio.Dio();

    var response = await dioClient.get(
      Connection.buildUrl('/pengajuan'),
      options: dio.Options(headers: {
        'Authorization': 'Bearer $token',
        dio.Headers.contentTypeHeader: 'application/json',
        dio.Headers.acceptHeader: 'application/json',
      }),
    ).catchError((error) {
      debugPrint('Error checking pengajuan status: ${error.response?.data}');
      throw Exception('Gagal memeriksa status pengajuan: ${error.message}');
    });

    debugPrint('response data: ${response.data}');

    return response.data;
  }
}
