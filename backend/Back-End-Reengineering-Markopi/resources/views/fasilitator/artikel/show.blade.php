@extends('fasilitator.layouts.dashboard')
@section('content')
    <div class="row">
        <div class="col-lg-12">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Detail Artikel</h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body">
                    <h5 class="card-title">Judul: {{ $artikel['judul_artikel'] }}</h5>
                    <p class="card-text">Deskripsi: {!! $artikel['isi_artikel'] !!}</p>
                    <div class="card-body">
                        <h5 class="card-title">Gambar</h5>
                        <div id="carouselExampleIndicators{{ $artikel->id_artikels }}" class="carousel slide" data-bs-ride="carousel">
                            <!-- Carousel Indicators -->
                            <div class="carousel-indicators">
                                @foreach ($artikel->images as $key => $image)
                                    <button type="button" data-bs-target="#carouselExampleIndicators{{ $artikel->id_artikels }}" data-bs-slide-to="{{ $key }}" class="{{ $key === 0 ? 'active' : '' }}" aria-current="{{ $key === 0 ? 'true' : 'false' }}" aria-label="Slide {{ $key + 1 }}"></button>
                                @endforeach
                            </div>
                            <!-- Carousel Inner -->
                            <div class="carousel-inner">
                                @foreach ($artikel->images as $key => $image)
                                    <div class="carousel-item {{ $key === 0 ? 'active' : '' }}">
                                        <img src="{{ asset('storage/' . $image->gambar) }}" class="d-block w-100" style="width: 500px; height: 500px;" alt="...">
                                    </div>
                                @endforeach
                            </div>
                            <!-- Carousel Controls -->
                            <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators{{ $artikel->id_artikels }}" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators{{ $artikel->id_artikels }}" data-bs-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            </button>
                        </div>
                    </div>
                </div>
                <!-- /.card-body -->
            </div>
            <!-- /.card -->
        </div>
        <!-- /.col-lg-12 -->
    </div>
    <!-- /.row -->
@endsection
