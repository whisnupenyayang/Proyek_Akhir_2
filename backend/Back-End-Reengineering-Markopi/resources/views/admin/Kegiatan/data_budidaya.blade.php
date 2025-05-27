@extends('admin.layouts.admin')

@section('content')
    <h2>Tahapan Budidaya: {{ $namaTahapan }}</h2>

    @if ($jenisKopi)
        <p><strong>Jenis Kopi yang Dipilih:</strong> {{ $jenisKopi }}</p>
    @endif

    <div class="row">
        <section class="col-lg-12 connectedSortable">
            <div class="card-body">
                @foreach ($tahapanBudidaya as $tahapan)
                    <div class="card mb-3">
                        <div class="card-header">
                            <h5 class="mb-0">{{ $tahapan->nama_tahapan }}</h5>
                        </div>
                        <div class="card-body">
                            @foreach ($tahapan->jenisTahapanKegiatan as $jenis)
                                <div class="border rounded p-3 mb-3" id="jenis-{{ $jenis->id }}">

                                    <!-- Tampilan Default -->
                                    <div id="view-{{ $jenis->id }}">
                                        <h6>{{ $jenis->judul }}</h6>
                                        <p>{{ $jenis->deskripsi }}</p>

                                        @if ($jenis->url_gambar)
                                            <div class="mt-2">
                                                <img src="{{ asset('storage/' . $jenis->url_gambar) }}" alt="Gambar" style="max-width: 200px;">
                                            </div>
                                        @endif

                                        @if ($jenis->nama_file)
                                            <div class="mt-2">
                                                <a href="{{ asset('storage/' . $jenis->nama_file) }}" download>Download File</a>
                                            </div>
                                        @endif

                                        <div class="d-flex gap-2 mt-3">
                                            <button class="btn btn-warning btn-sm" onclick="toggleEdit({{ $jenis->id }})">
                                                <i class="fas fa-pencil-alt"></i> Edit
                                            </button>

                                            <form action="{{ route('jenisTahapanKegiatan.destroy', $jenis->id) }}" method="POST" onsubmit="return confirm('Apakah Anda yakin ingin menghapus data ini?');">
                                                @csrf
                                                @method('DELETE')
                                                <button type="submit" class="btn btn-danger btn-sm">
                                                    <i class="fas fa-trash-alt"></i> Hapus
                                                </button>
                                            </form>
                                        </div>
                                    </div>

                                    <!-- Form Edit -->
                                    <div id="form-{{ $jenis->id }}" style="display: none;">
                                        <form action="{{ route('jenisTahapanKegiatan.update', $jenis->id) }}" method="POST" enctype="multipart/form-data"
                                              onsubmit="return confirm('Apakah Anda yakin ingin menyimpan perubahan ini?');">
                                            @csrf
                                            @method('PUT')

                                            <div class="mb-2">
                                                <label>Judul</label>
                                                <input type="text" name="judul" class="form-control" value="{{ $jenis->judul }}">
                                            </div>

                                            <div class="mb-2">
                                                <label>Deskripsi</label>
                                                <textarea name="deskripsi" class="form-control" rows="3">{{ $jenis->deskripsi }}</textarea>
                                            </div>

                                            <div class="mb-2">
                                                <label>Gambar</label>
                                                <input type="file" name="url_gambar" class="form-control">
                                                @if ($jenis->url_gambar)
                                                    <div class="mt-2">
                                                        <p>Gambar saat ini:</p>
                                                        <img src="{{ asset('storage/' . $jenis->url_gambar) }}" alt="Gambar" style="max-width: 150px;">
                                                    </div>
                                                @endif
                                            </div>

                                            <div class="mb-2">
                                                <label>File</label>
                                                <input type="file" name="nama_file" class="form-control">
                                                @if ($jenis->nama_file)
                                                    <div class="mt-2">
                                                        <p>File saat ini:
                                                            <a href="{{ asset('storage/' . $jenis->nama_file) }}" download>
                                                                {{ basename($jenis->nama_file) }}
                                                            </a>
                                                        </p>
                                                    </div>
                                                @endif
                                            </div>

                                            <div class="d-flex gap-2 mt-2">
                                                <button type="submit" class="btn btn-success btn-sm">Simpan</button>
                                                <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit({{ $jenis->id }})">Batal</button>
                                            </div>
                                        </form>
                                    </div>

                                </div>
                            @endforeach
                        </div>
                    </div>
                @endforeach
            </div>
        </section>
    </div>

    <!-- JavaScript Toggle -->
    <script>
        function toggleEdit(id) {
            const view = document.getElementById('view-' + id);
            const form = document.getElementById('form-' + id);
            if (view.style.display === 'none') {
                view.style.display = 'block';
                form.style.display = 'none';
            } else {
                view.style.display = 'none';
                form.style.display = 'block';
            }
        }
    </script>
@endsection
