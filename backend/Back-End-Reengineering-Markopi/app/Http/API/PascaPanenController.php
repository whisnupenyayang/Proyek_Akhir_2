<?php

namespace App\Http\API;

use App\Models\Pasca;
use App\Http\Controllers\Controller;

class PascaPanenController extends Controller
{
    
    public function getFermentasiKeringData()
    {
        $pascaData = Pasca::with('images')->where('kategori', 'Fermentasi Kering')->get();
        return response()->json($pascaData);
    }

    public function getFermentasiMekanisData()
    {
        $pascaData = Pasca::with('images')->where('kategori', 'Fermentasi Mekanis')->get();
        return response()->json($pascaData);
    }

}
