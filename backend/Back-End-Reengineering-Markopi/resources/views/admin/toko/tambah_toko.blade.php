@extends('admin.layouts.admin')

@section('title', 'Tambah Toko')

@push('styles')
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
@endpush

@section('content')



    <form action="{{ route('toko.store') }}" method="POST" enctype="multipart/form-data" id="tokoForm">
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
        <label for="jam_buka" class="form-label">Jam Buka</label>
        <input type="time" class="form-control" id="jam_buka" name="jam_buka" required>
    </div>

    <div class="mb-3">
        <label for="jam_tutup" class="form-label">Jam Tutup</label>
        <input type="time" class="form-control" id="jam_tutup" name="jam_tutup" required>
    </div>

    <!-- input tersembunyi untuk jam_operasional yang sudah digabung -->
    <input type="hidden" id="jam_operasional" name="jam_operasional" value="">

    <div class="mb-3">
        <label for="foto_toko" class="form-label">Foto Toko</label>
        <input type="file" class="form-control @error('foto_toko') is-invalid @enderror" id="foto_toko" name="foto_toko" accept="image/*">
        @error('foto_toko')
        <div class="invalid-feedback">{{ $message }}</div>
        @enderror
    </div>

    <button type="submit" class="btn btn-success">Simpan Toko</button>
</form>

<script>
    const form = document.getElementById('tokoForm');
    form.addEventListener('submit', function(e) {
        const jamBuka = document.getElementById('jam_buka').value;
        const jamTutup = document.getElementById('jam_tutup').value;

        if (!jamBuka || !jamTutup) {
            alert('Jam buka dan jam tutup harus diisi!');
            e.preventDefault();
            return;
        }

        // gabungkan jam buka dan tutup, lalu isi input hidden jam_operasional
        document.getElementById('jam_operasional').value = jamBuka + ' - ' + jamTutup;
    });
</script>
</div>
@endsection
