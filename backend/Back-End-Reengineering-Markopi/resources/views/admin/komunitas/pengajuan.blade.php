@extends('admin.layouts.admin')

@section('content')
    <style>
        .reject-button {
            background-color: #dc3545;
            /* Warna merah, bisa disesuaikan */
            color: #fff;
            /* Warna teks putih, bisa disesuaikan */
            border: none;
            padding: 5px 10px;
            cursor: pointer;
        }

        .accept-button {
            background-color: green;
            /* Warna merah, bisa disesuaikan */
            color: #fff;
            /* Warna teks putih, bisa disesuaikan */
            border: none;
            padding: 5px 10px;
            cursor: pointer;
        }
    </style>
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <div class="card-tools">
                                        <div class="input-group input-group-sm" style="width: 200px;">
                                            <input type="text" name="table_search" class="form-control float-right"
                                                placeholder="Search">

                                            <div class="input-group-append">
                                                <button type="submit" class="btn btn-default">
                                                    <i class="fas fa-search"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- /.card-header -->
                                <div class="card-body table-responsive p-0">
                                    <table class="table table-hover text-nowrap text-center">
                                        <thead class="text-center">
                                            <tr class="text-center">
                                                <th class="text-center">No</th>
                                                <th class="text-center">Jenis Pengajuan</th>
                                                <th class="text-center">Nama</th>
                                                <th class="text-center">Deskripsi Pengalaman</th>
                                                <th class="text-center">Foto Profil</th>
                                                <th class="text-center">Foto KTP</th>
                                                <th class="text-center">Foto Sertifikat</th>
                                                <th class="text-center">Aksi</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            @forelse ($pengajuans as $item)
                                                <tr>
                                                    <td>{{ $loop->iteration }}</td>
                                                    <td>{{ $item->tipe_pengajuan }}</td>
                                                    <td>{{ $item->username }}</td>
                                                    <td>{{ $item->deskripsi_pengalaman }}</td>
                                                    <td><img style="width: 200px"
                                                            src="{{ asset('storage/' . $item->foto_selfie) }}"
                                                            alt="Foto Profil">
                                                    </td>
                                                    <td><img style="width: 200px"
                                                            src="{{ asset('storage/' . $item->foto_ktp) }}" alt="Foto KTP">
                                                    </td>
                                                    <td><img style="width: 200px"
                                                            src="{{ asset('storage/' . $item->foto_sertifikat) }}"
                                                            alt="Foto Sertifikat">
                                                    </td>


                                                    <td class="text-center" style="margin-bottom: 10px;">
                                                        <form action="{{ route('pengajuan.accept', ['id' => $item->id_pengajuans]) }}"
                                                            method="POST">
                                                            @csrf
                                                            <button type="submit" class="accept-button">
                                                                <i class="fas fa-check"></i> Terima
                                                            </button>
                                                        </form>
                                                    </td>

                                                    <td class="text-center">
                                                        <form action="{{ route('pengajuan.reject', ['id' => $item->id_pengajuans]) }}"
                                                            method="POST">
                                                            @csrf
                                                            <button type="submit" class="reject-button">
                                                                <i class="fas fa-times"></i> Tolak
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            @empty
                                                <tr>
                                                    <td colspan="7">Data User Tidak ada</td>
                                                </tr>
                                            @endforelse
                                        </tbody>
                                    </table>
                                    {{-- {!! $models->links() !!} --}}
                                </div>
                                <!-- /.card-body -->
                            </div>
                            <!-- /.card -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function confirmDelete(id, event) {
            event.preventDefault(); // Mencegah perilaku formulir default

            Swal.fire({
                title: 'Apakah Anda yakin?',
                text: 'Data akan dihapus permanen!',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Ya, hapus!',
                cancelButtonText: 'Batal'
            }).then((result) => {
                if (result.isConfirmed) {
                    document.getElementById('delete-form-' + id).submit();
                }
            });
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        // Tambahkan script SweetAlert2 di sini
        @if (session('success'))
            Swal.fire({
                title: 'Success!',
                text: '{{ session('success') }}',
                icon: 'success',
                confirmButtonText: 'OK'
            });
        @endif

        @if (session('error'))
            Swal.fire({
                title: 'Error!',
                text: '{{ session('error') }}',
                icon: 'error',
                confirmButtonText: 'OK'
            });
        @endif
    </script>
@endsection
