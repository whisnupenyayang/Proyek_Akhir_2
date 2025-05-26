<?php

namespace App\Http\API;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Pengajuan;
use App\Models\PengajuanTransaksi;
use App\Models\Pengepul;
use App\Models\PenjualKopi;

class TransaksiApiController extends Controller
{
    public function createPengajuanTransaksi(Request $request){
        $user = $request->user();
        $userId = $user->id_users;

        $request->validate([
            "id" => "required",
            
            "role" => "required"
        ]);

        $id = $request->id;

        $role = $request->role;
        if($role == "pengepul"){
            $pengepul = Pengepul::findOrFail($id);

            $pengepulId = $pengepul->id;
            $userPenerimaId = $pengepul->user_id;
        $pengajuan = PengajuanTransaksi::create([
            'keterengan' => 'belum selesai',
                'id_user_pengaju' => $userId,
                'id_user_penerima' => $userPenerimaId,
                'id_pengepul' => $pengepulId,
        ]);


                return response()->json('ini jual kopi');

        } else if($role == "petani"){
            $petani = PenjualKopi::findOrFail($id);
            $penjualKopiId = $petani->id;
            $userPenerimaId = $petani->user_id;
             $pengajuan = PengajuanTransaksi::create([
                'keterengan' => 'belum dijawab',
                'id_user_pengaju' => $userId,
                'id_user_penerima' => $userPenerimaId,
                'id_penjual_kopi' => $penjualKopiId,

            ]);
            return response()->json('ini kopi dibeli');

        }
        return response()->json('tidak ada role yang terpenuhi');
    }

    public function updateKeterangan(Request $request, $id)
    {
        $pengajuan = PengajuanTransaksi::findOrFail($id);
        $keteranganPengajuan = $pengajuan->keterengan;
        if($keteranganPengajuan == 'dibatalkan' || $keteranganPengajuan == 'ditolak'){
            return response()->json('sudah dibatalkan atau ditolak');
        }
        $user = $request->user();
        $userid = $user->id_users;

        $keterangan = $request->keterengan;


        if($keterangan == 'setuju' || $keterangan == 'ditolak'){

            if ($userid == $pengajuan->id_user_penerima) {
                    $pengajuan->update($request->only(['keterengan']));
                    if($keterangan == 'setuju'){
                        return response()->json(['message' => 'Keterangan berhasil dan buat transaksi'], 200);
                    }
                    return response()->json(['message' => 'Keterangan berhasil diperbarui'], 200);
                }

             return response()->json(['message' => 'Akses ditolak'], 403);
            } else if($keterangan == 'dibatalkan'){

                if ($userid == $pengajuan->id_user_pengaju) {
                    $pengajuan->update($request->only(['keterengan']));
                    return response()->json(['message' => 'Keterangan berhasil dibatalkan'], 200);
                }
                return response()->json(['message' => 'Akses ditolak'], 403);

            }
        }


    public function mengajukanBeliKopi(Request $request){
        $user = $request->user();
        $userId = $user->id_users;

        $pengajuan = PengajuanTransaksi::Where('id_user_pengaju', $userId)->where('id_pengepul', NULL)->get();

        return response()->json($pengajuan);
    }

    public function mengajukanJualKopi(Request $request){
          $user = $request->user();
        $userId = $user->id_users;

        $pengajuan = PengajuanTransaksi::Where('id_user_pengaju', $userId)->where('id_penjual_kopi', NULL)->get();

        return response()->json($pengajuan);
    }

    public function menerimaPengajuanJualKopi(Request $request){
        $user = $request->user();
        $userId = $user->id_users;

        $pengajuan = PengajuanTransaksi::Where('id_user_penerima', $userId)->where('id_penjual_kopi', NULL)->get();
        return response()->json($pengajuan);
    }

    public function menerimaPengajuanBeliKopi(Request $request) {
        $user = $request->user();
        $userId = $user->id_users;

        $pengajuan = PengajuanTransaksi::Where('id_user_penerima', $userId)->where('id_pengepul', NULL)->get();
        return response()->json($pengajuan);
    }



    public function pengajuanDetail( $id){
        $pengajuan = PengajuanTransaksi::findOrFail($id);

        return response()->json($pengajuan);
    }

    public function getPengajuanByData(Request $request, $id){
        $request->validate([
            'role' => 'required'
        ]);


        if($request->role == 'pengepul'){

        $pengajuan = PengajuanTransaksi::where('id_pengepul', $id );

        return response()->json($pengajuan);

        }  else if($request->role == 'petani'){
            $pengajuan = PengajuanTransaksi::where('id_penjual_kopi', $id );
            return response()->json($pengajuan);
        }
    }










}
