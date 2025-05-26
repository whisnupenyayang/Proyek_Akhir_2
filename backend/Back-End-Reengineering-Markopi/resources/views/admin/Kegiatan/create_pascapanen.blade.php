@extends('admin.layouts.admin')

@section('content')
<h2>Tambah Informasi Pasca Panen</h2>

<form action="{{ route('kegiatan.pascapanen.store') }}" method="POST" enctype="multipart/form-data">
    @csrf

    <div class="form-group">
        <label for="jenis_kopi">Jenis Kopi</label>
        <select name="jenis_kopi" class="form-control @error('jenis_kopi') is-invalid @enderror" required>
            <option value="">-- Pilih Jenis Kopi --</option>
            <option value="Arabika" {{ old('jenis_kopi') == 'Arabika' ? 'selected' : '' }}>Arabika</option>
            <option value="Robusta" {{ old('jenis_kopi') == 'Robusta' ? 'selected' : '' }}>Robusta</option>
        </select>
        @error('jenis_kopi')
            <div class="invalid-feedback">{{ $message }}</div>
        @enderror
    </div>

    <div class="form-group">
        <label for="nama_tahapan_existing">Pilih Tahapan yang Ada</label>
        <select name="nama_tahapan_existing" class="form-control @error('nama_tahapan_existing') is-invalid @enderror">
            <option value="">-- Pilih Jika Ingin Menggunakan Tahapan yang Sudah Ada --</option>
            @foreach ($existingTahapan as $tahapan)
                <option value="{{ $tahapan }}" {{ old('nama_tahapan_existing') == $tahapan ? 'selected' : '' }}>
                    {{ $tahapan }}
                </option>
            @endforeach
        </select>
        @error('nama_tahapan_existing')
            <div class="invalid-feedback">{{ $message }}</div>
        @enderror
    </div>

    <div class="form-group">
        <label for="nama_tahapan_baru">Atau Buat Tahapan Baru</label>
        <input type="text" name="nama_tahapan_baru" class="form-control @error('nama_tahapan_baru') is-invalid @enderror" placeholder="Contoh: Pengeringan" value="{{ old('nama_tahapan_baru') }}">
        @error('nama_tahapan_baru')
            <div class="invalid-feedback">{{ $message }}</div>
        @enderror
    </div>

    <div class="form-group">
        <label for="judul">Judul Informasi</label>
        <input type="text" name="judul" class="form-control @error('judul') is-invalid @enderror" required value="{{ old('judul') }}">
        @error('judul')
            <div class="invalid-feedback">{{ $message }}</div>
        @enderror
    </div>

    <div class="form-group">
        <label for="deskripsi">Deskripsi</label>
        <textarea name="deskripsi" class="form-control @error('deskripsi') is-invalid @enderror" rows="5" required>{{ old('deskripsi') }}</textarea>
        @error('deskripsi')
            <div class="invalid-feedback">{{ $message }}</div>
        @enderror
    </div>

    <div class="form-group">
        <label for="url_gambar">Upload Gambar</label>
        <input type="file" name="url_gambar" class="form-control-file @error('url_gambar') is-invalid @enderror" accept="image/*">
        @error('url_gambar')
            <div class="invalid-feedback d-block">{{ $message }}</div>
        @enderror
    </div>

    <div class="form-group">
        <label for="nama_file">Upload Dokumen (PDF, DOC, XLS, ZIP) - Maks 5MB</label>
        <input type="file" name="nama_file" class="form-control-file @error('nama_file') is-invalid @enderror" accept=".pdf,.doc,.docx,.xls,.xlsx,.zip" required>
        @error('nama_file')
            <div class="invalid-feedback d-block">{{ $message }}</div>
        @enderror
    </div>

    <button type="submit" class="btn btn-success">Simpan Informasi</button>
    <a href="{{ route('kegiatan.pascapanen') }}" class="btn btn-secondary">Kembali</a>
</form>
@endsection
