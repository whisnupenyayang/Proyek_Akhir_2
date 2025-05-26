<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Pengajuan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class PengajuanController extends Controller
{
    public function index()
    {
        $pengajuans = Pengajuan::join('users', 'pengajuans.user_id', '=', 'users.id_users')
            ->where('pengajuans.status', '0')
            ->select('pengajuans.*', 'users.username')
            ->get();

        return view('admin.komunitas.pengajuan', compact('pengajuans'), [
            'title' => 'Data Pengajuan'
        ]);
    }

    public function accept($id)
    {
        try {
            $pengajuan = Pengajuan::find($id);
            if (!$pengajuan) {
                return redirect()->route('pengajuan.index')->with('error', 'Pengajuan tidak ditemukan');
            }

            $user = DB::table('users')->where('id_users', $pengajuan->user_id)->first();
            if ($user) {
                DB::table('users')
                    ->where('id_users', $pengajuan->user_id)
                    ->update(['role' => $pengajuan->tipe_pengajuan]);

                $pengajuan->update(['status' => '1']);

                return redirect()->route('pengajuan.index')->with('success', 'Pengajuan berhasil diterima dan role user diperbarui');
            } else {
                return redirect()->route('pengajuan.index')->with('error', 'User tidak ditemukan');
            }
        } catch (\Exception $e) {
            return redirect()->route('pengajuan.index')->with('error', 'Terjadi kesalahan: ' . $e->getMessage());
        }
    }


    public function reject($id)
    {
        $dataPengajuan = Pengajuan::where('id_pengajuans', $id)->update(['status' => '2']);

        return redirect()->route('pengajuan.index')->with('success', 'Pengajuan berhasil ditolak');
    }

    public function get_data_user()
    {
        $getDataUser = User::orderBy('role', 'asc')->get();
        // dd($getDataUser);
        return view('admin.users.index', compact('getDataUser'), [
            'title' => 'Informasi Data Users'
        ]);
    }

    public function deactivate($id)
    {
        try {
            $updated = DB::table('users')
                ->where('id_users', $id)
                ->update(['status' => 1]);

            if ($updated) {
                Log::info('User with ID ' . $id . ' has been deactivated.');
            } else {
                Log::warning('Failed to deactivate user with ID ' . $id . '. User may not exist.');
            }

            return redirect()->route('getDataUser')->with('success', 'Akun pengguna berhasil dinonaktifkan.');
        } catch (\Exception $e) {
            Log::error('Error deactivating user: ' . $e->getMessage());
            return redirect()->route('getDataUser')->with('error', 'Terjadi kesalahan saat menonaktifkan akun.');
        }
    }

    public function activate($id)
    {
        try {
            $updated = DB::table('users')
                ->where('id_users', $id)
                ->update(['status' => null]);

            if ($updated) {
                Log::info('User with ID ' . $id . ' has been activated.');
            } else {
                Log::warning('Failed to activate user with ID ' . $id . '. User may not exist.');
            }

            return redirect()->route('getDataUser')->with('success', 'Akun pengguna berhasil diaktifkan kembali.');
        } catch (\Exception $e) {
            Log::error('Error activating user: ' . $e->getMessage());
            return redirect()->route('getDataUser')->with('error', 'Terjadi kesalahan saat mengaktifkan kembali akun.');
        }
    }
}
