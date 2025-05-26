@extends('admin.layouts.admin')

@section('content')
    <!-- Filter Jenis Kopi -->
    <div class="row mb-3">
        <div class="col-md-4">
            <form method="GET" action="{{ route('kegiatan.panen') }}">
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
                <!-- Mengelompokkan data berdasarkan nama tahapan -->
                @foreach ($tahapanPanen->groupBy('nama_tahapan') as $namaTahapan => $tahapans)
                    <div class="tahapan-item mb-3 p-3 border rounded d-flex justify-content-between align-items-center">
                        <div class="tahapan-text">
                            <h5 class="mb-0">
                                <a href="{{ route('kegiatan.data_panen', ['nama_tahapan' => Str::slug($namaTahapan), 'jenis_kopi' => request('jenis_kopi')]) }}"
                                    class="text-decoration-none">
                                    {{ $namaTahapan }}
                                </a>
                            </h5>
                        </div>
                        <button class="btn btn-sm next-button">&gt;</button>
                    </div>
                @endforeach
            </div>

            <!-- Tombol Tambah Informasi Panen -->
            <div style="position: relative; margin-bottom: 30px;">
                <div style="display: flex; justify-content: flex-end;">
                    <a href="{{ route('kegiatan.panen.create') }}" class="add-btn">
                        <span class="material-icons">add</span>
                    </a>
                </div>
        </section>
    </div>
@endsection
