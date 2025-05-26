<?php

namespace App\Http\API;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama_lengkap' => 'required',
            'username' => 'required|unique:users',
            'email' => 'required|email',
            'password' => 'required',
            'tanggal_lahir' => 'required|date',
            'jenis_kelamin' => 'required|in:Laki-laki,Perempuan',
            'provinsi' => 'required',
            'kabupaten' => 'required',
            'no_telp' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Ada kesalahan',
                'data' => $validator->errors()
            ], 400);
        }

        $input = $request->all();
        $input['password'] = Hash::make($input['password']);
        $user = User::create([
            'nama_lengkap'   => $input['nama_lengkap'],
            'username'       => $input['username'],
            'email'          => $input['email'],
            'password'       => $input['password'], //
            'tanggal_lahir'  => $input['tanggal_lahir'],
            'jenis_kelamin'  => $input['jenis_kelamin'],
            'provinsi'       => $input['provinsi'],
            'kabupaten'      => $input['kabupaten'],
            'no_telp'        => $input['no_telp'],
            'role'           => 'petani', // Default role
        ]);

        // $token = $user->createToken('auth_token')->plainTextToken;
        // $success['token'] = $token;
        // $success['username'] = $user->username;

        $userData = $user->toArray();
        unset($userData['username'], $userData['id_users']);

        return response()->json([
            'success' => true,
            'message' => 'Sukses register',
            'data' => $userData
        ], 200);
    }

    public function login(Request $request)
    {
        $request->validate([
            'username' => 'required',
            'password' => 'required'
        ]);
        $user = User::where('username', $request->username)->first();
        $userData = $user->toArray();
        unset($userData['username'], $userData['id_users']);

        if ($user->role != 'admin' && $user->status == 0) {
            if (Auth::attempt(['username' => $request->username, 'password' => $request->password])) {
                $auth = Auth::user();
                $user->nama_lengkap;
                return response()->json([
                    'success' => true,
                    'message' => 'Login sukses',
                    'user' => $userData,
                    'token' => $user->generateToken(),
                ]);

            } else {
                return response()->json([
                    'success' => false,
                    'message' => 'Cek username dan password lagi',
                    'data' => null
                ]);
            }
        } else {
            return response()->json([
                'success' => false,
                'message' => 'Akun Anda tidak aktif',
                'data' => null
            ]);
        }

    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json(
            [
                'status' => 'success',
                'message' => 'User logged out successfully'
            ]
        );
    }

    public function getAllUser()
    {
        try {
            $user = DB::table('users')
                ->select('id_users','nama_lengkap', 'username', 'tanggal_lahir', 'jenis_kelamin',  'provinsi', 'kabupaten', 'no_telp')
                ->get();

            Log::info(json_encode($user));
            if (!$user) {
                return response()->json(['message' => 'User not found', 'status' => 'error'], 404);
            }

            return response()->json([
                'success' => true,
                'message' => 'Get data sukses',
                'data' => $user
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to get User', 'status' => 'error', 'error' => $e->getMessage()], 500);
        }
    }

    public function getUserById($id)
    {
        try {
            $user = DB::table('users')->where('id_users', $id)
                ->select('nama_lengkap', 'username', 'tanggal_lahir', 'jenis_kelamin',  'provinsi', 'kabupaten', 'no_telp')
                ->first();

            Log::info(json_encode($user));
            if (!$user) {
                return response()->json(['message' => 'User not found', 'status' => 'error'], 404);
            }

            return response()->json([
                'success' => true,
                'message' => 'Get data sukses',
                'data' => $user
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to get User', 'status' => 'error', 'error' => $e->getMessage()], 500);
        }
    }

    public function updateUserProfile(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'nama_lengkap' => 'required',
            'username' => 'required',
            'tanggal_lahir' => 'required|date',
            'jenis_kelamin' => 'required|in:Laki-laki,Perempuan',
            'no_telp' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Ada kesalahan',
                'data' => $validator->errors()
            ], 400);
        }

        try {
            $user = DB::table('users')->where('id_users', $id)->first();

            if (!$user) {
                return response()->json(['message' => 'User not found', 'status' => 'error'], 404);
            }

            DB::table('users')
                ->where('id_users', $id)
                ->update($request->only(['nama_lengkap', 'username', 'tanggal_lahir', 'jenis_kelamin', 'no_telp']));

            $updatedUser = DB::table('users')->where('id_users', $id)
                ->select('nama_lengkap', 'username', 'tanggal_lahir', 'jenis_kelamin',  'provinsi', 'kabupaten', 'no_telp')
                ->first();

            return response()->json([
                'success' => true,
                'message' => 'Update profile sukses',
                'data' => $updatedUser
            ], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to update profile', 'status' => 'error', 'error' => $e->getMessage()], 500);
        }
    }
}
