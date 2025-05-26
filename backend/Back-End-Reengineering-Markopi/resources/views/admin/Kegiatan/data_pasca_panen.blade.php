@extends('admin.layouts.admin')

@section('content')
<h2>{{ $title }} - Tahapan Pasca Panen: {{ $namaTahapan }}</h2>

@if ($jenisKopi)
    <p><strong>Jenis Kopi yang Dipilih:</strong> {{ $jenisKopi }}</p>
@endif

<div class="row">
    <section class="col-lg-12 connectedSortable">
        <div class="card-body">
            @foreach ($tahapanPascaPanen as $tahapan)
                <div class="card mb-3">
                    <div class="card-header">
                        <h5 class="mb-0">{{ $tahapan->nama_tahapan }}</h5>
                    </div>
                    <div class="card-body">
                        <p><strong>Kegiatan:</strong> {{ $tahapan->kegiatan }}</p>
                        <p><strong>Jenis Kopi:</strong> {{ $tahapan->jenis_kopi }}</p>

                        @foreach ($tahapan->jenisTahapanKegiatan as $jenis)
                            <div class="border rounded p-3 mb-2">
                                <h6>{{ $jenis->judul }}</h6>
                                <p>{{ $jenis->deskripsi }}</p>

                                @if ($jenis->url_gambar)
                                    <img src="{{ asset('storage/' . $jenis->url_gambar) }}" alt="Gambar" style="max-width: 200px;">
                                @endif

                                @if ($jenis->nama_file)
                                    <p><a href="{{ asset('storage/' . $jenis->nama_file) }}" download>Download File</a></p>
                                @endif
                            </div>
                        @endforeach

                    </div>
                </div>
            @endforeach
        </div>
    </section>
</div>
@endsection
