<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tambah Toko</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Base Styles for Mobile */
        .container {
            max-width: 100%;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
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

        /* Form Styling */
        .mb-3 label {
            font-size: 1.1em;
        }

        .form-control {
            font-size: 1em;
            padding: 10px;
        }

        .btn-success {
            width: 100%;
            padding: 12px;
            font-size: 1.1em;
        }

        /* Responsive styles for Mobile devices (max-width: 767px) */
        @media (max-width: 767px) {
            h1 {
                font-size: 1.6em; /* Adjust font size for small screens */
            }

            .container {
                padding: 15px;
            }

            .form-control {
                font-size: 1em; /* Adjust font size for mobile devices */
            }

            .btn-success {
                font-size: 1.1em;
            }
        }

        /* Responsive styles for Desktop (min-width: 768px) */
        @media (min-width: 768px) {
            .container {
                max-width: 800px;
                padding: 30px;
            }

            h1 {
                font-size: 2em;
            }

            .btn-success {
                width: auto;
                padding: 12px 30px;
            }

            .mb-3 label {
                font-size: 1.2em;
            }

            .form-control {
                font-size: 1.1em;
                padding: 12px;
            }
        }
    </style>
</head>
<body>

    <div class="container">
        <a href="{{ route('admin.toko') }}" class="btn btn-primary btn-back"><i class="bi bi-arrow-left"></i> Kembali</a>
        <h1>Tambah Toko</h1>

        <!-- Form for creating a new store -->
        <form action="{{ route('toko.store') }}" method="POST" enctype="multipart/form-data">
            @csrf

            <div class="mb-3">
                <label for="nama_toko" class="form-label">Nama Toko</label>
                <input type="text" class="form-control" id="nama_toko" name="nama_toko" placeholder="Masukkan nama toko" required>
            </div>

            <div class="mb-3">
                <label for="lokasi" class="form-label">Lokasi</label>
                <input type="text" class="form-control" id="lokasi" name="lokasi" placeholder="Masukkan lokasi toko" required>
            </div>

            <div class="mb-3">
                <label for="jam_operasional" class="form-label">Jam Operasional</label>
                <input type="text" class="form-control" id="jam_operasional" name="jam_operasional" placeholder="Masukkan jam operasional toko" required>
            </div>

            <div class="mb-3">
                <label for="foto_toko" class="form-label">Foto Toko</label>
                <input type="file" class="form-control" id="foto_toko" name="foto_toko">
            </div>

            <button type="submit" class="btn btn-success">Simpan Toko</button>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
