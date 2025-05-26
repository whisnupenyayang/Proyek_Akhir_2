@extends('admin.layouts.admin')

@section('content')
    <div class="row">
        <div class="col-lg-12">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Detail Pasca Panen</h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <h5 class="card-title">Tahapan: {{ $pasca['tahapan'] }}</h5>
                    <p class="card-text">Deskripsi: {!! $pasca['deskripsi'] !!}</p>
                    <p class="card-text">Sumber Artikel: {{ $pasca['sumber_artikel'] }}</p>
                    <p class="card-text">Link Video: <a href="{{ $pasca['link'] }}">{{ $pasca['link'] }}</a></p>
                    <div class="card-body">
                        <h5 class="card-title">Gambar</h5>
                        <div id="carouselExampleIndicators{{ $pasca->id_pascas }}" class="carousel slide"
                            data-bs-ride="carousel">
                            <div class="carousel-indicators">
                                @php
                                    $gambarCount = count($pasca->images); // Menghitung jumlah gambar dari data yang diterima
                                @endphp
                                @for ($i = 0; $i < $gambarCount; $i++)
                                    <button type="button" data-bs-target="#carouselExampleIndicators{{ $pasca->id_pascas }}"
                                        data-bs-slide-to="{{ $i }}" class="{{ $i === 0 ? 'active' : '' }}"
                                        aria-label="Slide {{ $i + 1 }}"></button>
                                @endfor
                            </div>
                            <div class="carousel-inner">
                                @foreach ($pasca->images as $key => $image)
                                    <div class="carousel-item {{ $key === 0 ? 'active' : '' }}">
                                        <img src="{{ asset('storage/' . $image->gambar) }}"
                                            style="width: 500px; height: 500px;" alt="...">
                                    </div>
                                @endforeach
                            </div>
                            <button class="carousel-control-prev" type="button"
                                data-bs-target="#carouselExampleIndicators{{ $pasca->id_pascas }}" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button"
                                data-bs-target="#carouselExampleIndicators{{ $pasca->id_pascas }}" data-bs-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            </button>
                        </div>
                    </div>
                    <p class="card-text">Credit Gambar: {{ $pasca['credit_gambar'] }}</p>
                    <!-- Tambahan informasi atau fitur sesuai kebutuhan -->
                </div>
                <!-- /.card-body -->
            </div>
            <!-- /.card -->
        </div>
        <!-- /.col-lg-12 -->
    </div>
    <!-- /.row -->
@endsection
