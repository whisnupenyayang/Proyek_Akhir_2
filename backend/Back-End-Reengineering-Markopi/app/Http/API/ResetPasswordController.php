<?php

namespace App\Http\API;

use App\Models\User;
use Ichtrojan\Otp\Otp;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use App\Http\Requests\auth\ResetPasswordRequest;

class ResetPasswordController extends Controller
{
    public function resetPassword(Request $request)
    {
        $otp = (new Otp)->validate($request->email, $request->otp);

        if (!$otp->status) {
            return response()->json(['error' => $otp], 401);
        }

        $user = User::where('email', $request->email)->first();

        $user->update(
            [
                'password' => Hash::make($request->password)
            ]
        );

        $user->tokens()->delete();
        
        return response()->json([
            'success' => true,
            'message' => 'Password telah diganti'
        ], 200);
    }
}
