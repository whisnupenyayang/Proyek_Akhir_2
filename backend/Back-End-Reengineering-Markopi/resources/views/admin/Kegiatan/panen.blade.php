@extends('admin.layouts.admin')

@section('content')
<style>
    /* Tombol Add (Tambah) bundar */
    .add-btn {
        background-color: #004085;
        color: white;
        padding: 10px 14px;
        border-radius: 50%;
        text-align: center;
        text-decoration: none;
        font-size: 24px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        transition: background-color 0.3s ease;
        display: inline-flex;
        align-items: center;
        justify-content: center;
    }

    .add-btn:hover {
        background-color: #003366;
        color: white;
        text-decoration: none;
    }

    /* Tombol panah > bundar dan warna sama dengan tombol tambah */
    .next-button {
        background-color: #004085;
        color: white;
        border: none;
        border-radius: 50%;
        width: 32px;
        height: 32px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        font-size: 20px;
        cursor: pointer;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        transition: background-color 0.3s ease;
        padding: 0;
    }

    .next-button:hover {
        background-color: #003366;
        color: white;
    }
</style>

<!-- Material Icons CDN -->
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<!-- Filter Jenis Kopi -->
<div class="row mb-3">
    <div class="col-md-4">
        <form method="GET" action="{{ route('kegiatan.panen') }}">
            <div class="form-group">
                <label for="jenis_kopi">Pilih Jenis Kopi</label>
                <select name="jenis_kopi" id="jenis_kopi" class="form-control">
                    <option value="">Semua</option>
                    <option value="Arabika" {{ request('jenis_kopi') == 'Arabika' ? 'selected' : '' }}>Arabika</option>
                    <option value="Robusta" {{ request('jenis_kopi') == 'Robusta' ? 'selected' : '' }}>Robusta</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary mt-2">Terapkan Filter</button>
        </form>
    </div>
</div>

<div class="row">
    <section class="col-lg-12 connectedSortable">
        <div class="card-body">
            @foreach ($tahapanPanen->groupBy('nama_tahapan') as $namaTahapan => $tahapans)
            <a href="{{ route('kegiatan.data_panen', ['nama_tahapan' => Str::slug($namaTahapan), 'jenis_kopi' => request('jenis_kopi')]) }}"
                class="tahapan-item mb-3 p-3 border rounded d-flex justify-content-between align-items-center text-decoration-none text-dark">
                <div class="tahapan-text">
                    <h5 class="mb-0">
                        {{ $namaTahapan }}
                    </h5>
                </div>
                <button class="btn btn-sm next-button" type="button">&gt;</button>
            </a>
            @endforeach
        </div>

        <!-- Tombol Tambah Informasi Panen -->
        <div style="display: flex; justify-content: flex-end; margin-bottom: 30px;">
            <a href="{{ route('kegiatan.panen.create') }}" class="add-btn" title="Tambah Informasi Panen">
                <span class="material-icons">add</span>
            </a>
        </div>
    </section>
</div>
@endsection
