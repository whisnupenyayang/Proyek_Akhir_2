@extends('admin.layouts.admin')

@section('title', 'Detail Toko')

@section('content')
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('form-edit-toko');

        form.addEventListener('submit', function(e) {
            // Konfirmasi submit
            if (!confirm('Apakah Anda yakin ingin menyimpan perubahan?')) {
                e.preventDefault();
                return;
            }

            // Gabungkan jam buka dan jam tutup
            const jamBuka = document.getElementById('jam_buka').value;
            const jamTutup = document.getElementById('jam_tutup').value;
            const jamOperasional = document.getElementById('jam_operasional');

            if (!jamBuka || !jamTutup) {
                alert('Jam buka dan jam tutup harus diisi!');
                e.preventDefault();
                return;
            }

            jamOperasional.value = jamBuka + ' - ' + jamTutup;
        });

        const formDelete = document.getElementById('form-delete-toko');
        if (formDelete) {
            formDelete.addEventListener('submit', function(e) {
                if (!confirm('Yakin ingin menghapus toko ini?')) {
                    e.preventDefault();
                }
            });
        }
    });
</script>


<div class="row mb-3">
    <div class="col">
        <a href="{{ route('admin.toko') }}" class="btn btn-secondary">
            <i class="fa fa-arrow-left"></i> Kembali ke Daftar Toko
        </a>
    </div>
</div>

@if(session('success'))
<div class="alert alert-success">{{ session('success') }}</div>
@elseif(session('error'))
<div class="alert alert-danger">{{ session('error') }}</div>
@endif

<div class="row">
    {{-- Kolom kiri: Foto Toko --}}
    <div class="col-md-4">
        <div class="card">
            <div class="card-header">
                <h5>Foto Toko</h5>
            </div>
            <div class="card-body text-center">
                @if ($toko->foto_toko)
                <img src="{{ asset('images/' . $toko->foto_toko) }}" alt="Foto Toko" class="img-fluid rounded mb-3" style="max-height: 250px;">
                @else
                <p class="text-muted">Tidak ada foto toko.</p>
                @endif

                <input type="file" name="foto_toko" form="form-edit-toko" class="form-control mt-2" accept="image/*">
                <small class="text-muted">Foto lama akan dihapus jika Anda mengunggah yang baru.</small>
            </div>
        </div>
    </div>

    {{-- Kolom kanan: Form Edit --}}
    <div class="col-md-8">
        <form id="form-edit-toko" method="POST" action="{{ route('toko.update', $toko->id) }}" enctype="multipart/form-data">
            @csrf
            @method('PUT')

            <div class="card">
                <div class="card-header">
                    <h4>Edit Toko</h4>
                </div>
                <div class="card-body">
                    {{-- Nama Toko --}}
                    <div class="mb-3">
                        <label for="nama_toko" class="form-label">Nama Toko</label>
                        <input type="text" name="nama_toko" id="nama_toko" class="form-control @error('nama_toko') is-invalid @enderror" value="{{ old('nama_toko', $toko->nama_toko) }}" required>
                        @error('nama_toko')
                        <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>

                    {{-- Lokasi --}}
                    <div class="mb-3">
                        <label for="lokasi" class="form-label">Link Lokasi</label>
                        <input type="text" name="lokasi" id="lokasi" class="form-control @error('lokasi') is-invalid @enderror" value="{{ old('lokasi', $toko->lokasi) }}" required>
                        @error('lokasi')
                        <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>

                    {{-- Jam Operasional --}}
                    <div class="mb-3">
                        <label for="jam_buka" class="form-label">Jam Buka</label>
                        <input type="time" id="jam_buka" class="form-control" value="{{ explode(' - ', $toko->jam_operasional)[0] }}" required>
                    </div>

                    <div class="mb-3">
                        <label for="jam_tutup" class="form-label">Jam Tutup</label>
                        <input type="time" id="jam_tutup" class="form-control" value="{{ explode(' - ', $toko->jam_operasional)[1] }}" required>
                    </div>

                    <input type="hidden" id="jam_operasional" name="jam_operasional" value="">


                    <div class="d-flex justify-content-between">
                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-save"></i> Simpan Perubahan
                        </button>
                    </div>
                </div>
            </div>
        </form>

        {{-- Form Hapus --}}
        <div class="card mt-3">
            <div class="card-body">
                <form id="form-delete-toko" action="{{ route('toko.destroy', $toko->id) }}" method="POST">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="btn btn-danger">
                        <i class="fa fa-trash"></i> Hapus Toko
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection