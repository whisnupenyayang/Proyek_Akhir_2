import 'package:get/get.dart';
import 'package:markopi/providers/Connection.dart';

class KegiatanProvider extends GetConnect {
  Future<Response> getTahapKegiatan(String kegiatan, String jenis_kopi) {
    return get(Connection.buildUrl('/kegiatan/$kegiatan/$jenis_kopi'));
  }

  Future<Response> getJenisTahapKegiatan(int id) {
    return get(Connection.buildUrl('/jenistahapankegiatan/$id'));
  }

  Future<Response> getJenisTahapKegiatanDetail(int id) {
    return get(Connection.buildUrl('/jenistahapankegiatan/detail/$id'));
  }

  
}
