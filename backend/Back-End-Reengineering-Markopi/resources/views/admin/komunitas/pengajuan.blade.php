@extends('admin.layouts.admin')

@section('content')
<style>
    .reject-button {
        background-color: #dc3545;
        color: #fff;
        border: none;
        padding: 5px 10px;
        cursor: pointer;
    }

    .accept-button {
        background-color: green;
        color: #fff;
        border: none;
        padding: 5px 10px;
        cursor: pointer;
    }

    .card-user {
        border: 1px solid #ddd;
        border-radius: 10px;
        padding: 15px;
        margin-bottom: 20px;
        text-align: center;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }

    .card-user img {
        border-radius: 10px;
        object-fit: cover;
    }

    .user-info p {
        margin: 4px 0;
    }

    .short-desc,
    .full-desc {
        display: inline;
    }

    .d-none {
        display: none !important;
    }
</style>

<div class="row justify-content-center">
    <div class="col-md-12">
        <div class="card">
            <div class="card-body">
                <div class="row">
                    @forelse ($pengajuans as $item)
                    <div class="col-6 col-md-4">
                        <div class="card-user">
                            <img src="{{ asset('storage/' . $item->foto_selfie) }}" alt="Foto Profil" width="120" height="120">

                            <div class="user-info mt-2">
                                <h5>{{ $item->nama_lengkap }}</h5>
                                <p>{{ $item->no_telp }}</p>
                                <p><strong>Kabupaten/Kota:</strong> {{ $item->kabupaten }}</p>
                                <hr>
                                <p><strong>Jenis Pengajuan:</strong> {{ $item->tipe_pengajuan }}</p>
                                <p>
                                    <strong>Deskripsi:</strong>
                                    @if(strlen($item->deskripsi_pengalaman) > 20)
                                        <span class="short-desc">{{ Str::limit($item->deskripsi_pengalaman, 20, '...') }}</span>
                                        <span class="full-desc d-none">{{ $item->deskripsi_pengalaman }}</span>
                                        <a href="#" class="toggle-desc">Lihat Selengkapnya</a>
                                    @else
                                        {{ $item->deskripsi_pengalaman }}
                                    @endif
                                </p>
                                <p>
                                    <a href="{{ asset('storage/' . $item->foto_ktp) }}" target="_blank">📄 Lihat Foto KTP</a>
                                </p>
                                <p>
                                    <a href="{{ asset('storage/' . $item->foto_sertifikat) }}" target="_blank">📄 Lihat Foto Sertifikat</a>
                                </p>
                            </div>

                            <div class="mt-2">
                                <form action="{{ route('pengajuan.accept', ['id' => $item->id_pengajuans]) }}" method="POST" style="display: inline-block;">
                                    @csrf
                                    <button type="submit" class="accept-button">
                                        <i class="fas fa-check"></i> Terima
                                    </button>
                                </form>

                                <form action="{{ route('pengajuan.reject', ['id' => $item->id_pengajuans]) }}" method="POST" style="display: inline-block;">
                                    @csrf
                                    <button type="submit" class="reject-button">
                                        <i class="fas fa-times"></i> Tolak
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                    @empty
                    <div class="col-12 text-center">
                        <p class="text-muted">Tidak ada data pengajuan.</p>
                    </div>
                    @endforelse

                </div>
            </div>
        </div>
    </div>
</div>

{{-- SweetAlert --}}
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    @if(session('success'))
    Swal.fire({
        title: 'Success!',
        text: '{{ session('success') }}',
        icon: 'success',
        confirmButtonText: 'OK'
    });
    @endif

    @if(session('error'))
    Swal.fire({
        title: 'Error!',
        text: '{{ session('error') }}',
        icon: 'error',
        confirmButtonText: 'OK'
    });
    @endif

    // Script Toggle Deskripsi
    document.addEventListener('DOMContentLoaded', function () {
        const toggleLinks = document.querySelectorAll('.toggle-desc');

        toggleLinks.forEach(link => {
            link.addEventListener('click', function (e) {
                e.preventDefault();
                const parent = link.closest('p');
                const shortDesc = parent.querySelector('.short-desc');
                const fullDesc = parent.querySelector('.full-desc');

                if (fullDesc.classList.contains('d-none')) {
                    shortDesc.classList.add('d-none');
                    fullDesc.classList.remove('d-none');
                    link.textContent = 'Lihat Lebih Sedikit';
                } else {
                    fullDesc.classList.add('d-none');
                    shortDesc.classList.remove('d-none');
                    link.textContent = 'Lihat Selengkapnya';
                }
            });
        });
    });
</script>
@endsection
