import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markopi/controllers/Pengepul_Controller.dart';
import 'package:markopi/controllers/utils/constants.dart';


class TambahPengepulPage extends StatefulWidget {
  @override
  _TambahPengepulPageState createState() => _TambahPengepulPageState();
}

class _TambahPengepulPageState extends State<TambahPengepulPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();

  final PengepulController pengepulC = Get.find();
  File? _image;

  List<String> selectedJenisKopi = [];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

  if (pickedFile != null) {
    setState(() {
      _image = File(pickedFile.path);
    });
  }
}

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        Get.snackbar('Gagal', 'Gambar belum dipilih');
        return;
      }

      if (selectedJenisKopi.isEmpty) {
        Get.snackbar('Gagal', 'Pilih minimal satu jenis kopi');
        return;
      }

      pengepulC.tambahPengepul(
        nama: namaController.text,
        alamat: alamatController.text,
        harga: hargaController.text,
        gambar: _image!,
        telepon: teleponController.text,
        jenisKopi: selectedJenisKopi.join(','), // contoh: "Arabika,Robusta"
      );

      Get.back(); // kembali ke halaman sebelumnya
    }
  }

   void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading:
                    Icon(Icons.photo_camera, color: Constants.primaryColor),
                title: Text('Ambil Foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.photo_library, color: Constants.primaryColor),
                title: Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pengepul'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _showImagePicker,
                child: Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: _image != null
                      ? Image.file(_image!, fit: BoxFit.cover)
                      : Center(child: Text('Pilih Gambar')),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Toko'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama toko harus diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) =>
                    value!.isEmpty ? 'Alamat harus diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: teleponController,
                decoration: InputDecoration(labelText: 'Nomor Telepon'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Nomor telepon harus diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: hargaController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Harga harus diisi' : null,
              ),
              SizedBox(height: 24),
              Text('Jenis Kopi', style: TextStyle(fontWeight: FontWeight.bold)),
              CheckboxListTile(
                title: Text('Arabika'),
                value: selectedJenisKopi.contains('Arabika'),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedJenisKopi.add('Arabika');
                    } else {
                      selectedJenisKopi.remove('Arabika');
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Robusta'),
                value: selectedJenisKopi.contains('Robusta'),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedJenisKopi.add('Robusta');
                    } else {
                      selectedJenisKopi.remove('Robusta');
                    }
                  });
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Simpan'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              )
            ],
          ),
        ),
      ),
    );
  }
}
