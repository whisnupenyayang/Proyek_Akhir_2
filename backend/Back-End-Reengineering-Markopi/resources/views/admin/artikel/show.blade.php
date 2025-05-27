@extends('admin.layouts.admin')

@section('title', $artikel->judul_artikel)

@section('content')
<div class="container mt-4">
    <h2>{{ $artikel->judul_artikel }}</h2>
    <p><strong>Penulis:</strong> {{ $artikel->user->name ?? 'Admin' }}</p>

    <hr>

    {{-- Tampilkan isi artikel --}}
    <div id="artikel-display" class="mb-4">
        {!! nl2br(e($artikel->isi_artikel)) !!}
    </div>

    {{-- Form edit artikel (judul, isi, gambar) --}}
    <div id="artikel-edit" class="mb-4" style="display:none;">
        <form id="form-edit" method="POST" action="{{ route('artikel.update', $artikel->id_artikels) }}" enctype="multipart/form-data">
            @csrf
            @method('PUT')

            {{-- Judul Artikel --}}
            <div class="mb-3">
                <label for="judul_artikel" class="form-label">Judul Artikel</label>
                <input type="text" name="judul_artikel" id="judul_artikel" class="form-control" value="{{ $artikel->judul_artikel }}" required>
            </div>

            {{-- Isi Artikel --}}
            <div class="mb-3">
                <label for="isi_artikel" class="form-label">Isi Artikel</label>
                <textarea name="isi_artikel" class="form-control" rows="8" required>{{ $artikel->isi_artikel }}</textarea>
            </div>

            {{-- Ganti Gambar --}}
            <div class="mb-3">
                <label for="gambar" class="form-label">Ganti Gambar (bisa lebih dari 1)</label>
                <input type="file" class="form-control" name="gambar[]" multiple accept="image/jpeg,image/png,image/jpg,image/gif,image/svg+xml">
                <small class="text-muted">Gambar lama akan dihapus jika Anda mengunggah yang baru.</small>
            </div>

            {{-- Tombol Simpan & Batal --}}
            <div class="mt-2 d-flex gap-2">
                <button type="submit" class="btn btn-primary" id="btn-submit">Simpan</button>
                <button type="button" id="btn-cancel" class="btn btn-secondary">Batal</button>
            </div>
        </form>
    </div>

    {{-- Gambar terkait --}}
    @if ($artikel->images && $artikel->images->count())
        <hr>
        <h5>Gambar Terkait:</h5>
        <div class="row">
            @foreach ($artikel->images as $image)
                <div class="col-md-3 col-sm-4 col-6 mb-3">
                    <img src="{{ asset('images/' . $image->gambar) }}" class="img-fluid rounded border" alt="gambar artikel">
                </div>
            @endforeach
        </div>
    @endif

    {{-- Tombol aksi --}}
    <div class="mt-4 d-flex gap-2 align-items-center">
        <a href="{{ route('artikel.index') }}" class="btn btn-secondary">Kembali</a>

        <form action="{{ route('artikel.destroy', $artikel->id_artikels) }}" method="POST" onsubmit="return confirm('Yakin ingin menghapus artikel ini?')">
            @csrf
            @method('DELETE')
            <button type="submit" class="btn btn-danger">Hapus</button>
        </form>

        <button id="btn-edit" class="btn btn-warning d-flex align-items-center gap-1" title="Edit Artikel" type="button">
            <span class="material-icons" style="font-size:20px;">edit</span> Edit
        </button>
    </div>
</div>

{{-- Script toggle edit mode & konfirmasi simpan --}}
<script>
    document.getElementById('btn-edit').addEventListener('click', function() {
        document.getElementById('artikel-display').style.display = 'none';
        document.getElementById('artikel-edit').style.display = 'block';
        this.style.display = 'none';
    });

    document.getElementById('btn-cancel').addEventListener('click', function() {
        document.getElementById('artikel-edit').style.display = 'none';
        document.getElementById('artikel-display').style.display = 'block';
        document.getElementById('btn-edit').style.display = 'flex';
    });

    // Konfirmasi sebelum simpan
    document.getElementById('btn-submit').addEventListener('click', function(event) {
        const yakin = confirm("Apakah Anda yakin ingin menyimpan perubahan?");
        if (!yakin) {
            event.preventDefault();
        }
    });
</script>
@endsection
