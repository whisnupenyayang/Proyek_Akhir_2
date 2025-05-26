@extends('fasilitator.layouts.dashboard')

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
                        <h3 class="card-title">Form tambah data Artikel</h3>
                    </div>
                    {{-- {!! Form::model($model, ['route' => $route, 'method' => $method, 'files' => true, 'enctype' => 'multipart/form-data']) !!} --}}
                    <form action="{{ route('artikel.update', $artikel['id_artikels']) }}" method="POST" enctype="multipart/form-data">
                        @csrf
                        @method('PUT')
                        <div class="card-body">
                            <div class="form-group">
                                <label for="judul_artikel">Judul Artikel</label>
                                {{-- {!! Form::text('tahapan', null, ['class' => 'form-control', 'autofocus']) !!} --}}
                                <input type="text" id="judul_artikel" name="judul_artikel" class="form-control"
                                    value="{{ $artikel->judul_artikel }}">
                                <span class="text-danger">{{ $errors->first('judul_artikel') }}</span>
                            </div>

                            <div class="form-group">
                                <label for="isi_artikel">Isi Artikel</label>
                                {{-- {!! Form::textarea('deskripsi', null, ['class' => 'form-control']) !!} --}}
                                <textarea id="isi_artikel" name="isi_artikel" class="form-control" value="{{ $artikel->isi_artikel }}">{{ $artikel->isi_artikel }}</textarea>
                                <span class="text-danger">{{ $errors->first('isi_artikel') }}</span>
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
            .create(document.querySelector('#isi_artikel'))
            .catch(error => {
                console.error(error);
            });
    </script>
@endsection
