<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tambah Data Pengepul</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        .container {
            max-width: 100%;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 8px;
        }
        h1 {
            text-align: center;
            margin-bottom: 20px;
            font-size: 1.8em;
        }
        .btn-back {
            margin-bottom: 15px;
            font-size: 1.2em;
        }
        .mb-3 label {
            font-size: 1.1em;
            font-weight: 500;
        }
        .form-control {
            font-size: 1em;
            padding: 10px;
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            font-size: 1.1em;
        }
        .form-control-file {
            padding: 5px;
        }
        @media (max-width: 767px) {
            h1 { font-size: 1.6em; }
            .container { padding: 15px; }
        }
        @media (min-width: 768px) {
            .container { max-width: 800px; padding: 30px; }
            h1 { font-size: 2em; }
            .btn-submit { width: auto; padding: 12px 30px; }
        }
    </style>
</head>

<body>
    <div class="container mt-4">
        <a href="{{ route('admin.pengepul') }}" class="btn btn-primary btn-back">
            <i class="bi bi-arrow-left"></i> Kembali
        </a>

        <h1>Tambah Data Pengepul</h1>

        <form action="{{ route('pengepul.store') }}" method="POST" enctype="multipart/form-data">
            @csrf

            <!-- Nama Toko -->
            <div class="mb-3">
                <label for="nama_toko" class="form-label">Nama Toko</label>
                <input type="text" class="form-control" id="nama_toko" name="nama_toko" value="{{ old('nama_toko') }}" required maxlength="100" />
                @error('nama_toko')
                    <div class="text-danger">{{ $message }}</div>
                @enderror
            </div>

            <!-- Alamat -->
            <div class="mb-3">
                <label for="alamat" class="form-label">Alamat</label>
                <input type="text" class="form-control" id="alamat" name="alamat" value="{{ old('alamat') }}" required maxlength="255" />
                @error('alamat')
                    <div class="text-danger">{{ $message }}</div>
                @enderror
            </div>

            <!-- Jenis Kopi -->
            <div class="mb-3">
                <label for="jenis_kopi" class="form-label">Jenis Kopi</label>
                <select class="form-select" id="jenis_kopi" name="jenis_kopi" required>
                    <option value="">Pilih Jenis Kopi</option>
                    <option value="Arabika" {{ old('jenis_kopi') == 'Arabika' ? 'selected' : '' }}>Arabika</option>
                    <option value="Robusta" {{ old('jenis_kopi') == 'Robusta' ? 'selected' : '' }}>Robusta</option>
                </select>
                @error('jenis_kopi')
                    <div class="text-danger">{{ $message }}</div>
                @enderror
            </div>

            <!-- Harga -->
            <div class="mb-3">
                <label for="harga" class="form-label">Harga (Rp)</label>
                <input type="number" class="form-control" id="harga" name="harga" value="{{ old('harga') }}" required step="0.01" />
                @error('harga')
                    <div class="text-danger">{{ $message }}</div>
                @enderror
            </div>

            <!-- Nomor Telepon -->
            <div class="mb-3">
                <label for="nomor_telepon" class="form-label">Nomor Telepon</label>
                <input type="text" class="form-control" id="nomor_telepon" name="nomor_telepon" value="{{ old('nomor_telepon') }}" required maxlength="20" />
                @error('nomor_telepon')
                    <div class="text-danger">{{ $message }}</div>
                @enderror
            </div>

            <!-- Upload Gambar -->
            <div class="mb-3">
                <label for="gambar" class="form-label">Gambar Toko</label>
                <input type="file" class="form-control" id="gambar" name="gambar" accept="image/jpeg,image/png,image/jpg,image/gif,image/svg" />
                <small class="text-muted">Format: JPEG, PNG, JPG, GIF, SVG (Maksimal 5MB)</small>
                @error('gambar')
                    <div class="text-danger">{{ $message }}</div>
                @enderror
            </div>

            <button type="submit" class="btn btn-primary btn-submit">Simpan</button>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
