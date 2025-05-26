@extends('admin.layouts.admin')

@section('content')
    <h1>{{ $title }}</h1> <!-- Menampilkan Title -->
    
    @if(session('success'))
        <div class="alert alert-success">
            {{ session('success') }}
        </div>
    @endif

    <div class="row">
        @foreach ($toko as $t)
            <div class="col-md-4">
                <div class="card">
                    <img src="{{ asset('images/' . $t->foto_toko) }}" alt="Foto Toko">
                    <div class="card-body">
                        <h5>{{ $t->nama_toko }}</h5>
                        <p><strong>Lokasi:</strong> {{ $t->lokasi }}</p>
                        <p><strong>Jam Operasional:</strong> {{ $t->jam_operasional }}</p>
                        <a href="{{ route('toko.detail', $t->id) }}" class="btn btn-info">Detail</a>
                    </div>
                </div>
            </div>
        @endforeach
    </div>

    <div style="display: flex; justify-content: flex-end; gap: 10px; margin-bottom: 20px;">
        <a href="{{ route('toko.create') }}" class="btn btn-primary">
            Tambah Toko
        </a>
    </div>
@endsection
