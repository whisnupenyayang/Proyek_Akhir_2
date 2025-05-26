@extends('admin.layouts.admin')

@section('content')
    <div class="row">
        <!-- Left col -->
        <section class="col-lg-12 connectedSortable">
            <div class="card">
                <div class="card-header">
                    <h5>Fungsi Penjualan Masih dalam Pengembangan</h5>
                </div><!-- /.card-header -->
            </div>
            <!-- /.card -->
        </section>
        <!-- /.Left col -->
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

        // Alert bahwa fungsi pengajuan masih dalam pengembangan
        Swal.fire({
            title: 'Informasi',
            text: 'Fungsi Penjualan Masih dalam Pengembangan',
            icon: 'info',
            confirmButtonText: 'OK'
        });
    </script>
@endsection
