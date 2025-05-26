@extends('admin.layouts.admin')

@section('content')
    <style>
        .card-body {
            display: flex;
            flex-direction: column;
            padding: 15px;
        }

        .card img {
            max-width: 100%;
            height: auto;
            border-radius: 5px;
            object-fit: cover;
        }

        .card {
            margin-bottom: 20px;
            border-radius: 5px;
            overflow: hidden;
        }

        .card .row {
            display: flex;
            flex-direction: row;
            align-items: stretch;
        }

        .card-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .card-text {
            font-size: 15px;
            line-height: 1.6;
        }

        .text-link {
            font-size: 14px;
            color: #007bff;
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
        }

        .text-link:hover {
            text-decoration: underline;
        }

        .btn-tambah {
            margin-top: 30px;
            text-align: center;
        }

        .btn-tambah a {
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .btn-tambah a:hover {
            background-color: #218838;
        }

        @media (max-width: 768px) {
            .card-body {
                padding: 10px;
            }

            .card .row {
                flex-direction: row !important;
            }

            .col-md-3 {
                max-width: 40%;
                padding-right: 10px;
            }

            .col-md-9 {
                max-width: 60%;
            }

            .card-title {
                font-size: 16px;
            }

            .card-text {
                font-size: 14px;
            }

            .text-link {
                width: 100%;
                text-align: left;
            }

            .btn-tambah {
                margin-top: 20px;
            }

            .btn-tambah a {
                width: 100%;
                display: block;
            }
        }
    </style>

    <script>
        function toggleEdit(id) {
            const form = document.getElementById('form-' + id);
            if (form.style.display === 'none') {
                form.style.display = 'block';
            } else {
                form.style.display = 'none';
            }
        }
    </script>

    <div class="row">
        <section class="col-lg-12 connectedSortable">
            <div class="card-body">
                @foreach ($iklans as $iklan)
                    <div class="card w-100">
                        <div class="row g-0">
                            <div class="col-md-3">
                                <img src="{{ asset('foto/' . $iklan->gambar) }}" alt="Foto Produk" class="profile-img">
                            </div>
                            <div class="col-md-9">
                                <div class="card-body">
                                    <h5 class="card-title">{{ $iklan->judul_iklan }}</h5>
                                    <p class="card-text">
                                        <strong>Deskripsi:</strong> {{ $iklan->deskripsi_iklan }}<br>
                                        <strong>Kontak / Link:</strong>
                                        {!! preg_replace(
                                            '/(https?:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?)/',
                                            '<a href="$1" target="_blank" class="text-link">$1</a>',
                                            $iklan->link,
                                        ) !!}
                                    </p>
                                    <div class="d-flex gap-2 mt-2">
                                        {{-- Tombol Edit --}}
                                        <button onclick="toggleEdit({{ $iklan->id }})" class="btn btn-warning d-flex align-items-center gap-1" title="Edit Iklan">
                                            <span class="material-icons" style="font-size:16px;">edit</span> Edit
                                        </button>

                                        {{-- Tombol Hapus --}}
                                        <form action="{{ route('iklan.destroy', $iklan->id) }}" method="POST" onsubmit="return confirm('Yakin ingin menghapus iklan ini?')">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="btn btn-danger">Hapus</button>
                                        </form>
                                    </div>

                                    {{-- Form Edit (Hidden by default) --}}
                                    <div id="form-{{ $iklan->id }}" style="display: none;" class="mt-3">
                                        <form action="{{ route('iklan.update', $iklan->id) }}" method="POST" enctype="multipart/form-data">
                                            @csrf
                                            @method('PUT')

                                            <div class="mb-2">
                                                <label>Judul</label>
                                                <input type="text" name="judul_iklan" class="form-control" value="{{ $iklan->judul_iklan }}">
                                            </div>

                                            <div class="mb-2">
                                                <label>Deskripsi</label>
                                                <textarea name="deskripsi_iklan" class="form-control" rows="3">{{ $iklan->deskripsi_iklan }}</textarea>
                                            </div>

                                            <div class="mb-2">
                                                <label>Link</label>
                                                <input type="text" name="link" class="form-control" value="{{ $iklan->link }}">
                                            </div>

                                            <div class="mb-2">
                                                <label>Gambar (opsional)</label>
                                                <input type="file" name="gambar" class="form-control">
                                            </div>

                                            <button type="submit" class="btn btn-success btn-sm">Simpan</button>
                                            <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit({{ $iklan->id }})">Batal</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                @endforeach

                @if (count($iklans) === 0)
                    <div class="text-center text-muted">Belum ada data iklan.</div>
                @endif

                <div style="display: flex; justify-content: flex-end; gap: 10px; margin-bottom: 20px;">
                    <a href="{{ route('iklan.create') }}" class="add-btn">
                        <span class="material-icons">add</span>
                    </a>
                </div>
            </div>
        </section>
    </div>
@endsection
