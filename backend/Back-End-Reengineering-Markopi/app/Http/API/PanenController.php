<?php

namespace App\Http\API;

use App\Models\Panen;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;

class PanenController extends Controller
{
    public function panen()
    {
        $panens = DB::table('panens')
            ->join('image_panens', 'panens.id_panens', '=', 'image_panens.panen_id')
            ->select('panens.*', 'image_panens.gambar')
            ->get();
        return response()->json($panens);
    }

    public function getCiriBuahKopiData()
    {
        $panenData = Panen::with('images')->where('kategori', 'Ciri Buah Kopi')->get();
        return response()->json($panenData);
    }

    public function getPemetikanData()
    {
        $panenData = Panen::with('images')->where('kategori', 'Pemetikan')->get();
        return response()->json($panenData);
    }

    public function getSortasiBuahData()
    {
        $panenData = Panen::with('images')->where('kategori', 'LIKE', '%Sortasi%')->get();
        return response()->json($panenData);
    }
}
