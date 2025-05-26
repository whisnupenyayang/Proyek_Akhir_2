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
                    {{-- {!! Form::model($model, ['route' => $route, 'method' => $method, 'files' => true, 'enctype' => 'multipart/form-data']) !!} --}}
                    <form action="{{ route('budidaya.store') }}" method="POST" enctype="multipart/form-data">
                        @csrf
                        <div class="card-body">
                            <div class="form-group">
                                <label for="kategori">Kategori</label>
                                <select id="kategori" name="kategori" class="form-control" autofocus>
                                    <option value="">Pilih Kategori</option>
                                    <option value="Pemilihan Lahan">Pemilihan Lahan</option>
                                    <option value="Kesesuaian Lahan">Kesesuaian Lahan</option>
                                    <option value="Persiapan Lahan">Persiapan Lahan</option>
                                    <option value="Penanaman Penaung">Penanaman Penaung</option>
                                    <option value="Bahan Tanam Unggul">Bahan Tanam Unggul</option>
                                    <option value="Pembibitan">Pembibitan</option>
                                    <option value="Penanaman">Penanaman</option>
                                    <option value="Pemupukan">Pemupukan</option>
                                    <option value="Pemangkasan">Pemangkasan</option>
                                    <option value="Pengelolaan Penaung">Pengelolaan Penaung</option>
                                    <option value="Pengendalian Hama">Pengendalian Hama</option>
                                </select>
                                <span class="text-danger">{{ $errors->first('kategori') }}</span>
                            </div>
                            <div class="form-group">
                                <label for="tahapan">Tahapan</label>
                                {{-- {!! Form::text('tahapan', null, ['class' => 'form-control', 'autofocus']) !!} --}}
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
                                {{-- {!! Form::text('link', null, ['class' => 'form-control']) !!} --}}
                                <input type="text" id="link" name="link" class="form-control">
                                <span class="text-danger">{{ $errors->first('link') }}</span>
                            </div>

                            <div class="form-group">
                                <label for="credit_gambar">Credit Gambar</label>
                                {{-- {!! Form::text('credit_gambar', null, ['class' => 'form-control']) !!} --}}
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
        function handleNewInput(input) {
            input.addEventListener('change', function(e) {
                const previewImages = document.getElementById('previewImages');
                const img = document.createElement('img');
                img.onload = function() {
                    URL.revokeObjectURL(img.src);
                };
                img.src = URL.createObjectURL(e.target.files[0]);
                img.style.width = '100px';
                img.style.marginRight = '5px';
                img.style.marginBottom = '5px';
                previewImages.appendChild(img);
            });
        }

        const addImageBtn = document.getElementById('addImageBtn');
        const fileInput = document.getElementById('gambar');

        addImageBtn.addEventListener('click', function() {
            const newInput = fileInput.cloneNode(true);
            newInput.value = '';
            fileInput.parentNode.insertBefore(newInput, fileInput.nextSibling);
            handleNewInput(newInput);
        });

        // Panggil handleNewInput untuk input pertama saat halaman dimuat
        handleNewInput(fileInput);
    </script>
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
