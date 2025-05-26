@extends('admin.layouts.admin')

@section('content')
<style>
    .card {
        display: flex;
        flex-direction: row;
        align-items: center;
        border: 1px solid #ddd;
        border-radius: 8px;
        margin-bottom: 20px;
        padding: 15px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    }

    .card img {
        width: 120px;
        height: 120px;
        object-fit: cover;
        border-radius: 8px;
        margin-right: 20px;
    }

    .card-info {
        flex: 1;
    }

    .card-info h5 {
        font-size: 18px;
        font-weight: 600;
        margin-bottom: 15px;
    }

    .card-info p {
        margin: 4px 0;
        font-size: 14px;
    }

    .card-info strong {
        font-weight: 600;
    }

    .selengkapnya {
        display: inline-block;
        margin-top: 10px;
        font-size: 14px;
        color: #007bff;
        text-decoration: none;
    }

    .selengkapnya:hover {
        text-decoration: underline;
    }
</style>

<div class="row">
    <section class="col-lg-12 connectedSortable" style="position: relative;">
        @forelse ($pengepuls as $pengepul)
        <div class="card">
            {{-- Ganti sesuai kolom gambar yang kamu gunakan --}}
            <img src="{{ asset('images/' . $pengepul->nama_gambar) }}" alt="Foto Pengepul">

            <div class="card-info">
                <h5>{{ $pengepul->nama }}</h5>
                <p><strong>Alamat:</strong> {{ $pengepul->alamat }}</p>
                <p><strong>Jenis Kopi:</strong> {{ $pengepul->jenis_kopi }}</p>
                <p><strong>Jenis Produk:</strong> {{ $pengepul->jenis_produk }}</p>
                <p><strong>Harga/kg:</strong> Rp{{ number_format($pengepul->harga, 0, ',', '.') }}</p>
                <a href="{{ route('pengepul.show', $pengepul->id) }}" class="selengkapnya">Selengkapnya</a>
            </div>
        </div>
        @empty
        <div class="text-center text-muted">Belum ada data pengepul.</div>
        @endforelse

        <div style="display: flex; justify-content: flex-end; gap: 10px; margin-bottom: 20px;">
            <a href="{{ route('pengepul.create') }}" class="add-btn">
                <span class="material-icons">add</span>
            </a>
        </div>
    </section>
</div>
@endsection
