import 'dart:io';
// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // tambah ini
import 'package:markopi/controllers/Forum_Controller.dart';

class TambahPertanyaan extends StatefulWidget {
  const TambahPertanyaan({Key? key}) : super(key: key);

  @override
  State<TambahPertanyaan> createState() => _TambahPertanyaanState();
}

class _TambahPertanyaanState extends State<TambahPertanyaan> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();

  final ForumController forumController = Get.find();

  List<File> _pickedImages = [];

  Future<void> _pickImage() async {
    if (_pickedImages.length >= 10) {
      Get.snackbar(
          'Maksimal Gambar', 'Anda hanya bisa memilih maksimal 10 gambar.');
      return;
    }

    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _pickedImages.add(File(pickedFile.path));
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Kirim list gambar, atau kosongkan jika tidak ada
      forumController.tambahForum(
          _judulController.text, _deskripsiController.text, _pickedImages);
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Pertanyaan',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade500,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Pertanyaan Anda',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'isi Pertanyaan anda...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              Text(
                'Deskripsi',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                textAlign: TextAlign.start,
                validator: (value) => value == null || value.isEmpty
                    ? 'Deskripsi wajib diisi'
                    : null,
              ),
              const SizedBox(height: 16),

              // Tampilkan gambar yang sudah dipilih dalam horizontal scroll
              _pickedImages.isNotEmpty
                  ? SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _pickedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Image.file(_pickedImages[index],
                                    height: 150),
                              ),
                              Positioned(
                                top: 4,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _pickedImages.removeAt(index);
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.black54,
                                    child: Icon(Icons.close,
                                        color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  : const SizedBox(),

              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pilih Gambar (Maksimal 10)'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade500),
                onPressed: _submit,
                child: const Text(
                  'Selesai',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
