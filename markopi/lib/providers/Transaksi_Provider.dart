import 'dart:convert';

import 'package:get/get.dart';
import 'package:markopi/providers/Connection.dart';

class TransaksiProvider extends GetConnect {
  Future<Response> postPengajuanTransaksi(
      String token, int id, String role) async {
    final body = json.encode(
      {"id": id, "role": role},
    );
    return post(Connection.buildUrl('/buatpengajuan'), body,
        headers: {'Authorization': 'Bearer $token'});
  }

  Future<Response> getPengajuanBeliKopi(String token) async {
    return get(Connection.buildUrl('/pengajunbelikopi'),
        headers: {'Authorization': 'Bearer $token'});
  }

  
}
