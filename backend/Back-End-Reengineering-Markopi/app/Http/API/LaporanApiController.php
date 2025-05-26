<?php
namespace App\Http\Api;

use App\Http\Controllers\Controller;
use App\Models\Laporan;
use Illuminate\Http\Request;

class LaporanApiController extends Controller
{
    // Menampilkan semua laporan
    public function index()
    {
        $laporans = Laporan::all(); // Mengambil semua laporan

        return response()->json([
            'status' => 'success',
            'data' => $laporans
        ], 200);
    }

    // Menampilkan laporan berdasarkan ID
    public function show($id)
    {
        $laporan = Laporan::find($id);

        if ($laporan) {
            return response()->json([
                'status' => 'success',
                'data' => $laporan
            ], 200);
        } else {
            return response()->json([
                'status' => 'error',
                'message' => 'Laporan not found'
            ], 404);
        }
    }

    // Menyimpan laporan baru
    public function store(Request $request)
    {

        $request->validate([
            'judul_laporan' => 'required|string|max:255',
            'isi_laporan' => 'nullable|string',
            'id_users' => 'required|exists:users,id', // Validasi untuk memastikan id_users ada di tabel users
        ]);


        $laporan = Laporan::create([
            'judul_laporan' => $request->judul_laporan,
            'isi_laporan' => $request->isi_laporan,
            'id_users' => $request->id_users,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Laporan berhasil dibuat',
            'data' => $laporan,
        ], 201);
    }

    // Menghapus laporan berdasarkan ID
    public function destroy($id)
    {
        $laporan = Laporan::find($id);

        if (!$laporan) {
            return response()->json(['message' => 'Laporan tidak ditemukan'], 404);
        }

        $laporan->delete();

        return response()->json(['message' => 'Laporan berhasil dihapus']);
    }
}
