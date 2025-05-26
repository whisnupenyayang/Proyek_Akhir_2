<?php

namespace App\Http\Controllers;

use Exception;
use App\Models\Pengepul;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class PengepulController extends Controller
{
    // Menampilkan semua pengepul
    public function index()
    {
        $title = 'Data Pengepul';
        $pengepuls = Pengepul::all();
        return view('admin.pengepul.pengepul', compact('pengepuls', 'title'));
    }

    public function create()
    {
        return view('admin.pengepul.tambah_pengepul');
    }

    public function store(Request $request)
{
    try {
        $validatedData = $request->validate([
            'nama_toko' => 'required|string|max:100',
            'alamat' => 'required|string|max:255',
            'jenis_kopi' => 'required|string|max:100',
            'harga' => 'required|numeric',
            'nomor_telepon' => 'required|string|max:20',
            'gambar' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:5120',
        ]);

        // Upload gambar jika ada
        $namaGambar = null;
        $urlGambar = null;
        if ($request->hasFile('gambar')) {
            $file = $request->file('gambar');
            $namaGambar = time() . '.' . $file->getClientOriginalExtension();
            $file->move(public_path('images'), $namaGambar); // Simpan di public/images
            $urlGambar = 'images/' . $namaGambar;
        }

        $pengepul = Pengepul::create([
            'nama_toko' => $validatedData['nama_toko'],
            'alamat' => $validatedData['alamat'],
            'jenis_kopi' => $validatedData['jenis_kopi'],
            'harga' => $validatedData['harga'],
            'nomor_telepon' => $validatedData['nomor_telepon'],
            'nama_gambar' => $namaGambar,
            'url_gambar' => $urlGambar,
            'user_id' => 2, // Hardcode user_id untuk testing
        ]);

        return redirect()->route('admin.pengepul')->with('success', 'Informasi Pengepul berhasil ditambahkan');
    } catch (Exception $e) {
        Log::error('Error storing pengepul: ' . $e->getMessage());
        return redirect()->back()->with('error', $e->getMessage())->withInput();
    }
}




    public function edit($id)
    {
        $pengepul = Pengepul::findOrFail($id);
        $title = 'Form Update Data Pengepul';
        return view('admin.pengepul.edit_pengepul', compact('pengepul', 'title'));
    }

    public function update(Request $request, $id)
{
    try {
        $validatedData = $request->validate([
            'nama_toko' => 'required|string|max:100',
            'alamat' => 'required|string|max:255',
            'jenis_kopi' => 'required|string|max:100',
            'harga' => 'required|numeric',
            'nomor_telepon' => 'required|string|max:20',
            'gambar' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:5120',
        ]);

        $pengepul = Pengepul::findOrFail($id);

        if ($request->hasFile('gambar')) {
            // Hapus gambar lama jika ada
            if ($pengepul->url_gambar && file_exists(public_path($pengepul->url_gambar))) {
                unlink(public_path($pengepul->url_gambar));
            }

            $file = $request->file('gambar');
            $filename = time() . '.' . $file->getClientOriginalExtension();
            $file->move(public_path('images'), $filename);
            $pengepul->nama_gambar = $filename;
            $pengepul->url_gambar = 'images/' . $filename;
        }

        $pengepul->nama_toko = $validatedData['nama_toko'];
        $pengepul->alamat = $validatedData['alamat'];
        $pengepul->jenis_kopi = $validatedData['jenis_kopi'];
        $pengepul->harga = $validatedData['harga'];
        $pengepul->nomor_telepon = $validatedData['nomor_telepon'];
        $pengepul->save();

        return redirect()->route('admin.pengepul')->with('success', 'Data Pengepul berhasil diubah');
    } catch (Exception $e) {
        Log::error('Error updating pengepul: ' . $e->getMessage());
        return redirect()->back()->with('error', $e->getMessage())->withInput();
    }
}


    public function destroy($id)
{
    $pengepul = Pengepul::findOrFail($id);

    // Hapus gambar jika ada
    if ($pengepul->url_gambar && file_exists(public_path($pengepul->url_gambar))) {
        unlink(public_path($pengepul->url_gambar));
    }

    $pengepul->delete();

    return redirect()->route('admin.pengepul')->with('success', 'Data pengepul berhasil dihapus.');
}


    public function show($id)
    {
        $pengepul = Pengepul::find($id);

        if (!$pengepul) {
            return redirect()->route('admin.pengepul.pengepul')->with('error', 'Pengepul tidak ditemukan');
        }

        $title = 'Detail Pengepul';
        return view('admin.pengepul.detail', compact('pengepul', 'title'));
    }

    // Update field via AJAX (contoh jika diperlukan)
    public function updateField(Request $request)
    {
        $pengepul = Pengepul::find($request->id);

        if (!$pengepul) {
            return response()->json(['success' => false, 'message' => 'Data tidak ditemukan']);
        }

        $field = $request->field;
        $value = $request->value;

        // Batasi field yang boleh diupdate lewat ajax
        if (in_array($field, ['alamat', 'jenis_kopi', 'harga', 'nomor_telepon', 'nama_toko'])) {
            $pengepul->$field = $value;
            $pengepul->save();
            return response()->json(['success' => true]);
        }

        return response()->json(['success' => false, 'message' => 'Field tidak valid']);
    }
}
