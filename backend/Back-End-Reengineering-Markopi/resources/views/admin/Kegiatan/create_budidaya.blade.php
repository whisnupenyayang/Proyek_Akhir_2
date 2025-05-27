@extends('admin.layouts.admin')

@section('content')
<h2>Tambah Informasi Budidaya</h2>

@if ($errors->any())
    <div class="alert alert-danger">
        <strong>Oops!</strong> Ada kesalahan saat mengisi form:<br><br>
        <ul>
            @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
@endif

<form action="{{ route('kegiatan.budidaya.store') }}" method="POST" enctype="multipart/form-data">
    @csrf

    <div class="form-group">
        <label for="jenis_kopi">Jenis Kopi<span style="color:red;">*</span></label>
        <select name="jenis_kopi" class="form-control" required>
            <option value="">-- Pilih Jenis Kopi --</option>
            <option value="Arabika" {{ old('jenis_kopi') == 'Arabika' ? 'selected' : '' }}>Arabika</option>
            <option value="Robusta" {{ old('jenis_kopi') == 'Robusta' ? 'selected' : '' }}>Robusta</option>
        </select>
        @error('jenis_kopi')
            <small class="text-danger">{{ $message }}</small>
        @enderror
    </div>

    <div class="form-group">
        <label for="nama_tahapan_existing">Pilih Tahapan yang Sudah Ada</label>
        <select name="nama_tahapan_existing" class="form-control">
            <option value="">-- Pilih Jika Tidak Ingin Buat Baru --</option>
            @foreach ($existingTahapan as $tahapan)
                <option value="{{ $tahapan }}" {{ old('nama_tahapan_existing') == $tahapan ? 'selected' : '' }}>{{ $tahapan }}</option>
            @endforeach
        </select>
        @error('nama_tahapan_existing')
            <small class="text-danger">{{ $message }}</small>
        @enderror
    </div>

    <div class="form-group">
        <label for="nama_tahapan_baru">Atau Masukkan Nama Tahapan Baru</label>
        <input type="text" name="nama_tahapan_baru" class="form-control" value="{{ old('nama_tahapan_baru') }}" placeholder="Contoh: Pemilihan Lahan">
        @error('nama_tahapan_baru')
            <small class="text-danger">{{ $message }}</small>
        @enderror
        @if ($errors->has('nama_tahapan'))
            <small class="text-danger">{{ $errors->first('nama_tahapan') }}</small>
        @endif
    </div>

    <div class="form-group">
        <label for="judul">Judul Informasi<span style="color:red;">*</span></label>
        <input type="text" name="judul" class="form-control" value="{{ old('judul') }}" required>
        @error('judul')
            <small class="text-danger">{{ $message }}</small>
        @enderror
    </div>

    <div class="form-group">
        <label for="deskripsi">Deskripsi<span style="color:red;">*</span></label>
        <textarea name="deskripsi" class="form-control" rows="5" required>{{ old('deskripsi') }}</textarea>
        @error('deskripsi')
            <small class="text-danger">{{ $message }}</small>
        @enderror
    </div>

    <div class="form-group">
        <label for="url_gambar">Upload Gambar<span style="color:red;">*</span></label>
        <input type="file" name="url_gambar" class="form-control-file" accept="image/*" required>
        @error('url_gambar')
            <small class="text-danger">{{ $message }}</small>
        @enderror
    </div>

    <div class="form-group">
        <label for="nama_file">Upload File (PDF, DOC, XLS, ZIP) - Maks 5MB<span style="color:red;">*</span></label>
        <input type="file" name="nama_file" class="form-control-file" accept=".pdf,.doc,.docx,.xls,.xlsx,.zip" required>
        @error('nama_file')
            <small class="text-danger">{{ $message }}</small>
        @enderror
    </div>

    <button type="submit" class="btn btn-success">Simpan Informasi</button>
    <a href="{{ route('kegiatan.budidaya') }}" class="btn btn-secondary">Kembali</a>
</form>
@endsection
