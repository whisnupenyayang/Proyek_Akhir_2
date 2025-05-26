<?php

namespace App\Http\API;


use App\Http\Controllers\Controller;
use App\Models\Pengepul;
use App\Models\RataRataHergaKopi;
use Carbon\Carbon;
use Illuminate\Validation\ValidationException;
use Illuminate\Auth\Events\Validated;

use Illuminate\Http\Request;

use function PHPUnit\Framework\isNull;

class PengepulApiController extends Controller
{
    public function getPengepul(){
        $pengepul = Pengepul::all();

        return response()->json($pengepul);
    }

    public function storePengepul(Request $request)
{
    try {
        $request->validate([
            'nama_toko' => 'required',
            'jenis_kopi' => 'required',
            'harga' => 'required|numeric',
            'nomor_telepon' => 'required',
            'alamat' => 'required',
            'nama_gambar' => 'nullable|image|mimes:jpeg,png,jpg'
        ]);
        $user = $request->user();
        $userid = $user->id_users;
        $namaFile = null;
        $path = null;

        if ($request->hasFile('nama_gambar')) {
            $file = $request->file('nama_gambar');
            $namaFile = $file->getClientOriginalName();
            $path = $file->store('pengepul', 'public');
        }

        $pengepul = Pengepul::create([
            'nama_toko' => $request->nama_toko,
            'jenis_kopi' => $request->jenis_kopi,
            'harga' => $request->harga,
            'nomor_telepon' => $request->nomor_telepon,
            'alamat' => $request->alamat,
            'nama_gambar' => $namaFile,
            'url_gambar' => $path ? 'storage/' . $path : null,
            'user_id'=> $userid,
        ]);

        if ($pengepul) {
            $bulanSekarang = Carbon::now()->format('m');
            $tahunSekarang = Carbon::now()->format('Y');

            $pengepuls = Pengepul::where('jenis_kopi', $request->jenis_kopi)
                ->whereMonth('updated_at', $bulanSekarang)
                ->whereYear('updated_at', $tahunSekarang)
                ->select('harga')
                ->get();

            $jumlahHarga = $pengepuls->sum('harga');
            $count = $pengepuls->count();

            if ($count > 0) {
                $ratarata = $jumlahHarga / $count;

                $hargaKopiBulanTahun = RataRataHergaKopi::where('jenis_kopi', $request->jenis_kopi)
                    ->where('bulan', $bulanSekarang)
                    ->where('tahun', $tahunSekarang)
                    ->first();

                if (is_null($hargaKopiBulanTahun)) {
                    RataRataHergaKopi::create([
                        'jenis_kopi' => $request->jenis_kopi,
                        'rata_rata_harga' => $ratarata,
                        'bulan' => $bulanSekarang,
                        'tahun' => $tahunSekarang,
                    ]);
                } else {
                    $hargaKopiBulanTahun->update([
                        'rata_rata_harga' => $ratarata,
                    ]);
                }
            }

            return response()->json(['message' => 'sukses'], 201);
        }

        return response()->json(['message' => 'Gagal menyimpan pengepul'], 500);
    } catch (\Exception $e) {
        return response()->json([
            'message' => 'Terjadi kesalahan',
            'error' => $e->getMessage()
        ], 500);
    }
}


    public function updatePengepul(Request $request, $id){

        try {


            $request->validate([
                'nama_toko'     => 'required',
                'jenis_kopi'    => 'required',
                'harga'         => 'required|numeric',
                'nomor_telepon' => 'required',
                'alamat'        => 'required',
            ]);

            $user = $request->user();
            $userid = $user->id_users;

            $pengepul = Pengepul::findOrFail($id);

            if($userid !== $pengepul->user_id){
            return response()->json('anda tidak memiliki akses', 403);
        }
            $pengepul->update($request->only([
                'nama_toko',
                'jenis_kopi',
                'harga',
                'nomor_telepon',
                'alamat',
            ]));


            if($pengepul){
                $bulanSekarang = Carbon::now()->format('m'); // angka bulan: "05"
                $tahunSekarang = Carbon::now()->format('Y');

                $pengepuls = Pengepul::where('jenis_kopi', $request->jenis_kopi)
                ->whereMonth('updated_at', $bulanSekarang)
                ->whereYear('updated_at', $tahunSekarang)
                ->select('harga')
                ->get();

                $count = 0;
                $jumlahHarga = 0;

                foreach ($pengepuls as $p) {
                    $jumlahHarga += $p->harga;
                    $count++;
                }
                $ratarata = $jumlahHarga / $count;

                $hargaKopiBulanTahun = RataRataHergaKopi::where('jenis_kopi', $request->jenis_kopi)
                ->where('bulan', $bulanSekarang)
                ->where('tahun', $tahunSekarang)
                ->first();
                if (is_null($hargaKopiBulanTahun)) {
                // Buat entri baru
                RataRataHergaKopi::create([
                    'jenis_kopi' => $request->jenis_kopi,
                    'rata_rata_harga' => $ratarata,
                    'bulan' => $bulanSekarang,
                    'tahun' => $tahunSekarang,
                ]);
            } else {
                $hargaKopiBulanTahun->update([
                    'rata_rata_harga' => $ratarata,
                    ]);
                }
            }
            return response()->json('sukses');
        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Validasi gagal.',
                'errors' => $e->errors()
            ], 422);
        }
    }

    public function getPengepulByuser(Request $request){
        $user = $request->user();
        $userid = $user->id_users;

        $pengepul = Pengepul::where('user_id', $userid)->get();

        return response()->json($pengepul);

    }

    public function getPengepulDetail ( $id) {
        $pengepul = Pengepul::findOrFail($id);

        return response()->json($pengepul);
    }



    // ==========================Summary harga kopi ==========================
    public function getHargaRataRata($jenis_kopi, $tahun){

        $hargaRataRata = RataRataHergaKopi::where('jenis_kopi', $jenis_kopi)->where('tahun', $tahun)->orderBy('bulan', 'asc')->get();
        return response()->json(['data' => $hargaRataRata]);

    }

    public function deletePengepul($id)
{
    try {
        // Attempt to find the pengepul by id
        $pengepul = Pengepul::findOrFail($id);

        // Check if the logged-in user is the owner of the pengepul
        $user = request()->user();
        if ($pengepul->user_id !== $user->id_users) {
            return response()->json(['message' => 'Anda tidak memiliki akses untuk menghapus pengepul ini'], 403);
        }

        // Delete the pengepul record
        $pengepul->delete();

        // Delete related average coffee price data based on jenis_kopi, current month, and year
        RataRataHergaKopi::where('jenis_kopi', $pengepul->jenis_kopi)
            ->where('tahun', Carbon::now()->format('Y'))
            ->where('bulan', Carbon::now()->format('m'))
            ->delete();

        // Return success message
        return response()->json(['message' => 'Pengepul berhasil dihapus'], 200);
    } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
        // If the pengepul with the given id is not found
        return response()->json([
            'message' => 'Pengepul tidak ditemukan',
            'error' => $e->getMessage()
        ], 404);
    } catch (\Exception $e) {
        // Catch other exceptions and log the error
        return response()->json([
            'message' => 'Terjadi kesalahan saat menghapus pengepul',
            'error' => $e->getMessage()
        ], 500);
    }
}


}
