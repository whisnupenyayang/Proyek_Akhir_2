<?php

namespace App\Http\API;

use App\Models\User;
use App\Models\Pengajuan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class PengajuanController extends Controller
{
    public function tambahData(Request $request)
    {
        try {
            $request->validate([
                'deskripsi_pengalaman' => 'required|string',
                'foto_ktp' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:10048',
                'foto_selfie' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:10048',
                'foto_sertifikat' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:10048',
                'type_pengajuan' => 'required'
            ]);

            $user = DB::table('users')->where('id_users', $request->user()->id_users)->first();
            if (!$user) {
                return response()->json(['message' => 'User tidak ada', 'status' => 'error'], 404);
            }

            $fotoKtpPath = null;
            if ($request->hasFile('foto_ktp')) {
                $uploadedFile = $request->file('foto_ktp');
                if ($uploadedFile->isValid()) {
                    $fotoKtpPath = $uploadedFile->store('pengajuanimage', 'public');
                } else {
                    return response()->json(['message' => 'Gagal mengunggah foto KTP', 'status' => 'error', 'error' => 'Invalid file'], 400);
                }
            }

            $fotoSelfiePath = null;
            if ($request->hasFile('foto_selfie')) {
                $uploadedFile = $request->file('foto_selfie');
                if ($uploadedFile->isValid()) {
                    $fotoSelfiePath = $uploadedFile->store('pengajuanimage', 'public');
                } else {
                    return response()->json(['message' => 'Gagal mengunggah foto selfie', 'status' => 'error', 'error' => 'Invalid file'], 400);
                }
            }

            $fotoSertifikatPath = null;
            if ($request->hasFile('foto_sertifikat')) {
                $uploadedFile = $request->file('foto_sertifikat');
                if ($uploadedFile->isValid()) {
                    $fotoSertifikatPath = $uploadedFile->store('pengajuanimage', 'public');
                } else {
                    return response()->json(['message' => 'Gagal mengunggah foto sertifikat', 'status' => 'error', 'error' => 'Invalid file'], 400);
                }
            }

            $existingPengajuan = Pengajuan::where('user_id', $request->user()->id_users)->first();
            if ($existingPengajuan) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Anda sudah memiliki pengajuan yang sedang diproses',
                    'data' => $existingPengajuan
                ], 400);
            }

            $pengajuan = Pengajuan::create([
                'foto_ktp' => $fotoKtpPath,
                'foto_selfie' => $fotoSelfiePath,
                'deskripsi_pengalaman' => $request->deskripsi_pengalaman,
                'foto_sertifikat' => $fotoSertifikatPath,
                'user_id' => $request->user()->id_users,
                'tipe_pengajuan' => $request->type_pengajuan
            ]);

            if ($pengajuan) {
                $fotoKtpUrl = $fotoKtpPath ? asset('storage/' . $fotoKtpPath) : null;
                $fotoSelfieUrl = $fotoSelfiePath ? asset('storage/' . $fotoSelfiePath) : null;
                $fotoSertifikatUrl = $fotoSertifikatPath ? asset('storage/' . $fotoSertifikatPath) : null;

                return response()->json([
                    'message' => 'Data berhasil diajukan',
                    'status' => 'success',
                    'foto_ktp_url' => $fotoKtpUrl,
                    'foto_selfie_url' => $fotoSelfieUrl,
                    'foto_sertifikat_url' => $fotoSertifikatUrl,
                ], 200);
            } else {
                return response()->json(['message' => 'Gagal menambahkan data', 'status' => 'error', 'error' => 'Failed to save data to the database'], 500);
            }
        } catch (\Exception $e) {
            return response()->json(['message' => 'Gagal menambahkan data', 'status' => 'error', 'error' => $e->getMessage()], 500);
        }
    }

    public function getDataByAuth(Request $request)
    {
        try {
            $data = Pengajuan::where('user_id', $request->user()->id_users)->first();
            if (!$data) {
                return response()->json([
                    'status' => 'errors',
                    'message' => "data tidak data",
                    'data' => null,
                    'code' => 200
                ]);
            }

            return response()->json([
                'status' => 'success',
                'message' => "Get data pengajuan success",
                'data' => $data,
                'code' => 200
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'errors',
                'message' => "error : " . $e->getMessage(),
                'code' => 500
            ], 500);
        }
    }
}
