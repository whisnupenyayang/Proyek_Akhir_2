@extends('admin.layouts.admin')

@section('title', 'Tambah Resep')

@section('content')
    <style>
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

        @media (max-width: 767px) {
            h1 {
                font-size: 1.6em;
            }

            .container {
                padding: 15px;
            }

            .form-control {
                font-size: 1em;
            }

            .btn-success {
                font-size: 1.1em;
            }
        }

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

    <div class="container">




        <form action="{{ route('resep.store') }}" method="POST" enctype="multipart/form-data">
            @csrf

            <div class="mb-3">
                <label for="nama_resep" class="form-label">Nama Resep</label>
                <input type="text" class="form-control" id="nama_resep" name="nama_resep" required>
            </div>

            <div class="mb-3">
                <label for="deskripsi_resep" class="form-label">Deskripsi Resep</label>
                <textarea class="form-control" id="deskripsi_resep" name="deskripsi_resep" required></textarea>
            </div>

            <div class="mb-3">
                <label for="gambar_resep" class="form-label">Gambar Resep</label>
                <input type="file" class="form-control @error('gambar_resep') is-invalid @enderror" id="gambar_resep" name="gambar_resep" accept="image/*">
                @error('gambar_resep')
                    <div class="invalid-feedback">
                        {{ $message }}
                    </div>
                @enderror
            </div>

            <button type="submit" class="btn btn-success">Simpan Resep</button>
        </form>
    </div>
@endsection
