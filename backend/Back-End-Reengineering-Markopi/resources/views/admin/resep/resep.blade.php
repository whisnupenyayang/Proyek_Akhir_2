@extends('admin.layouts.admin')

@section('content')
    <h1>{{ $title }}</h1> <!-- Menampilkan title halaman -->

    @if (session('success'))
        <div class="alert alert-success">
            {{ session('success') }}
        </div>
    @endif

    <div class="row">
        @foreach ($resep as $t)
            <div class="col-md-4">
                <div class="card">
                    <img src="{{ asset('images/' . $t->gambar_resep) }}" alt="Foto resep">
                    <div class="card-body">
                        <h5>{{ $t->nama_resep }}</h5>
                        <p>{{ $t->deskripsi_resep }}</p>
                        <a href="{{ route('resep.detail', $t->id) }}" class="btn btn-primary">Detail</a>
                    </div>
                </div>
            </div>
        @endforeach
    </div>

    <div style="display: flex; justify-content: flex-end; gap: 10px; margin-bottom: 20px;">
        <a href="{{ route('resep.create') }}" class="btn btn-success">
            Tambah Resep
        </a>
    </div>
@endsection
