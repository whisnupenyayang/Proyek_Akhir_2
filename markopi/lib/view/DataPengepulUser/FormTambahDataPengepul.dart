// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:markopi/controllers/Pengepul_Controller.dart';

// class TambahPengepulView extends StatefulWidget {
//   @override
//   _TambahPengepulViewState createState() => _TambahPengepulViewState();
// }

// class _TambahPengepulViewState extends State<TambahPengepulView> {
//   final _formKey = GlobalKey<FormState>();

//   String? selectedProvinsi;
//   String? selectedKabupaten;

//   List provinsiList = [];
//   List kabupatenList = [];

//   TextEditingController namaTokoController = TextEditingController();
//   TextEditingController hargaController = TextEditingController();
//   TextEditingController nomorController = TextEditingController();

//   final pengepulC = Get.put(PengepulController());

//   String? jenisKopi = 'Arabika';
//   File? imageFile;

//   bool _submitted = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchProvinsi();
//   }

//   Future<void> fetchProvinsi() async {
//     final res = await http.get(Uri.parse(
//         'https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json'));
//     if (res.statusCode == 200) {
//       setState(() {
//         provinsiList = jsonDecode(res.body);
//       });
//     }
//   }

//   Future<void> fetchKabupaten(String idProvinsi) async {
//     final res = await http.get(Uri.parse(
//         'https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$idProvinsi.json'));
//     if (res.statusCode == 200) {
//       setState(() {
//         kabupatenList = jsonDecode(res.body);
//       });
//     }
//   }

//   void showCustomDropdown({
//     required String title,
//     required List items,
//     required Function(String id, String name) onSelected,
//   }) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(title),
//             IconButton(
//               icon: Icon(Icons.close),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//         content: SizedBox(
//           width: double.maxFinite,
//           child: ListView.builder(
//             itemCount: items.length,
//             itemBuilder: (_, index) {
//               final item = items[index];
//               return ListTile(
//                 title: Text(item['name']),
//                 onTap: () {
//                   onSelected(item['id'], item['name']);
//                   Navigator.pop(context);
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         imageFile = File(picked.path);
//       });
//     }
//   }

//   void submitForm() {
//     setState(() {
//       _submitted = true;
//     });

//     final isValid = _formKey.currentState!.validate();
//     final isProvinsiValid = selectedProvinsi != null;
//     final isKabupatenValid = selectedKabupaten != null;
//     final isImageValid = imageFile != null;

//     if (isValid && isProvinsiValid && isKabupatenValid && isImageValid) {
//       // Cetak data
//       String nama_toko = namaTokoController.text;
//       String jenis_kopi = jenisKopi!; // diperbaiki: hapus titik
//       int harga = int.parse(hargaController.text);
//       String nomor_telepon = nomorController.text;
//       String alamat = "$selectedProvinsi, $selectedKabupaten";
//       File nama_gambar = imageFile!;

//       pengepulC.tambahDataPengepul(
//           nama_toko, jenis_kopi, harga, nomor_telepon, alamat, nama_gambar);

//       Get.back();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Tambah Data Pengepul")),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: namaTokoController,
//                 decoration: InputDecoration(
//                   labelText: 'Nama Toko',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Nama Wajib diisi' : null,
//               ),
//               SizedBox(height: 10),
//               DropdownButtonFormField<String>(
//                 value: jenisKopi,
//                 decoration: InputDecoration(
//                   labelText: 'Jenis Kopi',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: ['Arabika', 'Robusta']
//                     .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                     .toList(),
//                 onChanged: (val) => setState(() => jenisKopi = val),
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: hargaController,
//                 decoration: InputDecoration(
//                   labelText: 'Harga per Kg',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Harga Wajib diisi' : null,
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 controller: nomorController,
//                 decoration: InputDecoration(
//                   labelText: 'Nomor Telpon',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) => value == null || value.isEmpty
//                     ? 'Nomor Telpon Wajib diisi'
//                     : null,
//               ),
//               SizedBox(height: 10),

//               // Provinsi
//               GestureDetector(
//                 onTap: () {
//                   showCustomDropdown(
//                     title: 'Pilih Provinsi',
//                     items: provinsiList,
//                     onSelected: (id, name) {
//                       setState(() {
//                         selectedProvinsi = name;
//                         selectedKabupaten = null;
//                       });
//                       fetchKabupaten(id);
//                     },
//                   );
//                 },
//                 child: InputDecorator(
//                   decoration: InputDecoration(
//                     labelText: 'Provinsi',
//                     suffixIcon: Icon(Icons.arrow_drop_down),
//                     border: OutlineInputBorder(),
//                     errorText: _submitted && selectedProvinsi == null
//                         ? 'Provinsi wajib dipilih'
//                         : null,
//                   ),
//                   child: Text(
//                     selectedProvinsi ?? '',
//                     style: TextStyle(
//                       color:
//                           selectedProvinsi == null ? Colors.grey : Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),

//               // Kabupaten
//               if (kabupatenList.isNotEmpty)
//                 GestureDetector(
//                   onTap: () {
//                     showCustomDropdown(
//                       title: 'Pilih Kabupaten',
//                       items: kabupatenList,
//                       onSelected: (id, name) {
//                         setState(() {
//                           selectedKabupaten = name;
//                         });
//                       },
//                     );
//                   },
//                   child: InputDecorator(
//                     decoration: InputDecoration(
//                       labelText: 'Kabupaten',
//                       suffixIcon: Icon(Icons.arrow_drop_down),
//                       border: OutlineInputBorder(),
//                       errorText: _submitted && selectedKabupaten == null
//                           ? 'Kabupaten wajib dipilih'
//                           : null,
//                     ),
//                     child: Text(
//                       selectedKabupaten ?? '',
//                       style: TextStyle(
//                         color: selectedKabupaten == null
//                             ? Colors.grey
//                             : Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               SizedBox(height: 10),

//               // Gambar
//               Row(
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: pickImage,
//                     icon: Icon(Icons.image),
//                     label: Text("Pilih Gambar"),
//                   ),
//                   SizedBox(width: 10),
//                   if (imageFile != null)
//                     Expanded(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.file(imageFile!, height: 100),
//                       ),
//                     ),
//                 ],
//               ),
//               if (_submitted && imageFile == null)
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 6),
//                     child: Text(
//                       'Gambar wajib dipilih',
//                       style: TextStyle(color: Colors.red, fontSize: 12),
//                     ),
//                   ),
//                 ),
//               SizedBox(height: 20),

//               // Simpan
//               ElevatedButton(
//                 onPressed: submitForm,
//                 child: Text("Simpan"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
