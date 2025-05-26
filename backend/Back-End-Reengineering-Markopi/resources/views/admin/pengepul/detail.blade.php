@extends('admin.layouts.admin')

@section('no-navbar', true)
@section('no-header', true)

@section('content')
    <div class="row mb-3">
        <div class="col">
            <a href="{{ route('admin.pengepul') }}" class="btn btn-secondary">
                <i class="fa fa-arrow-left"></i> Kembali ke Daftar Pengepul
            </a>
        </div>
    </div>

    @if(session('success'))
        <div class="alert alert-success">{{ session('success') }}</div>
    @elseif(session('error'))
        <div class="alert alert-danger">{{ session('error') }}</div>
    @endif

    <div class="row">
        <!-- Kolom Kiri: Foto -->
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">
                    <h5>Foto Pengepul</h5>
                </div>
                <div class="card-body text-center">
                    @if ($pengepul->url_gambar)
                        <img src="{{ asset($pengepul->url_gambar) }}" alt="Foto Pengepul" class="img-fluid rounded mb-3"style="max-height: 300px;">
                    @else
                        <p class="text-muted">Belum ada gambar</p>
                    @endif
                    <div class="mt-3">
                        <input type="file" name="gambar" form="update-form" class="form-control form-control-sm" accept="image/*">
                    </div>
                </div>
            </div>
        </div>

        <!-- Kolom Kanan: Detail Form -->
        <div class="col-md-8">
            <form id="update-form" action="{{ route('admin.pengepul.update', $pengepul->id) }}" method="POST" enctype="multipart/form-data">
                @csrf
                @method('PUT')

                <div class="card">
                    <div class="card-header">
                        <h4>Edit Detail Toko</h4>
                    </div>
                    <div class="card-body">

                        <div class="mb-3">
                            <label for="nama_toko" class="form-label">Nama Toko</label>
                            <input type="text" id="nama_toko" name="nama_toko" class="form-control @error('nama_toko') is-invalid @enderror" value="{{ old('nama_toko', $pengepul->nama_toko) }}" required>
                            @error('nama_toko')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                        <div class="mb-3">
                            <label for="alamat" class="form-label">Alamat</label>
                            <textarea id="alamat" name="alamat" class="form-control @error('alamat') is-invalid @enderror" rows="2" required>{{ old('alamat', $pengepul->alamat) }}</textarea>
                            @error('alamat')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="mb-3">
                            <label for="jenis_kopi" class="form-label">Jenis Kopi</label>
                            <select id="jenis_kopi" name="jenis_kopi" class="form-select @error('jenis_kopi') is-invalid @enderror" required>
                                <option value="Arabika" {{ old('jenis_kopi', $pengepul->jenis_kopi) === 'Arabika' ? 'selected' : '' }}>Arabika</option>
                                <option value="Robusta" {{ old('jenis_kopi', $pengepul->jenis_kopi) === 'Robusta' ? 'selected' : '' }}>Robusta</option>
                            </select>
                            @error('jenis_kopi')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="mb-3">
                            <label for="harga" class="form-label">Harga/kg</label>
                            <input type="number" id="harga" name="harga" class="form-control @error('harga') is-invalid @enderror"
                            value="{{ old('harga', $pengepul->harga) }}" required>
                            @error('harga')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="mb-3">
                            <label for="nomor_telepon" class="form-label">Nomor Telepon</label>
                            <input type="text" id="nomor_telepon" name="nomor_telepon" class="form-control @error('nomor_telepon') is-invalid @enderror"
                            value="{{ old('nomor_telepon', $pengepul->nomor_telepon) }}" required>
                            @error('nomor_telepon')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <div class="d-flex justify-content-end">
                            <button type="submit" class="btn btn-primary">
                                <i class="fa fa-save"></i> Simpan Perubahan
                            </button>
                        </div>

                    </div>
                </div>
            </form>
        </div>
    </div>
@endsection
