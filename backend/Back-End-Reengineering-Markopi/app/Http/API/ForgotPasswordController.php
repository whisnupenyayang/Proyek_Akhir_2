<?php

namespace App\Http\API;

use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Notifications\ResetPasswordNotification;
use App\Http\Requests\auth\ForgotPasswordRequest;

class ForgotPasswordController extends Controller
{
    public function forgotPassword(Request $request)
    {
        try {
            $email = $request->input('email');

            $user = User::where('email', $email)->first();

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'Email tidak ditemukan.'
                ], 404);
            }

            $user->notify(new ResetPasswordNotification());

            return response()->json([
                'success' => true,
                'message' => 'Kode terkirim, silahkan cek email Anda.',
            ], 200);
        } catch (\Throwable $th) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $th->getMessage(),
            ], 500);
        }
    }
}
