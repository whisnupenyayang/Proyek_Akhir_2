@extends('admin.layouts.admin')

@section('content')
<style>
    .card {
        display: flex;
        flex-direction: row;
        align-items: center;
        border: 1px solid #ddd;
        border-radius: 8px;
        margin-bottom: 20px;
        padding: 15px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        background: white;
    }

    .card img.profile-img {
        width: 120px;
        height: 120px;
        object-fit: cover;
        border-radius: 8px;
        margin-right: 20px;
        flex-shrink: 0;
    }

    .card-info {
        flex: 1;
    }

    .card-info h5 {
        font-size: 18px;
        font-weight: 600;
        margin-bottom: 8px;
        color: #333;
    }

    .card-info p {
        margin: 4px 0;
        font-size: 14px;
        color: #555;
        line-height: 1.4;
    }

    .card-info strong {
        font-weight: 600;
    }

    .show-more {
        color: #007bff;
        cursor: pointer;
        font-size: 14px;
        margin-left: 5px;
        user-select: none;
    }

    .text-link {
        font-size: 14px;
        color: #007bff;
        text-decoration: none;
        display: inline-block;
        margin-top: 4px;
        word-break: break-word;
    }

    .text-link:hover {
        text-decoration: underline;
    }

    .btn-container {
        margin-top: 12px;
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
    }

    .edit-form {
        margin-top: 15px;
    }

    .btn-tambah {
        margin-top: 20px;
        text-align: right;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .card {
            padding: 10px;
        }

        .card img.profile-img {
            width: 135px;
            height: 130px;
            margin-right: 15px;
        }

        .card-info h5 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 4px;
            /* dari 8px jadi 4px */
            color: #333;
        }

        .card-info p {
            margin: 2px 0;
            font-size: 14px;
            color: #555;
            line-height: 1.4;
        }

        .text-link {
            font-size: 14px;
            color: #007bff;
            text-decoration: none;
            display: inline-block;
            margin-top: 2px;
            /* dari 4px jadi 2px */
            word-break: break-word;
        }

        .btn-container {
            margin-top: 8px;
            gap: 6px;
        }
    }
</style>

<script>
    function toggleEdit(id) {
        const form = document.getElementById('form-' + id);
        form.style.display = form.style.display === 'none' ? 'block' : 'none';
    }

    function toggleDescription(id) {
        const moreText = document.getElementById('more-text-' + id);
        const button = document.getElementById('show-more-' + id);

        if (moreText.style.display === 'inline') {
            moreText.style.display = 'none';
            button.innerText = 'Selengkapnya';
        } else {
            moreText.style.display = 'inline';
            button.innerText = 'Tutup';
        }
    }
</script>

<div class="row">
    <section class="col-lg-12 connectedSortable" style="position: relative;">
        @forelse ($iklans as $iklan)
        <div class="card w-100">
            <img src="{{ asset('foto/' . $iklan->gambar) }}" alt="Foto Produk" class="profile-img">

            <div class="card-info">
                <h5>{{ $iklan->judul_iklan }}</h5>
                <p>
                    {{ Str::limit($iklan->deskripsi_iklan, 10) }}
                    @if (strlen($iklan->deskripsi_iklan) > 10)
                    <span id="more-text-{{ $iklan->id }}" style="display: none;">
                        {{ substr($iklan->deskripsi_iklan, 10) }}
                    </span>
                    <span id="show-more-{{ $iklan->id }}" class="show-more" onclick="toggleDescription({{ $iklan->id }})">Selengkapnya</span>
                    @endif
                </p>

                <p>
                    @php
                    $link = trim($iklan->link);
                    if ($link && !preg_match('/^https?:\/\//', $link)) {
                    $link = 'http://' . $link;
                    }
                    @endphp

                    @if ($iklan->link)
                    <a href="{{ $link }}" target="_blank" rel="noopener noreferrer" class="text-link">
                        {{ $iklan->link }}
                    </a>
                    @else
                    <span class="text-muted">Tidak ada link</span>
                    @endif

                    <br>
                    <a href="{{ route('iklan.show', $iklan->id) }}" class="text-link">Selengkapnya</a>
                </p>


                <div class="btn-container">
                    <button onclick="toggleEdit({{ $iklan->id }})" class="btn btn-warning btn-sm">Edit</button>
                    <form action="{{ route('iklan.destroy', $iklan->id) }}" method="POST" onsubmit="return confirm('Yakin ingin menghapus iklan ini?')" style="margin:0;">
                        @csrf
                        @method('DELETE')
                        <button type="submit" class="btn btn-danger btn-sm">Hapus</button>
                    </form>
                </div>

                <div id="form-{{ $iklan->id }}" style="display: none;" class="edit-form">
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
                            <div style="margin-top: 4px;">
                                <a href="{{ route('iklan.show', $iklan->id) }}" target="_blank" class="text-link">Lihat detail iklan</a>
                            </div>
                        </div>


                        <div class="mb-2">
                            <label>Gambar</label>
                            <input type="file" name="gambar" class="form-control">
                        </div>

                        <button type="submit" class="btn btn-success btn-sm">Simpan</button>
                        <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit({{ $iklan->id }})">Batal</button>
                    </form>
                </div>
            </div>
        </div>
        @empty
        <div class="text-center text-muted">Belum ada data iklan.</div>
        @endforelse

        <div class="btn-tambah">
            <a href="{{ route('iklan.create') }}" class="btn btn-success">
                <span class="material-icons">add</span> Tambah Iklan
            </a>
        </div>
    </section>
</div>
@endsection