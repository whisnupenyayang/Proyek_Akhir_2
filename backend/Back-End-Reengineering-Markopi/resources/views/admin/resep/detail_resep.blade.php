@extends('admin.layouts.admin')

@section('title', 'Edit Resep')

@section('content')
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('form-edit');
        form.addEventListener('submit', function(e) {
            if (!confirm('Apakah Anda yakin ingin menyimpan perubahan?')) {
                e.preventDefault();
            }
        });
    });
</script>

<div class="row mb-3">
    <div class="col">
        <a href="{{ route('admin.resep') }}" class="btn btn-secondary">
            <i class="fa fa-arrow-left"></i> Kembali ke Daftar Resep
        </a>
    </div>
</div>

@if(session('success'))
<div class="alert alert-success">{{ session('success') }}</div>
@elseif(session('error'))
<div class="alert alert-danger">{{ session('error') }}</div>
@endif

<div class="row">
    {{-- Kolom kiri: Gambar --}}
    <div class="col-md-4">
        <div class="card">
            <div class="card-header">
                <h5>Gambar Resep</h5>
            </div>
            <div class="card-body text-center">
                @if($resep->gambar_resep)
                <img id="current-image" src="{{ asset('images/' . $resep->gambar_resep) }}" alt="gambar Resep" class="img-fluid rounded mb-3" style="max-height: 200px;">
                @else
                <p class="text-muted">Tidak ada foto resep.</p>
                @endif

                <input type="file" name="gambar_resep" form="form-edit" class="form-control mt-2" accept="image/*">
                <small class="text-muted">Gambar lama akan diganti jika Anda mengunggah yang baru.</small>
            </div>

        </div>
    </div>

    {{-- Kolom kanan: Form edit --}}
    <div class="col-md-8">
        <form id="form-edit" method="POST" action="{{ route('resep.update', $resep->id) }}" enctype="multipart/form-data">
            @csrf
            {{-- Hapus input _method karena route update pakai POST --}}

            <div class="card">
                <div class="card-header">
                    <h4>Edit Resep</h4>
                </div>
                <div class="card-body">
                    {{-- Nama Resep --}}
                    <div class="mb-3">
                        <label for="nama_resep" class="form-label">Nama Resep</label>
                        <input type="text" name="nama_resep" id="nama_resep" class="form-control @error('nama_resep') is-invalid @enderror" value="{{ old('nama_resep', $resep->nama_resep) }}" required>
                        @error('nama_resep')
                        <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>

                    {{-- Deskripsi --}}
                    <div class="mb-3">
                        <label for="deskripsi" class="form-label">Deskripsi Resep</label>
                        <textarea name="deskripsi_resep" id="deskripsi" class="form-control @error('deskripsi_resep') is-invalid @enderror" rows="8" required>{{ old('deskripsi_resep', $resep->deskripsi_resep) }}</textarea>
                        @error('deskripsi_resep')
                        <div class="invalid-feedback">{{ $message }}</div>
                        @enderror
                    </div>

                    {{-- Tombol Simpan --}}
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
                <form action="{{ route('resep.destroy', $resep->id) }}" method="POST" onsubmit="return confirm('Yakin ingin menghapus resep ini?')">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="btn btn-danger">
                        <i class="fa fa-trash"></i> Hapus Resep
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection
