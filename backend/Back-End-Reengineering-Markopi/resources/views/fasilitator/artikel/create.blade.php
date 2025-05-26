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
                    <form action="{{ route('artikel.create') }}" method="POST" enctype="multipart/form-data">
                        @csrf
                        <div class="card-body">
                            <div class="form-group">
                                <label for="judul_artikel">judul</label>
                                {{-- {!! Form::text('tahapan', null, ['class' => 'form-control', 'autofocus']) !!} --}}
                                <input type="text" id="judul_artikel" name="judul_artikel" class="form-control">
                                <span class="text-danger">{{ $errors->first('judul_artikel') }}</span>
                            </div>

                            <div class="form-group">
                                <label for="isi_artikel">Isi Artikel</label>
                                <!-- Menggunakan strip_tags() untuk menghilangkan tag HTML -->
                                <textarea id="isi_artikel" name="isi_artikel" class="form-control auto-resize-textarea"></textarea>
                                <span class="text-danger">{{ $errors->first('isi_artikel') }}</span>
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
            .create(document.querySelector('#isi_artikel'))
            .catch(error => {
                console.error(error);
            });
    </script>
@endsection
