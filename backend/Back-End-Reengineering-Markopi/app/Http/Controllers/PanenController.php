<?php

namespace App\Http\Controllers;

use Exception;
use App\Models\Panen;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Storage;

class PanenController extends Controller
{
    public function index()
    {
        $panens = Panen::all();
        return view('admin.panen.panen', compact('panens'), [
            'title' => 'Panen'
        ]);
    }

    public function create()
    {
        $data = [
            'model'     => new Panen(),
            'title'     => 'Form Tambah Informasi Panen',
        ];

        return view('admin.panen.panen_form', $data);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        try {
            $request->validate([
                'deskripsi' => 'required|min:20',
                'link' => 'required|url',
                'credit_gambar' => 'required',
                'kategori' => 'required',
                'gambar.*' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:5120'
            ]);

            $kategori = $request->input('kategori');

            $panen = Panen::create([
                'deskripsi' => $request->deskripsi,
                'link' => $request->link,
                'credit_gambar' => $request->credit_gambar,
                'kategori' => $kategori
            ]);

            if ($panen) {
                foreach ($request->file('gambar') as $gambar) {
                    $gambarPath = $gambar->store('panenimage', 'public');

                    Log::info('Path Gambar: ' . $gambarPath);

                    $panen->images()->create([
                        'gambar' => $gambarPath,
                    ]);
                }

                return redirect()->route('panen.index')->with('success', 'Informasi Panen berhasil ditambahkan');
            } else {
                $errorMessage = $panen->status() . ': ' . $panen->body();
                throw new Exception('Failed to add product. ' . $errorMessage);
            }
        } catch (Exception $e) {
            return redirect()->back()->with('error', $e->getMessage())->withInput();
        }
    }

    public function edit($id)
    {
        $panen = Panen::findOrFail($id);
        return view('admin.panen.panen_edit', [
            'panen' => $panen,
            'title'     => 'Form Update data Informasi Panen',
        ]);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $request->validate([
            'deskripsi' => 'required|min:20',
            'link' => 'required|url',
            'credit_gambar' => 'required',
            'kategori' => 'required'
        ]);

        $kategori = $request->input('kategori');

        try {
            $panen = Panen::findOrFail($id);
            $panen->deskripsi = $request->deskripsi;
            $panen->link = $request->link;
            $panen->credit_gambar = $request->credit_gambar;
            $panen->kategori = $kategori;

            if ($request->hasFile('gambar')) {
                $newImages = [];

                foreach ($request->file('gambar') as $newImage) {
                    $newImagePath = $newImage->store('panenimage', 'public');
                    $newImages[] = ['gambar' => $newImagePath];
                }

                $this->deleteImages($panen);

                $panen->images()->delete();
                $panen->images()->createMany($newImages);
            }

            $panen->save();

            if ($panen) {
                return redirect()->route('panen.index')->with('success', 'Data Informasi Panen Berhasil di Ubah');
            } else {
                throw new Exception('Gagal mengupdate data');
            }
        } catch (Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function destroy($id)
    {
        try {
            $panen = Panen::findOrFail($id);
            $this->deleteImages($panen);
            $panen->delete();
            if ($panen) {
                return redirect()->route('panen.index')->with('success', 'Data Informasi Panen Berhasil dihapus');
            } else {
                throw new Exception('Failed to delete.');
            }
        } catch (Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    protected function deleteImages(panen $panen)
    {
        foreach ($panen->images as $image) {
            Storage::disk('public')->delete($image->gambar);

            $image->delete();
        }
    }

    public function show($id)
    {
        $panen = Panen::findOrFail($id);

        return view('admin.panen.detail', compact('panen'),  [
            'title' => 'Detail Tahapan Panen'
        ]);
    }
}
