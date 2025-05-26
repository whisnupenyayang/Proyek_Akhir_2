<?php

namespace App\Http\API;

use App\Http\Controllers\Controller;
use App\Models\Kebun;
use App\Models\PendapatanKebun;
use App\Models\PengeluaranKebun;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ApiLaporanController extends Controller
{
    // Laporan per kebun
    public function getlaporan(Request $request)
    {
        $iduser = $request->user()->id_users;

        // Ambil semua data kebun milik user
        $data = Kebun::with(['pendapatan', 'pengeluaran'])
            ->where('user_id', $iduser)
            ->get()
            ->map(function ($kebun) {
                $total_pendapatan = $kebun->pendapatan->sum('total_pendapatan');
                $total_pengeluaran = $kebun->pengeluaran->sum('nominal');
                $kebun->pendapatan->sum('berat_kg');

                $hasil_produktifitas = $total_pendapatan - $total_pengeluaran;

                return [
                    'id' => $kebun->id,
                    'nama_kebun' => $kebun->nama_kebun,
                    'lokasi' => $kebun->lokasi,
                    'luas_kebun' => $kebun->luas_kebun,
                    'total_pendapatan' => $total_pendapatan,
                    'total_pengeluaran' => $total_pengeluaran,
                    'hasil_produktifitas' => $hasil_produktifitas,
                ];
            });

        if ($data->isEmpty()) {
            return response()->json([
                'message' => 'Gagal Mengambil data',
                'data' => [],
                'status' => 'error',
                'code' => 404,
            ]);
        }

        // Ambil semua ID kebun user
        $kebunIds = $data->pluck('id');

        // Hitung total pendapatan dari semua kebun
        $totalPendapatan = DB::table('pendapatan_kebuns')
            ->whereIn('kebun_id', $kebunIds)
            ->sum('total_pendapatan');

        // Hitung total pengeluaran dari semua kebun
        $totalPengeluaran = DB::table('pengeluaran_kebuns')
            ->whereIn('kebun_id', $kebunIds)
            ->sum('nominal');

        // Hitung produktifitas
        $totalProduktifitas = $totalPendapatan - $totalPengeluaran;

        return response()->json([
            'message' => 'Get Data Success',
            'data' => [
                'laporan' => $data,
                'total_produktifitas' => (int) $totalProduktifitas,
            ],
            'status' => 'success',
            'code' => 200,
        ]);
    }

    // Dapatkan Data Lapotan ById
    public function getLaporanById($id)
    {
        try {
            if (!$id) {
                return response()->json([
                    'message' => 'id is not defined',
                    'data' => [],
                    'status' => 'error',
                    'code' => 422,
                ]);
            }

            $kebun = Kebun::with(['pendapatan', 'pengeluaran'])->find($id);

            if (!$kebun) {
                return response()->json([
                    'message' => 'Kebun tidak ditemukan',
                    'data' => [],
                    'status' => 'error',
                    'code' => 404,
                ]);
            }

            $pendapatan = $kebun->pendapatan->groupBy(function ($item) {
                return $item->created_at->format('F Y');
            })->map(function ($group) {
                return $group->sum('total_pendapatan');
            });

            $pengeluaran = $kebun->pengeluaran->groupBy(function ($item) {
                return $item->created_at->format('F Y');
            })->map(function ($group) {
                return $group->sum('nominal');
            });

            $semua_bulan = $pendapatan->keys()->merge($pengeluaran->keys())->unique();

            $hasil = $semua_bulan->map(function ($bulan) use ($pendapatan, $pengeluaran) {
                $total_pendapatan = $pendapatan[$bulan] ?? 0;
                $total_pengeluaran = $pengeluaran[$bulan] ?? 0;

                return [
                    'bulan' => $bulan,
                    'pendapatan' => (int) $total_pendapatan,
                    'pengeluaran' => (int) $total_pengeluaran,
                    'hasil_produktivitas' => (int) ($total_pendapatan - $total_pengeluaran),
                ];
            })->values();

            return response()->json([
                'message' => 'Data laporan berhasil diambil',
                'data' => [
                    'id_kebun' => $kebun->id,
                    'namaKebun' => $kebun->nama_kebun,
                    'laporanDetail' => $hasil
                ],
                'status' => 'success',
                'code' => 200,
            ]);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Gagal ambil data laporan. error:' + $e->getMessage(),
                'status' => 'error',
                'code' => 500,
            ]);
        }
    }

    // Laporan Kebun Create
    public function createlaporan(Request $request)
    {
        try {
            $request->validate([
                'nama_kebun' => 'required|string|max:255',
                'lokasi' => 'required|string|max:255',
                'luas_kebun' => 'required|numeric',
            ]);

            Kebun::create([
                'user_id' => $request->user()->id_users,
                'nama_kebun' => $request->nama_kebun,
                'lokasi' => $request->lokasi,
                'luas_kebun' => $request->luas_kebun,
            ]);

            // Response
            return response()->json([
                'message' => 'Data kebun berhasil disimpan',
                'status' => 'success',
                'code' => 201,
            ]);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Data kebun gagal disimpan. error :' . $e->getMessage(),
                'status' => 'error',
                'code' => 500,
            ]);
        }
    }

    public function getLaporanPerBulan(Request $request)
    {
        try {
            $bulan = $request->query('bulan');
            $id_kebun = $request->query('id');

            if (!$bulan || !preg_match('/^\d{4}-\d{2}$/', $bulan)) {
                return response()->json([
                    'message' => 'Format bulan tidak valid. Gunakan format YYYY-MM.',
                    'data' => null,
                    'status' => 'error',
                    'code' => 422,
                ]);
            }

            // Validasi id_kebun
            if (!$id_kebun || !is_numeric($id_kebun)) {
                return response()->json([
                    'message' => 'ID kebun tidak valid.',
                    'data' => null,
                    'status' => 'error',
                    'code' => 422,
                ]);
            }

            // Ambil semua pendapatan di bulan dan kebun tersebut
            $pendapatan = PendapatanKebun::where('kebun_id', $id_kebun)
                ->whereMonth('created_at', substr($bulan, 5, 2))
                ->whereYear('created_at', substr($bulan, 0, 4))
                ->get();

            // Ambil semua pengeluaran di bulan dan kebun tersebut
            $pengeluaran = PengeluaranKebun::where('kebun_id', $id_kebun)
                ->whereMonth('created_at', substr($bulan, 5, 2))
                ->whereYear('created_at', substr($bulan, 0, 4))
                ->get();

            return response()->json([
                'message' => 'Data laporan detail berhasil diambil',
                'data' => [
                    'id_kebun' => (int) $id_kebun,
                    'bulan' => $bulan,
                    'pendapatan' => $pendapatan,
                    'pengeluaran' => $pengeluaran,
                ],
                'status' => 'success',
                'code' => 200,
            ]);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Data kebun gagal dimuat. error :' . $e->getMessage(),
                'status' => 'error',
                'code' => 500,
            ]);
        }
    }

    public function createPendapatan(Request $request)
    {
        try {
            $request->validate([
                'kebun_id' => 'required|exists:kebuns,id',
                'jenis_kopi' => 'required|string|max:255',
                'tanggal_panen' => 'required|date',
                'tempat_penjualan' => 'required|string|max:255',
                'tanggal_penjualan' => 'required|date',
                'harga_per_kg' => 'required|integer',
                'berat_kg' => 'required|integer',
                'total_pendapatan' => 'required|integer',
            ]);

            $pendapatan = PendapatanKebun::create([
                'kebun_id' => $request->kebun_id,
                'jenis_kopi' => $request->jenis_kopi,
                'tanggal_panen' => $request->tanggal_panen,
                'tempat_penjualan' => $request->tempat_penjualan,
                'tanggal_penjualan' => $request->tanggal_penjualan,
                'harga_per_kg' => $request->harga_per_kg,
                'berat_kg' => $request->berat_kg,
                'total_pendapatan' => $request->total_pendapatan,
            ]);

            return response()->json([
                'message' => 'Pendapatan berhasil ditambahkan',
                'data' => $pendapatan,
                'status' => 'success',
                'code' => 201,
            ]);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Gagal menambahkan pendapatan. error: ' . $e->getMessage(),
                'status' => 'error',
                'code' => 500,
            ]);
        }
    }

    public function createPengeluaran(Request $request)
    {
        try {
            $request->validate([
                'kebun_id' => 'required|exists:kebuns,id',
                'deskripsi_biaya' => 'required|string|max:255',
                'nominal' => 'required|integer',
                'tanggal' => 'required|date',
            ]);

            $pengeluaran = PengeluaranKebun::create([
                'kebun_id' => $request->kebun_id,
                'deskripsi_biaya' => $request->deskripsi_biaya,
                'nominal' => $request->nominal,
                'tanggal' => $request->tanggal,
            ]);

            return response()->json([
                'message' => 'Pengeluaran berhasil ditambahkan',
                'data' => $pengeluaran,
                'status' => 'success',
                'code' => 201,
            ]);
        } catch (Exception $e) {
            return response()->json([
                'message' => 'Gagal menambahkan pengeluaran. error: ' . $e->getMessage(),
                'status' => 'error',
                'code' => 500,
            ]);
        }
    }
}
