import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/pengajuan.dart';

class PengajuanPage extends StatelessWidget {
  PengajuanPage({super.key});
  final controller = Get.put(PengajuanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengajuan Posisi',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller.deskripsiController,
                decoration:
                    const InputDecoration(labelText: 'Deskripsi Pengalaman'),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: controller.tipePengajuan.value,
                items: const [
                  DropdownMenuItem(
                      value: 'fasilitator', child: Text('Fasilitator')),
                  DropdownMenuItem(value: 'pengepul', child: Text('Pengepul')),
                ],
                onChanged: (val) =>
                    controller.tipePengajuan.value = val ?? 'fasilitator',
                decoration: const InputDecoration(labelText: 'Tipe Pengajuan'),
              ),
              const SizedBox(height: 16),
              Text("Upload Foto:"),
              UploadTile(
                  label: "Foto KTP",
                  file: controller.fotoKtp,
                  onTap: () => controller.pickImage(controller.fotoKtp)),
              UploadTile(
                  label: "Foto Selfie",
                  file: controller.fotoSelfie,
                  onTap: () => controller.pickImage(controller.fotoSelfie)),
              UploadTile(
                  label: "Foto Sertifikat",
                  file: controller.fotoSertifikat,
                  onTap: () => controller.pickImage(controller.fotoSertifikat)),
              const SizedBox(height: 20),
              controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2696D6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: controller.submitPengajuan,
                      icon: const Icon(Icons.send),
                      label: const Text('Kirim Pengajuan'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadTile extends StatelessWidget {
  final String label;
  final Rx<File?> file;
  final VoidCallback onTap;

  const UploadTile(
      {super.key,
      required this.label,
      required this.file,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListTile(
          title: Text(label),
          subtitle: Text(file.value?.path.split('/').last ?? 'Belum dipilih'),
          trailing: const Icon(Icons.upload_file),
          onTap: onTap,
        ));
  }
}
