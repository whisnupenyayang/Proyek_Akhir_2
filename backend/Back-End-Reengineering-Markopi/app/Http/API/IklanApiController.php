<?php

namespace App\Http\Api;

use App\Http\Controllers\Controller;
use App\Models\Iklan;
use Illuminate\Http\Request;

class IklanApiController extends Controller
{
    // Fetch semua iklan
    public function index()
    {
        $iklans = Iklan::all()->map(function ($iklan) {
            $iklan->gambar_url = asset('foto/' . $iklan->gambar);
            return $iklan;
        });

        return response()->json([
            'status' => 'success',
            'data' => $iklans
        ], 200);
    }

    // Fetch iklan by ID
    public function show($id)
    {
        $iklan = Iklan::find($id);

        if ($iklan) {
            $iklan->gambar_url = asset('foto/' . $iklan->gambar);

            return response()->json([
                'status' => 'success',
                'data' => $iklan
            ], 200);
        } else {
            return response()->json([
                'status' => 'error',
                'message' => 'Iklan not found'
            ], 404);
        }
    }
}
