    @extends('admin.layouts.admin')
    @section('title', 'Edit Artikel')
    @section('content')
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const form = document.getElementById('form-edit');
            form.addEventListener('submit', function (e) {
                if (!confirm('Apakah Anda yakin ingin menyimpan perubahan?')) {
                    e.preventDefault();
                }
            });
        });
    </script>

    <div class="row mb-3">
        <div class="col">
            <a href="{{ route('artikel.index') }}" class="btn btn-secondary">
                <i class="fa fa-arrow-left"></i> Kembali ke Daftar Artikel
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
                    <h5>Gambar Artikel</h5>
                </div>
                <div class="card-body text-center">
                    @if ($artikel->images && $artikel->images->count())
                        @foreach ($artikel->images as $image)
                            <img src="{{ asset('images/' . $image->gambar) }}" alt="Gambar Artikel" class="img-fluid rounded mb-3" style="max-height: 200px;">
                        @endforeach
                    @else
                        <p class="text-muted">Belum ada gambar</p>
                    @endif

                    <input type="file" name="gambar[]" form="form-edit" class="form-control mt-2" multiple accept="image/*">
                    <small class="text-muted">Gambar lama akan dihapus jika Anda mengunggah yang baru.</small>
                </div>
            </div>
        </div>

        {{-- Kolom kanan: Form edit --}}
        <div class="col-md-8">
            <form id="form-edit" method="POST" action="{{ route('artikel.update', $artikel->id_artikels) }}" enctype="multipart/form-data">
                @csrf
                @method('PUT')

                <div class="card">
                    <div class="card-header">
                        <h4>Edit Artikel</h4>
                    </div>
                    <div class="card-body">
                        {{-- Judul --}}
                        <div class="mb-3">
                            <label for="judul_artikel" class="form-label">Judul Artikel</label>
                            <input type="text" name="judul_artikel" id="judul_artikel" class="form-control @error('judul_artikel') is-invalid @enderror" value="{{ old('judul_artikel', $artikel->judul_artikel) }}" required>
                            @error('judul_artikel')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        {{-- Isi --}}
                        <div class="mb-3">
                            <label for="isi_artikel" class="form-label">Isi Artikel</label>
                            <textarea name="isi_artikel" id="isi_artikel" class="form-control @error('isi_artikel') is-invalid @enderror" rows="8" required>{{ old('isi_artikel', $artikel->isi_artikel) }}</textarea>
                            @error('isi_artikel')
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
                    <form action="{{ route('artikel.destroy', $artikel->id_artikels) }}" method="POST" onsubmit="return confirm('Yakin ingin menghapus artikel ini?')">
                        @csrf
                        @method('DELETE')
                        <button type="submit" class="btn btn-danger">
                            <i class="fa fa-trash"></i> Hapus Artikel
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    @endsection
