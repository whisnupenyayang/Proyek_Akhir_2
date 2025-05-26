@extends('admin.layouts.admin')

@section('no-navbar') 
    ->
@endsection

@section('content')
<div class="container mt-4">
    <h2>Tambah Iklan Baru</h2>
    <form action="{{ route('iklan.store') }}" method="POST" enctype="multipart/form-data">
        @csrf

        <!-- Judul Iklan -->
        <div class="mb-3">
            <label for="judul_iklan" class="form-label">Judul Iklan</label>
            <input type="text" class="form-control @error('judul_iklan') is-invalid @enderror" id="judul_iklan" name="judul_iklan" value="{{ old('judul_iklan') }}" required>
            @error('judul_iklan')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <!-- Deskripsi Iklan -->
        <div class="mb-3">
            <label for="deskripsi_iklan" class="form-label">Deskripsi</label>
            <textarea class="form-control @error('deskripsi_iklan') is-invalid @enderror" id="deskripsi_iklan" name="deskripsi_iklan" rows="3" required>{{ old('deskripsi_iklan') }}</textarea>
            @error('deskripsi_iklan')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <!-- Link/Kontak -->
        <div class="mb-3">
            <label for="link" class="form-label">Kontak / Link</label>
            <input type="text" class="form-control @error('link') is-invalid @enderror" id="link" name="link" value="{{ old('link') }}" required>
            @error('link')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <!-- Gambar -->
        <div class="mb-3">
            <label for="gambar" class="form-label">Gambar</label>
            <input type="file" class="form-control @error('gambar') is-invalid @enderror" id="gambar" name="gambar" accept="image/*" required>
            @error('gambar')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <!-- Tombol Submit -->
        <button type="submit" class="btn btn-primary">Tambah Iklan</button>
    </form>
</div>
@endsection
