<?php

namespace App\Http\API;

use App\Http\Controllers\Controller;
use App\Models\Resep;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\URL;

class ResepApiController extends Controller
{
    public function index()
    {
        $reseps = Resep::all()->map(function ($resep) {
            $resep->gambar_resep = $resep->gambar_resep 
                ? URL::to('/images/' . $resep->gambar_resep) 
                : null;
            return $resep;
        });

        return response()->json($reseps);
    }

    // Fungsi tambahan lain bisa ditambahkan di sini sesuai kebutuhan
}
