import 'package:flutter/material.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  bool _isSidebarExpanded = false; // Mulai dalam keadaan tertutup

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beranda"),
        leading: IconButton(
          icon: Icon(_isSidebarExpanded ? Icons.close : Icons.menu),
          onPressed: () {
            setState(() {
              _isSidebarExpanded = !_isSidebarExpanded; // Toggle sidebar
            });
          },
        ),
      ),
      body: Row(
        children: [
          // Sidebar yang bisa muncul dan hilang
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: _isSidebarExpanded
                ? 250
                : 0, // Menyembunyikan sidebar saat false
            child: SidebarMenu(isExpanded: _isSidebarExpanded),
          ),
          Expanded(
            child: Center(
              child: Text("Selamat datang di Beranda!"),
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarMenu extends StatelessWidget {
  final bool isExpanded;
  const SidebarMenu({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color:
            Color(0xff353A40), // Mengubah latar belakang sidebar menjadi hitam
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName:
                  Text("Admin Markopi", style: TextStyle(color: Colors.white)),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                radius:
                    12, // Memperkecil ukuran avatar lebih kecil dari sebelumnya
                backgroundColor: Colors.blue,
                child: Text("W",
                    style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(Icons.home, "Beranda"),
                  _buildDrawerItem(Icons.eco, "Budidaya Kopi"),
                  _buildDrawerItem(Icons.local_florist, "Panen Kopi"),
                  _buildDrawerItem(Icons.coffee, "Pasca Panen Kopi"),
                  _buildDrawerItem(Icons.store, "Data Pengepul"),
                  _buildDrawerItem(Icons.shopping_bag, "Data Penjual Bibit"),
                  _buildDrawerItem(Icons.assignment, "Pengajuan Fasilitator"),
                  _buildDrawerItem(Icons.group, "Data User"),
                  _buildDrawerItem(null, "Artikel"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData? icon, String title) {
    return ListTile(
      leading: icon != null
          ? Icon(icon, color: Colors.white) // Ikon berwarna putih
          : Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
      title: isExpanded
          ? Text(title,
              style: TextStyle(color: Colors.white)) // Teks berwarna putih
          : null,
      onTap: () {},
    );
  }
}
