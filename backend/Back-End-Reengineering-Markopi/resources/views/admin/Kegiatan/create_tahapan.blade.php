@extends('admin.layouts.admin')

@section('content')
<div class="container">
    <h2>Tambah Tahapan Kegiatan</h2>

    <form action="{{ route('tahapan.store') }}" method="POST">
        @csrf
        <div class="mb-3">
            <label for="nama_tahapan" class="form-label">Nama Tahapan</label>
            <input type="text" class="form-control" id="nama_tahapan" name="nama_tahapan" required>
        </div>
        <div class="mb-3">
            <label for="kegiatan" class="form-label">Kegiatan</label>
            <textarea class="form-control" id="kegiatan" name="kegiatan" rows="4" required></textarea>
        </div>
        <div class="mb-3">
            <label for="jenis_kopi" class="form-label">Jenis Kopi</label>
            <input type="text" class="form-control" id="jenis_kopi" name="jenis_kopi" required>
        </div>
        <button type="submit" class="btn btn-primary">Simpan</button>
    </form>
</div>
@endsection
