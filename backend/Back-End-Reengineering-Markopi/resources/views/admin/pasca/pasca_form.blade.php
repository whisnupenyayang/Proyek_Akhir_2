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
                        <h3 class="card-title">Form tambah data Produk</h3>
                    </div>
                    <form action="{{ route('pasca.store') }}" method="POST" enctype="multipart/form-data">
                        @csrf
                        <div class="card-body">
                            <div class="form-group">
                                <label for="kategori">Kategori</label>
                                <select id="kategori" name="kategori" class="form-control" autofocus>
                                    <option value="">Pilih Kategori</option>
                                    <option value="Fermentasi Kering">Fermentasi Kering</option>
                                    <option value="Fermentasi Mekanis">Fermentasi Mekanis</option>
                                </select>
                                <span class="text-danger">{{ $errors->first('kategori') }}</span>
                            </div>
                            <div class="form-group">
                                <label for="tahapan">Tahapan</label>
                                <input type="text" id="tahapan" name="tahapan" class="form-control">
                                <span class="text-danger">{{ $errors->first('tahapan') }}</span>
                            </div>

                            <div class="form-group">
                                <label for="deskripsi">Deskripsi</label>
                                <!-- Menggunakan strip_tags() untuk menghilangkan tag HTML -->
                                <textarea id="deskripsi" name="deskripsi" class="form-control auto-resize-textarea"></textarea>
                                <span class="text-danger">{{ $errors->first('deskripsi') }}</span>
                            </div>

                            <div class="form-group">
                                <label for="link">Link</label>
                                <input type="text" id="link" name="link" class="form-control">
                                <span class="text-danger">{{ $errors->first('link') }}</span>
                            </div>

                            <div class="form-group">
                                <label for="credit_gambar">Credit Gambar</label>
                                <input type="text" id="credit_gambar" name="credit_gambar" class="form-control">
                                <span class="text-danger">{{ $errors->first('credit_gambar') }}</span>
                            </div>

                            <div class="form-group">
                                <label for="gambar">Gambar</label>
                                {{-- {!! Form::file('gambar', ['class' => 'form-control']) !!} --}}
                                <input type="file" id="gambar" name="gambar[]" class="form-control" multiple>
                                <span class="text-danger">{{ $errors->first('gambar.*') }}</span>

                                <div id="previewImages"></div>

                                {{-- <button type="button" id="addImageBtn" class="btn btn-primary">Tambah Gambar</button> --}}
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
        document.addEventListener("input", function(e) {
            if (e.target && e.target.classList.contains("auto-resize-textarea")) {
                autoResizeTextarea(e.target);
            }
        });

        function autoResizeTextarea(textarea) {
            textarea.style.height = "auto";
            textarea.style.height = (textarea.scrollHeight) + "px";
        }

        // Trigger auto-resize saat halaman dimuat
        document.addEventListener("DOMContentLoaded", function() {
            document.querySelectorAll('.auto-resize-textarea').forEach(function(textarea) {
                autoResizeTextarea(textarea);
            });
        });
    </script>
    <script>
        ClassicEditor
            .create(document.querySelector('#deskripsi'))
            .catch(error => {
                console.error(error);
            });
    </script>
@endsection
