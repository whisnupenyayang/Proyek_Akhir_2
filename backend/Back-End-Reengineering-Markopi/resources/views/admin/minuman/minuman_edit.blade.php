@extends('admin.layouts.dashboard')

@section('content')
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-12">
                @if (session('success'))
                    <div class="alert alert-success">
                        {{ session('success') }}
                    </div>
                @endif

                @if (session('error'))
                    <div class="alert alert-danger">
                        {{ session('error') }}
                    </div>
                @endif

                <div class="card card-primary">
                    <div class="card-header">
                        <h3 class="card-title">Form data edit Minuman</h3>
                    </div>
                    <form action="{{ route('minuman.update', $minuman['id_minumans']) }}" method="POST" enctype="multipart/form-data">
                        @csrf
                        @method('PUT')
                        <div class="card-body">
                            <div class="form-group">
                                <label for="nama_minuman">Nama Minuman</label>
                                <input type="text" id="nama_minuman" name="nama_minuman" class="form-control"
                                    value="{{ $minuman->nama_minuman }}">
                                <span class="text-danger">{{ $errors->first('nama_minuman') }}</span>
                            </div>
                            <div class="form-group">
                                <label for="bahan_minuman">Bahan-bahan</label>
                                <textarea id="bahan_minuman" name="bahan_minuman" class="form-control" value="{{ $minuman->bahan_minuman }}">{!! $minuman->bahan_minuman !!}</textarea>
                                <span class="text-danger">{{ $errors->first('bahan_minuman') }}</span>
                            </div>
                            <div class="form-group">
                                <label for="langkah_minuman">Langkah-langkah</label>
                                <textarea id="langkah_minuman" name="langkah_minuman" class="form-control" value="{{ $minuman->langkah_minuman }}">{!! $minuman->langkah_minuman !!}</textarea>
                                <span class="text-danger">{{ $errors->first('langkah_minuman') }}</span>
                            </div>
                            <div class="form-group">
                                <label for="credit_gambar">Credit Gambar</label>
                                <input type="text" id="credit_gambar" name="credit_gambar" class="form-control"
                                    value="{{ $minuman->credit_gambar }}">
                                <span class="text-danger">{{ $errors->first('credit_gambar') }}</span>
                            </div>
                            <div class="form-group">
                                <label for="gambar">Gambar</label>
                                <input type="file" id="gambar" name="gambar[]" class="form-control" multiple>
                                <span class="text-danger">{{ $errors->first('gambar.*') }}</span>
                            </div>
                        </div>
                        <div class="card-footer">
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="col-md-6"></div>
        </div>
    </div>
    <script>
        ClassicEditor
            .create(document.querySelector('#bahan_minuman'))
            .catch(error => {
                console.error(error);
            });
    </script>
    <script>
        ClassicEditor
            .create(document.querySelector('#langkah_minuman'))
            .catch(error => {
                console.error(error);
            });
    </script>
@endsection
