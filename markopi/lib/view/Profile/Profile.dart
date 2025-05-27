import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/Autentikasi_Controller.dart';
import 'package:markopi/controllers/pengajuan.dart';
import 'package:markopi/routes/route_name.dart';
import 'package:markopi/service/User_Storage.dart';
import 'package:markopi/service/User_Storage_Service.dart';
import 'package:markopi/view/Pengajuan/pengajuan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  var autentikasiC = Get.put(AutentikasiController());
  PengajuanController _pengajuanController = Get.put(PengajuanController());
  final userStorage = UserStorage();
  UserModel? _user;
  String? role;

  // Flag untuk menghindari snackbar muncul berulang
  bool _isSnackbarActive = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    final storedRole = prefs.getString('role');
    setState(() {
      role = storedRole;
    });
  }

  Future<void> _loadUser() async {
    await userStorage.openBox();
    final user = userStorage.getUser();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          if (role == 'admin')
            IconButton(
              icon: Icon(Icons.admin_panel_settings),
              tooltip: 'Admin Panel',
              onPressed: () {
                Get.snackbar('prank', 'ahjsjhadjshsa'); // Ganti dengan route admin panel yang sesuai
              },
            ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Icon(
                Icons.person,
                size: 120,
                color: Colors.grey[700],
              ),
            ),
            FutureBuilder(
              future: _pengajuanController.checkPengajuanStatus(),
              builder: (context, snapshot) {
                return Obx(() {
                  final status = _pengajuanController.status.value;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      width: 209,
                      height: 40,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (status == 0) {
                    return Container(
                      width: 209,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.amber.shade500,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Menunggu Persetujuan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  } else if (status == 1) {
                    return Container(
                      width: 209,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green.shade500,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Pengajuan Diterima',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  } else if (status == 2) {
                    return Container(
                      width: 209,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red.shade500,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Pengajuan Ditolak',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Belum pernah mengajukan
                    return ElevatedButton(
                      onPressed: () => Get.to(PengajuanPage()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        foregroundColor: Colors.white,
                        minimumSize: Size(209, 40),
                      ),
                      child: Text('Ajukan Pengepul/Fasilitator'),
                    );
                  }
                });
              },
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Nama
                    Text(
                      'Nama',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          '${_user!.namaLengkap}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    // Email
                    Text(
                      'email',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          '${_user!.email}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    // Alamat
                    Text(
                      'alamat',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          '${_user!.provinsi},${_user!.kabupaten}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        if (role == 'pengepul') {
                          Get.toNamed(RouteName.profile + '/datapengepul');
                        } else {
                          if (!_isSnackbarActive) {
                            _isSnackbarActive = true;
                            Get.snackbar(
                              'Akses Ditolak',
                              'Anda bukan pengepul, tidak bisa membuka Data Pengepul',
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                              duration: Duration(seconds: 3),
                            );
                            Future.delayed(Duration(seconds: 3), () {
                              _isSnackbarActive = false;
                            });
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  'Data Pengepul',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        'Artikel',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                bool? isConfirmed = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Konfirmasi"),
                      content: Text("Apakah Anda yakin ingin keluar?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text("Batal"),
                        ),
                        TextButton(
                          onPressed: () async {
                            await autentikasiC.logout();
                            Navigator.of(context).pop(true);
                          },
                          child: Text("Keluar"),
                        ),
                      ],
                    );
                  },
                );
                if (isConfirmed == true && autentikasiC.sukses.value) {
                  Get.offAllNamed(RouteName.login);
                }
              },
              child: Container(
                width: 209,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    'Keluar',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
