@extends('admin.layouts.admin')

@section('content')
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
                                                <th class="text-center">Nama</th>
                                                <th class="text-center">Tanggal Lahir</th>
                                                <th class="text-center">Jenis Kelamin</th>
                                                <th class="text-center">Nomor Telepon</th>
                                                <th class="text-center">Kabupaten</th>
                                                <th class="text-center">Provinsi</th>
                                                <th class="text-center">Role</th>
                                                <th class="text-center">Aksi</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            @forelse ($getDataUser as $item)
                                                <tr>
                                                    <td>{{ $loop->iteration }}</td>
                                                    <td>{{ $item->nama_lengkap }}</td>
                                                    <td>{{ $item->tanggal_lahir }}</td>
                                                    <td>{{ $item->jenis_kelamin }}</td>
                                                    <td>{{ $item->no_telp }}</td>
                                                    <td>{{ $item->kabupaten }}</td>
                                                    <td>{{ $item->provinsi }}</td>
                                                    <td>{{ $item->role }}</td>


                                                    <td class="text-center">
                                                        {{-- <form action="{{ route('pengajuan.accept', ['id' => $item->id]) }}"
                                                            method="POST">
                                                            @csrf
                                                            <button type="submit">Terima Pengajuan</button>
                                                        </form> --}}
                                                        {{-- {!! Form::open([
                                                            'route' => ['user.destroy', $item->id],
                                                            'method' => 'DELETE',
                                                        ]) !!}
                                                        <a href="{{ route('user.edit', $item->id) }}"
                                                            class="btn btn-success btn-sm text-center"><i
                                                                class="fas fa-edit"></i></a>
                                                        <a class="btn btn-primary btn-sm text-center" href="#">
                                                            <i class="fas fa-eye">
                                                            </i></a>

                                                        {{ Form::button('<i class="fa fa-trash"></i>', ['type' => 'submit', 'class' => 'btn btn-danger btn-sm text-center btndelete', 'id' => 'delete']) }}
                                                        {!! Form::close() !!} --}}

                                                        @if ($item->role != 'admin')
                                                            @if ($item->status == null)
                                                                <form action="{{ route('user.deactivate', $item->id_users) }}"
                                                                    method="POST">
                                                                    @csrf
                                                                    @method('PUT')
                                                                    <button type="submit"
                                                                        class="btn btn-danger">Nonaktifkan Akun</button>
                                                                </form>
                                                            @else
                                                                <form action="{{ route('user.activate', $item->id_users) }}"
                                                                    method="POST">
                                                                    @csrf
                                                                    @method('PUT')
                                                                    <button type="submit" class="btn btn-success">Aktifkan
                                                                        Akun</button>
                                                                </form>
                                                            @endif
                                                        @endif


                                                    </td>

                                                </tr>
                                            @empty
                                                <tr>
                                                    <td colspan="4">Data User Tidak ada</td>
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
                text: 'Menonaktifkan Akun ini?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Ya, Nonaktifkan!',
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
                text: '{{ session('error') }}   ',
                icon: 'error',
                confirmButtonText: 'OK'
            });
        @endif
    </script>
@endsection
