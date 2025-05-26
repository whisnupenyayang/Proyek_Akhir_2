@extends('admin.layouts.admin')

@section('content')
    <!-- Filter Jenis Kopi -->
    <div class="row mb-3">
        <div class="col-md-4">
            <form method="GET" action="{{ route('kegiatan.pascapanen') }}">
                <div class="form-group">
                    <label for="jenis_kopi">Pilih Jenis Kopi</label>
                    <select name="jenis_kopi" id="jenis_kopi" class="form-control">
                        <option value="">Semua</option>
                        <option value="Arabika" {{ request('jenis_kopi') == 'Arabika' ? 'selected' : '' }}>Arabika</option>
                        <option value="Robusta" {{ request('jenis_kopi') == 'Robusta' ? 'selected' : '' }}>Robusta</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary mt-2">Terapkan Filter</button>
            </form>
        </div>
    </div>

    <div class="row">
        <section class="col-lg-12 connectedSortable">
            <div class="card-body">
                @forelse ($tahapanPascapanen->groupBy('nama_tahapan') as $namaTahapan => $tahapans)
                    <div class="tahapan-item mb-3 p-3 border rounded d-flex justify-content-between align-items-center">
                        <div class="tahapan-text">
                            <h5 class="mb-0">
                                <a href="{{ route('kegiatan.data_pascapanen', ['nama_tahapan' => Str::slug($namaTahapan), 'jenis_kopi' => request('jenis_kopi')]) }}"
                                    class="btn btn-link">
                                    {{ $namaTahapan }}
                                </a>
                            </h5>
                        </div>
                        <button class="btn btn-sm next-button">&gt;</button>
                    </div>
                @empty
                    <div class="text-center text-muted">Belum ada data pasca panen.</div>
                @endforelse
            </div>

            <!-- Tombol Tambah Informasi Pasca Panen -->
            <div style="position: relative; margin-bottom: 30px;">
                <div style="display: flex; justify-content: flex-end;">
                    <a href="{{ route('kegiatan.pascapanen.create') }}" class="add-btn">
                        <span class="material-icons">add</span>
                    </a>
                </div>
        </section>
    </div>
@endsection
