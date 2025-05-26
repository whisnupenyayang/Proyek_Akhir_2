@extends('admin.layouts.admin')

@section('content')
<h2>Tambah Informasi Budidaya</h2>

<form action="{{ route('kegiatan.budidaya.store') }}" method="POST" enctype="multipart/form-data">
    @csrf

    <div class="form-group">
        <label for="jenis_kopi">Jenis Kopi</label>
        <select name="jenis_kopi" class="form-control" required>
            <option value="">-- Pilih Jenis Kopi --</option>
            <option value="Arabika">Arabika</option>
            <option value="Robusta">Robusta</option>
        </select>
    </div>

    <div class="form-group">
        <label for="nama_tahapan_existing">Pilih Tahapan yang Sudah Ada</label>
        <select name="nama_tahapan_existing" class="form-control">
            <option value="">-- Pilih Jika Tidak Ingin Buat Baru --</option>
            @foreach ($existingTahapan as $tahapan)
                <option value="{{ $tahapan }}">{{ $tahapan }}</option>
            @endforeach
        </select>
    </div>

    <div class="form-group">
        <label for="nama_tahapan_baru">Atau Masukkan Nama Tahapan Baru</label>
        <input type="text" name="nama_tahapan_baru" class="form-control" placeholder="Contoh: Pemilihan Lahan">
    </div>

    <div class="form-group">
        <label for="judul">Judul Informasi</label>
        <input type="text" name="judul" class="form-control" required>
    </div>

    <div class="form-group">
        <label for="deskripsi">Deskripsi</label>
        <textarea name="deskripsi" class="form-control" rows="5" required></textarea>
    </div>

    <div class="form-group">
        <label for="url_gambar">Upload Gambar</label>
        <input type="file" name="url_gambar" class="form-control-file" accept="image/*">
    </div>

    <div class="form-group">
        <label for="nama_file">Upload File</label>
        <input type="file" name="nama_file" class="form-control-file" accept=".pdf,.doc,.docx,.xls,.xlsx,.zip">
    </div>

    <button type="submit" class="btn btn-success">Simpan Informasi</button>
    <a href="{{ route('kegiatan.budidaya') }}" class="btn btn-secondary">Kembali</a>
</form>
@endsection
