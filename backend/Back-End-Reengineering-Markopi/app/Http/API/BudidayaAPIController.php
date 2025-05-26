<?php

namespace App\Http\API;

use App\Models\Minuman;
use App\Models\Budidaya;
use App\Models\Pengajuan;
use App\Models\JenisTahapanBudidaya;
use App\Models\TahapanBudidaya;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Models\JenisTahapanKegiatan;
use App\Models\TahapanKegiatan;
use App\Models\TestImage;
use Illuminate\Http\Request;

use Illuminate\Support\Facades\Http;

use Illuminate\Support\Facades\Storage;

class BudidayaAPIController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */




    public function getKegiatan($kegiatan, $jenisKopi){
        $tahapanKegiatan = TahapanKegiatan::where('kegiatan', $kegiatan)->where('jenis_kopi', $jenisKopi)->get();

        return response()->json($tahapanKegiatan);
    }



    public function getJenisTahapanKegiatan($id){
        $jenisTahapanKegiatan = JenisTahapanKegiatan::where('tahapan_kegiatan_id',$id)->get();

        return response()->json($jenisTahapanKegiatan);

    }

    public function getJenisTahapanKegiatanDetail($id){
        $jenisTahapanKegiatanDetail = JenisTahapanKegiatan::findOrFail($id);

        return response()->json($jenisTahapanKegiatanDetail);
    }




    public function storeJenisTahapanKegiatanDetail(Request $request){
        $request->validate([
            'judul' => 'required|string',
            'deskripsi' => 'required',
            'nama_file' => 'nullable|image|mimes:jpeg,png,jpg|max:1028',
            'tahapan_kegiatan_id' => 'required',
        ]);


        $namaFile = null;
        $path = null;

        if ($request->hasFile('nama_file')) {
            $file = $request->file('nama_file');
            $namaFile = $file->getClientOriginalName();
            $path = $file->store('budidayaimage', 'public'); // hasil: 'budidayaimage/namafile.jpg'
        }

        $budidaya = JenisTahapanKegiatan::create([
            'judul' => $request->judul,
            'deskripsi' => $request->deskripsi,
            'nama_file' => $namaFile,
            'url_gambar' => $path ? '/storage/' . $path : null, // pakai /storage/ kalau dari public disk
            'tahapan_kegiatan_id' => $request->tahapan_kegiatan_id,
        ]);

        if ($budidaya) {
            return response()->json('berhasil');
        }

        return response()->json('gagal');
    }

    public function getJenisTahapBudidayaById($id){
        $jenisTBById = JenisTahapanBudidaya::find($id);

        return response()->json($jenisTBById);
    }

    public function storeTahapanBudidaya(Request $request){
        $request->validate([
            'nama_tahapan' => 'required',
            'jenis_kopi'=> 'required',
        ]);

        $jenisKopi = TahapanBudidaya::create(
            [
                'nama_tahapan' => $request->nama_tahapan,
                'jenis_kopi' => $request->jenis_kopi,
            ]
        );

        if($jenisKopi){
            return response()->json('berhasil');
        }
        return response()->json('gagal');
    }

    public function storeJenisTahapanBudidaya(Request $request)
    {
        $request->validate([
            'judul' => 'required|string',
            'deskripsi' => 'required',
            'nama_file' => 'nullable|image|mimes:jpeg,png,jpg|max:1028',
            'tahapan_budidaya_id' => 'required',
        ]);

        $namaFile = null;
        $path = null;

        if ($request->hasFile('nama_file')) {
            $file = $request->file('nama_file');
            $namaFile = $file->getClientOriginalName();
            $path = $file->store('budidayaimage', 'public'); // hasil: 'budidayaimage/namafile.jpg'
        }

        $budidaya = JenisTahapanBudidaya::create([
            'judul' => $request->judul,
            'deskripsi' => $request->deskripsi,
            'nama_file' => $namaFile,
            'url_gambar' => $path ? '/storage/' . $path : null, // pakai /storage/ kalau dari public disk
            'tahapan_budidaya_id' => $request->tahapan_budidaya_id,
        ]);

        if ($budidaya) {
            return response()->json('berhasil');
        }

        return response()->json('gagal');
    }




}

