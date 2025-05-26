@extends('admin.layouts.admin')

@section('title', 'Tambah Artikel')

@section('content')
<div class="container">

    @if(session('error'))
        <div class="alert alert-danger">{{ session('error') }}</div>
    @endif

    <form action="{{ route('artikel.store') }}" method="POST" enctype="multipart/form-data">
        @csrf

        <div class="mb-3">
            <label for="judul_artikel" class="form-label">Judul Artikel</label>
            <input type="text" class="form-control" id="judul_artikel" name="judul_artikel" value="{{ old('judul_artikel') }}" required>
        </div>

        <div class="mb-3">
            <label for="isi_artikel" class="form-label">Isi Artikel</label>
            <textarea class="form-control" id="isi_artikel" name="isi_artikel" rows="6" required>{{ old('isi_artikel') }}</textarea>
        </div>

        <div class="mb-3">
            <label for="gambar" class="form-label">Upload Gambar (boleh lebih dari satu)</label>
            <input type="file" class="form-control" id="gambar" name="gambar[]" multiple>
        </div>

        <button type="submit" class="btn btn-primary">Simpan</button>
        <a href="{{ route('artikel.index') }}" class="btn btn-secondary">Batal</a>
    </form>
</div>
@endsection
