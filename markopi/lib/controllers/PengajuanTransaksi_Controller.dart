import 'package:get/get.dart';
import 'package:markopi/providers/Transaksi_Provider.dart';
import 'dart:convert';
import 'package:markopi/service/token_storage.dart';

class PengajuanTransaksiController {
  final TransaksiProvider transaksiProvider = TransaksiProvider();
  Future<void> buatpengajuan(int id, String role) async {
    final String? token = await TokenStorage.getToken();
    if (token == null) {
      Get.snackbar('Error', 'anda belum login');
      return;
    }
    final response =
        await transaksiProvider.postPengajuanTransaksi(token, id, role);
    if (response.statusCode == 200) {
      print(response.body);
      Get.snackbar('Suksess', response.body);
    }

    Get.snackbar('Gagal', 'gagal membuat pengajuan');
  }
}
