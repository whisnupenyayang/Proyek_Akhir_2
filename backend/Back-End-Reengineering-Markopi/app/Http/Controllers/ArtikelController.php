<?php

namespace App\Http\Controllers;

use Exception;
use App\Models\Artikel;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ArtikelController extends Controller
{
    public function dashboard()
    {
        return view('admin.dashboard.index', [
            'title' => 'Dashboard'
        ]);
    }

    public function index()
    {
        $artikels = Artikel::all();
        return view('admin.artikel.artikel', compact('artikels'), [
            'title' => 'Artikel'
        ]);
    }

    public function show($id)
    {
        $artikel = Artikel::findOrFail($id);
        return view('admin.artikel.show', compact('artikel'), [
            'title' => 'Detail Artikel'
        ]);
    }

    public function create()
    {
        return view('admin.artikel.create', [
            'title' => 'Buat Artikel Baru'
        ]);
    }

    public function store(Request $request)
{
    try {
        $request->validate([
            'judul_artikel' => 'required',
            'isi_artikel' => 'required',
            'gambar.*' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:5120'
        ]);

        $artikel = Artikel::create([
            'judul_artikel' => $request->judul_artikel,
            'isi_artikel' => $request->isi_artikel,
            'user_id' => 2,  // <== set user_id dari user login (admin)
        ]);

        if ($artikel) {
            if ($request->hasFile('gambar')) {
                foreach ($request->file('gambar') as $gambar) {
                    $filename = time() . '_' . uniqid() . '.' . $gambar->getClientOriginalExtension();
                    $gambar->move(public_path('images'), $filename);

                    $artikel->images()->create([
                        'gambar' => $filename,
                    ]);
                }
            }

            return redirect()->route('artikel.index')->with('success', 'Artikel berhasil ditambahkan');
        } else {
            throw new Exception('Gagal menambahkan artikel.');
        }
    } catch (Exception $e) {
        return redirect()->back()->with('error', $e->getMessage())->withInput();
    }
}



    public function edit($id)
    {
        $artikel = Artikel::findOrFail($id);
        return view('admin.artikel.edit', compact('artikel'), [
            'title' => 'Edit Artikel'
        ]);
    }

    public function update(Request $request, $id)
{
    try {
        $request->validate([
            'isi_artikel' => 'required',
            // 'judul_artikel' => 'required', // hapus dulu kalau tidak diedit inline
        ]);

        $artikel = Artikel::findOrFail($id);
        // Judul artikel tidak berubah kalau form hanya edit isi artikel
        // $artikel->judul_artikel = $request->judul_artikel;

        $artikel->isi_artikel = $request->isi_artikel;

        if ($request->hasFile('gambar')) {
            // Hapus gambar lama
            $this->deleteImages($artikel);

            $newImages = [];
            foreach ($request->file('gambar') as $gambar) {
                $gambarPath = $gambar->store('artikelimage', 'public');
                $newImages[] = ['gambar' => $gambarPath];
            }
            $artikel->images()->delete();
            $artikel->images()->createMany($newImages);
        }

        $artikel->save();

        return redirect()->route('artikel.show', $artikel->id_artikels)->with('success', 'Artikel berhasil diperbarui');
    } catch (Exception $e) {
        return redirect()->back()->with('error', $e->getMessage());
    }
}


    public function destroy($id)
    {
        try {
            $artikel = Artikel::findOrFail($id);
            $this->deleteImages($artikel);
            $artikel->delete();

            return redirect()->route('artikel.index')->with('success', 'Artikel berhasil dihapus');
        } catch (Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    protected function deleteImages(Artikel $artikel)
    {
        foreach ($artikel->images as $image) {
            Storage::disk('public')->delete($image->gambar);
            $image->delete();
        }
    }
}
