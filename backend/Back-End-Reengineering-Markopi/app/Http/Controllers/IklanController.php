<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Iklan;
use Illuminate\Support\Facades\Storage;
use Exception;
class IklanController extends Controller
{
    public function index()
    {
        $title = 'Data Iklan';
        $iklans = Iklan::all();

        return view('admin.iklan.iklan', compact('iklans', 'title'));
    }

    public function show($id)
    {
        $iklan = Iklan::findOrFail($id);
        $title = 'Detail Iklan';

        return view('admin.iklan.detail', compact('iklan', 'title'));
    }

    public function edit($id)
    {
        $iklan = Iklan::findOrFail($id);
        return view('admin.iklan.edit', compact('artikel'), [
            'title' => 'Edit Iklan'
        ]);
    }

    public function update(Request $request, $id)
    {
        $iklan = Iklan::findOrFail($id);

        $data = $request->only(['judul_iklan', 'deskripsi_iklan', 'link']);
        $iklan->update(array_filter($data)); // hanya update field yang dikirim

        if ($request->hasFile('gambar')) {
        // Optional: hapus gambar lama
        if ($iklan->gambar && file_exists(public_path('foto/' . $iklan->gambar))) {
            unlink(public_path('foto/' . $iklan->gambar));
        }

        $file = $request->file('gambar');
        $filename = time() . '_' . $file->getClientOriginalName();
        $file->move(public_path('foto'), $filename);
        $iklan->gambar = $filename;
    }

    $iklan->save();

    return redirect()->route('iklan.index')->with('success', 'Iklan berhasil diperbarui.');
    }

    public function create()
    {
        $title = 'Tambah Iklan';

        return view('admin.iklan.tambah', compact('title'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'judul_iklan' => 'required|string|max:255',
            'deskripsi_iklan' => 'required|string',
            'link' => 'required|string|max:100',
            'gambar' => 'required|image|mimes:jpg,jpeg,png|max:2048'
        ]);

        $file = $request->file('gambar');
        $namaFile = time() . '_' . $file->getClientOriginalName();
        $file->move(public_path('foto'), $namaFile);

        Iklan::create([
            'judul_iklan' => $request->judul_iklan,
            'deskripsi_iklan' => $request->deskripsi_iklan,
            'link' => $request->link,
            'gambar' => $namaFile
        ]);
        return redirect()->route('iklan.index')->with('success', 'Iklan berhasil ditambahkan.');
    }

    public function destroy($id)
    {
        try {
            $iklan = Iklan::findOrFail($id);
            $this->deleteImages($iklan);
            $iklan->delete();

            return redirect()->route('iklan.index')->with('success', 'Iklan berhasil dihapus');
        } catch (Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    protected function deleteImages(Iklan $iklan)
{
    if ($iklan->gambar && Storage::disk('public')->exists($iklan->gambar)) {
        Storage::disk('public')->delete($iklan->gambar);
    }
}

}
