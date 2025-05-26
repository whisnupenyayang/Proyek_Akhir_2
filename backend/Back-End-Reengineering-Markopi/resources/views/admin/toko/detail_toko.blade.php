<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detail Toko</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
        }

        .btn-back {
            margin-bottom: 15px;
            font-size: 1.2em;
        }

        .detail-card {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .detail-card img {
            width: 100%;
            height: auto;
            border-radius: 8px;
        }

        .action-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        .btn-trash {
            background-color: #f44336;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 1.2em;
            border-radius: 50%;
            cursor: pointer;
        }

        .btn-trash:hover {
            background-color: #d32f2f;
        }

        .btn-trash i {
            font-size: 1.5em;
        }

        .save-btn {
            color: #28a745;
            cursor: pointer;
        }

        .save-btn:hover {
            text-decoration: underline;
        }

        .input-field {
            width: 100%;
            padding: 8px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>

    <div class="container">
        <a href="{{ route('admin.toko') }}" class="btn btn-primary btn-back"><i class="bi bi-arrow-left"></i> Kembali</a>
        <h1>Detail Toko</h1>

        <div class="detail-card">
            <!-- Nama Toko -->
            <div class="field-container">
                <h3 id="toko-name">{{ $toko->nama_toko }}</h3>
            </div>

            <!-- Lokasi Toko -->
            <div class="field-container">
                <p id="toko-lokasi"><strong>Lokasi:</strong> <a href="{{ $toko->lokasi }}" target="_blank">{{ $toko->lokasi }}</a></p>
            </div>

            <!-- Jam Operasional Toko -->
            <div class="field-container">
                <p id="toko-jam"><strong>Jam Operasional:</strong> {{ $toko->jam_operasional }}</p>
            </div>

            <!-- Deskripsi Toko -->
            <div class="field-container">
                <p id="toko-desc"><strong>Deskripsi:</strong> {{ $toko->deskripsi }}</p>
            </div>

            <!-- Foto Toko -->
            <div class="field-container">
                @if($toko->foto_toko)
                    <img id="current-image" src="{{ asset('images/' . $toko->foto_toko) }}" alt="Foto Toko">
                @else
                    <p>Tidak ada foto toko.</p>
                @endif
            </div>
        </div>

        <!-- Action buttons -->
        <div class="action-buttons">
            <!-- Delete button (trash icon) -->
            <form action="{{ route('toko.destroy', $toko->id) }}" method="POST">
                @csrf
                @method('DELETE')
                <button type="submit" class="btn-trash">
                    <i class="bi bi-trash"></i>
                </button>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
