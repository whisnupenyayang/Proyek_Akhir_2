<?php

namespace App\Http\Controllers;

use App\Models\Pengepul;
use App\Models\Iklan;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class AuthController extends Controller
{
    public function login()
    {
        return view('login');
    }

    public function proseslogin(Request $request)
    {
        $credentials = $request->validate([
            'username' => 'required',
            'password' => 'required'
        ]);

        if (Auth::attempt($credentials)) {
            $user = User::where('username', $request->username)->first();

            if ($user->role != 'admin') {
                return redirect()->back();
            } else {
                session([
                    'id_users' => $user->id_users,
                    'username' => $user->username,
                    'role' => $user->role
                ]);
                return redirect()->route('dashboard.admin');
            }
        } else {
              return redirect()->back()->with('error', 'Credentials tidak valid');
        }
    }

    public function logout(Request $request)
    {
        Auth::logout();

        $request->session()->invalidate();

        return redirect('/');
    }

    public function dashboard()
    {
        if (auth()->user()->role !== 'admin') {
            return redirect('/')->withErrors(['Anda tidak memiliki akses.']);
        }

        $avgPerMonth = Pengepul::selectRaw('MONTH(created_at) as bulan, AVG(harga) as rata_harga')
            ->whereYear('created_at', date('Y'))
            ->groupByRaw('MONTH(created_at)')
            ->get();

        $totalPengepul = Pengepul::distinct('id')->count('id');
        $totalIklan = Iklan::count(); // Menambahkan jumlah iklan

        return view('admin.layouts.dashboard', [
            'title' => 'Dashboard',
            'avgPerMonth' => $avgPerMonth,
            'totalPengepul' => $totalPengepul,
            'totalIklan' => $totalIklan,
        ]);
    }
}
