<?php

namespace App\Http\API;

use App\Models\Artikel;
use App\Http\Controllers\Controller;
use App\Http\Resources\ArtikelResourc;

class ArtikelController extends Controller
{
    // Menampilkan semua artikel beserta relasi images
    public function index()
    {
        $artikels = Artikel::with('images')->get();
        return ArtikelResourc::collection($artikels);
    }

    // Menampilkan detail artikel berdasarkan id
    public function show($id)
    {
        $artikel = Artikel::with('images')->find($id);

        if (!$artikel) {
            return response()->json(['message' => 'Artikel not found', 'status' => 'error'], 404);
        }

        return new ArtikelResourc($artikel);
    }

    // Menampilkan artikel berdasarkan user_id
    public function articlesByUser($user_id)
    {
        $artikels = Artikel::with('images')->where('user_id', $user_id)->get();

        if ($artikels->isEmpty()) {
            return response()->json(['message' => 'Artikel untuk user ini tidak ditemukan', 'status' => 'error'], 404);
        }

        return ArtikelResourc::collection($artikels);
    }
}
