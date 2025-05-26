import 'package:get/get.dart';
import 'package:markopi/models/Komentar_Forum_Model.dart';
import 'package:markopi/view/Artikel/List_artikel.dart';
import 'package:markopi/view/Beranda/Beranda.dart';
import 'package:markopi/view/Budidaya/Jenis_Tahap_Budidaya.dart';
import 'package:markopi/view/Budidaya/Jenis_Tahap_Budidaya_Detail.dart';
import 'package:markopi/view/Budidaya/Jenis_kopi.dart';
import 'package:markopi/view/Budidaya/Tahap_Budidaya.dart';
import 'package:markopi/view/DataPengepulUser/FormTambahDataPengepul.dart';
import 'package:markopi/view/ForgotPassword/otp.dart';
import 'package:markopi/view/HargaKopi/FormPengajuanDetail.dart';
import 'package:markopi/view/HargaKopi/ListPengepulFinal.dart';
import 'package:markopi/view/HargaKopi/PengepulDetail.dart';
import 'package:markopi/view/Login/login.dart';
import 'package:markopi/view/Profile/Profile.dart';
import 'package:markopi/view/DataPengepulUser/UserPengepu.dart';
import 'package:markopi/view/forum/ForumKomentar.dart';
import 'package:markopi/view/forum/ListForum.dart';
import 'package:markopi/view/Laporan/LaporanPage.dart';
import 'package:markopi/view/forum/TambahPertanyaan.dart';
import 'package:markopi/view/toko/toko_kopi_page.dart'; // Import halaman Toko Kopi
import 'package:markopi/view/resep/resep_kopi_page.dart';
import 'package:markopi/binding/Budidaya_Binding.dart';
import 'package:markopi/view/HargaKopi/TambahPengepulPage.dart';
import './route_name.dart';
import 'package:markopi/view/Register/register.dart';
import 'package:markopi/view/ForgotPassword/forgot_password.dart';
import 'package:markopi/binding/forgot_password.dart';
import 'package:markopi/view/ForgotPassword/reset_password.dart';

class AppPages {
  static final pages = [
    // Halaman utama
    GetPage(
      name: RouteName.beranda,
      page: () => Beranda(),
    ),

    /*================Forum=================== */
    GetPage(
      name: '/forum', // Tambahkan route forum
      page: () => ListForum(),
    ),

    GetPage(
      name: '/forum-detail/:id', // Tambahkan route forum
      page: () => ForumKomentar(),
    ),

    GetPage(name: "/add-forum", page: () => TambahPertanyaan()),
    /*================Budidaya=================== */
    GetPage(
      name: RouteName.kegiatan + '/:kegiatan/:jenis_kopi',
      page: () => TipeBudidaya(),
      binding: BudidayaBinding(),
    ),
    GetPage(
      name: RouteName.kegiatan + '/:kegiatan',
      page: () => BudidayaView(),
    ),
    GetPage(
      name: RouteName.kegiatan +
          '/:kegiatan/:jenis_kopi/jenistahapankegiatan/:id',
      page: () => JenisTahapBudidayaView(),
    ),
    GetPage(
      name: RouteName.kegiatan + '/jenistahapanbudidaya/detail/:id',
      page: () => JenisTahapBudidayDetailView(),
    ),

    /*================Autentikasi=================== */
    GetPage(
      name: RouteName.login,
      page: () => LoginView(),
    ),
    GetPage(
      name: RouteName.register,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: RouteName.forgotPassword,
      page: () => ForgotPassword(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: RouteName.otp,
      page: () => OtpVerificationPage(),
    ),
    GetPage(
      name: RouteName.resetPassword,
      page: () => ResetPasswordPage(),
    ),

    /*================Profile=================== */
    GetPage(
      name: RouteName.profile,
      page: () => ProfileView(),
    ),
    GetPage(
      name: RouteName.profile + '/datapengepul',
      page: () => UserPengepulView(),
    ),

    /*================Pengepul=================== */
    GetPage(
      name: RouteName.pengepul,
      page: () => KopiPage(),
    ),
    GetPage(
      name: RouteName.pengepul + '/pengajuan/:role/:id',
      page: () => FormPengajuanPage(),
    ),
    GetPage(
      name: '/pengepul/detail/:role/:id',
      page: () => DetailPengepuldanPetani(),
    ),
    GetPage(
      name: RouteName.pengepul + '/detail/:id',
      page: () => DetailPengepuldanPetani(),
    ),

    GetPage(
      name: RouteName.pengepul + '/tambah',
      page: () => TambahPengepulPage(),
    ),
    /*================Artikel=================== */
    GetPage(
      name: RouteName.artikel,
      page: () => ListArtikel(),
    ),

    /*================Toko Kopi=================== */
    GetPage(
      name: RouteName.tokoKopi,
      page: () => TokoKopiPage(), // Menambahkan halaman Toko Kopi
    ),

    /*================Resep Kopi=================== */
    GetPage(
      name: RouteName.resepKopi,
      page: () => ResepKopiPage(), // Menambahkan halaman Resep Kopi
    ),

    /*================Laporan=================== */
    GetPage(
      name: RouteName.laporan,
      page: () => const LaporanPage(),
    ),

    // Halaman untuk menambahkan laporan
    // GetPage(
    //   name: '/laporan/tambah', // Definisikan route untuk menambah laporan
    //   page: () =>
    //       const AddLaporanPage(), // Mengarahkan ke halaman AddLaporanPage
    // ),
  ];
}
