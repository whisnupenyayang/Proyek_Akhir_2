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

    /* Buat card clickable */
    .tahapan-item-link {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 1rem;
        margin-bottom: 1rem;
        border: 1px solid #ddd;
        border-radius: 0.375rem;
        text-decoration: none;
        color: inherit;
        transition: background-color 0.2s ease;
    }
    .tahapan-item-link:hover {
        background-color: #f0f0f0;
        text-decoration: none;
        color: inherit;
    }

    /* Tombol panah bundar dan warna sama dengan tombol tambah */
    .next-button {
        pointer-events: none; /* supaya tombol tidak mengganggu klik link */
        user-select: none;
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
        padding: 0;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        transition: background-color 0.3s ease;
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
        <form method="GET" action="{{ route('kegiatan.pascapanen') }}">
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
            @forelse ($tahapanPascapanen->groupBy('nama_tahapan') as $namaTahapan => $tahapans)
            <a href="{{ route('kegiatan.data_pascapanen', ['nama_tahapan' => Str::slug($namaTahapan), 'jenis_kopi' => request('jenis_kopi')]) }}"
                class="tahapan-item-link">
                <div class="tahapan-text">
                    <h5 class="mb-0">{{ $namaTahapan }}</h5>
                </div>
                <button class="btn btn-sm next-button" type="button">&gt;</button>
            </a>
            @empty
            <div class="text-center text-muted">Belum ada data pasca panen.</div>
            @endforelse
        </div>

        <!-- Tombol Tambah Informasi Pasca Panen -->
        <div style="display: flex; justify-content: flex-end; margin-bottom: 30px;">
            <a href="{{ route('kegiatan.pascapanen.create') }}" class="add-btn" title="Tambah Informasi Pasca Panen">
                <span class="material-icons">add</span>
            </a>
        </div>
    </section>
</div>
@endsection
