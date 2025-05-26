import 'package:get/get.dart';
import 'package:markopi/models/Budidaya_Model.dart';
import 'package:markopi/models/JenisTahapKegiatan_Model.dart';
import 'package:markopi/models/TahapanKegiatan_Model.dart';
import 'package:markopi/providers/Kegiatan_Provider.dart';

class KegiatanController extends GetxController {
  var tahapanKegiatanList = <TahapanKegiatan>[].obs;
  var jenisTahapKegiatanList = <JenisTahapKegiatan>[].obs;
  var jenisTahapKegiatanDetail = JenisTahapKegiatan.empty().obs;

  final kegiatanProvider = KegiatanProvider();

  @override
  void onClose() {
    tahapanKegiatanList.clear();
    jenisTahapKegiatanList.clear();
    super.onClose();
  }

  Future<void> fetchKegiatan(String kegiatan, String jenis_kopi) async {
    print(kegiatan);

    final response =
        await kegiatanProvider.getTahapKegiatan(kegiatan, jenis_kopi);
    if (response.statusCode == 200) {
      final List<dynamic> json = response.body;
      tahapanKegiatanList.value =
          json.map((item) => TahapanKegiatan.fromJson(item)).toList();
      print(json);
    }
  }

  Future<void> fetchJenisTahapanKegiatan(int id) async {
    final response = await kegiatanProvider.getJenisTahapKegiatan(id);
    if (response.statusCode == 200) {
      final List<dynamic> json = response.body;
      print(json);
      jenisTahapKegiatanList.value =
          json.map((item) => JenisTahapKegiatan.fromJson(item)).toList();
    } else {
      Get.snackbar('gagal', 'gagal');
    }
  }

  Future<void> fetchjenisTahapanKegiatanDetail(int id) async {
    final response = await kegiatanProvider.getJenisTahapKegiatanDetail(id);

    if (response.statusCode == 200) {
      final json = response.body;
      print(json);
      jenisTahapKegiatanDetail.value = JenisTahapKegiatan.fromJson(json);
    } else {
      Get.snackbar('gagal', 'gagal');
    }
  }
}
