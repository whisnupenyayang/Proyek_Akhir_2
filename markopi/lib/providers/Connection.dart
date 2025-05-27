class Connection {
  static const String apiUrl =
      // 'https://www.markopi.cloud/api'; // URL API Laravel yang sudah di-hosting
      // 'http://192.168.53.244:8000/api'; // URL API Andoroid
      //'http://10.0.2.2:8000/api'; // URL API Laravel local
       'https://markopi.d4trpl-itdel.id/api';

  // Fungsi untuk menggabungkan URL API dengan endpoint tertentu
  static String buildUrl(String endpoint) {
    return apiUrl + endpoint;
  }
  // /storage/pengepul/WqIimfqqENHGMrj5KIIb4RxVS3GXGQdmTCTBkTgx.jpg

  static const String imageUrl = 
  //'http://10.0.2.2:8000/'; 
  //  'http://192.168.53.244:8000/';
  'https://markopi.d4trpl-itdel.id/';



  static String buildImageUrl(String image_url) {
    return imageUrl + image_url;
  }
}
