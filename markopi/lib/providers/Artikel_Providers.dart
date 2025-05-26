import 'package:get/get.dart';
import 'package:markopi/providers/Connection.dart';
import 'package:markopi/models/Artikel_Model.dart';

class ArtikelProvider extends GetConnect {
  Future<List<Artikel>> fetchArtikels() async {
    final response = await get(Connection.buildUrl('/artikel'));
    if (response.statusCode == 200) {
      List data = response.body['data'];
      return data.map((e) => Artikel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load artikels');
    }
  }
}
