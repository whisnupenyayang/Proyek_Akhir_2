<?php

namespace App\Http\Controllers;

use Exception;
use App\Models\Pasca;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class PascaPanenController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $pascas = Pasca::all();
        return view('admin.pasca.pasca_panen', compact('pascas'), [
            'title' => 'Pasca'
        ]);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $data = [
            'model'     => new Pasca(),
            'title'     => 'Form Tambah Informasi Pasca Panen',
        ];

        return view('admin.pasca.pasca_form', $data);
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
                'tahapan' => 'required|min:5',
                'deskripsi' => 'required|min:20',
                'link' => 'required|url',
                'credit_gambar' => 'required',
                'kategori' => 'required',
                'gambar.*' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:5120'
            ]);

            $kategori = $request->input('kategori');

            $pasca = Pasca::create([
                'tahapan' => $request->tahapan,
                'deskripsi' => $request->deskripsi,
                'link' => $request->link,
                'credit_gambar' => $request->credit_gambar,
                'kategori' => $kategori,
            ]);

            if ($pasca) {
                foreach ($request->file('gambar') as $gambar) {
                    $gambarPath = $gambar->store('pascaimage', 'public');

                    Log::info('Path Gambar: ' . $gambarPath);

                    $pasca->images()->create([
                        'gambar' => $gambarPath,
                    ]);
                }

                return redirect()->route('pasca.index')->with('success', 'Informasi Pasca Panen berhasil ditambahkan');
            } else {
                $errorMessage = $pasca->status() . ': ' . $pasca->body();
                throw new Exception('Failed to add product. ' . $errorMessage);
            }
        } catch (Exception $e) {
            return redirect()->back()->with('error', $e->getMessage())->withInput();
        }
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Pasca  $pasca
     * @return \Illuminate\Http\Response
     */

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\Pasca  $pasca
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $pasca = Pasca::findOrFail($id);
        return view('admin.pasca.pasca_edit', [
            'pasca' => $pasca,
            'title'     => 'Form Update data Informasi Pasca',
        ]);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Pasca  $pasca
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $request->validate([
            'tahapan' => 'required|min:5',
            'deskripsi' => 'required|min:20',
            'link' => 'required|url',
            'credit_gambar' => 'required',
            'kategori' => 'required'
        ]);

        $kategori = $request->input('kategori');

        try {
            $pasca = Pasca::findOrFail($id);
            $pasca->tahapan = $request->tahapan;
            $pasca->deskripsi = $request->deskripsi;
            $pasca->link = $request->link;
            $pasca->credit_gambar = $request->credit_gambar;
            $pasca->kategori = $kategori;

            if ($request->hasFile('gambar')) {
                $newImages = [];

                foreach ($request->file('gambar') as $newImage) {
                    $newImagePath = $newImage->store('pascaimage', 'public');
                    $newImages[] = ['gambar' => $newImagePath];
                }

                $this->deleteImages($pasca);

                $pasca->images()->delete();
                $pasca->images()->createMany($newImages);
            }

            $pasca->save();

            if ($pasca) {
                return redirect()->route('pasca.index')->with('success', 'Data Informasi Pasca Panen Berhasil di Ubah');
            } else {
                throw new Exception('Gagal mengupdate data');
            }
        } catch (Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Pasca  $pasca
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        try {
            $pasca = Pasca::findOrFail($id);
            $this->deleteImages($pasca);
            $pasca->delete();
            if ($pasca) {
                return redirect()->route('pasca.index')->with('success', 'Data Informasi Pasca Panen Berhasil dihapus');
            } else {
                throw new Exception('Failed to delete.');
            }
        } catch (Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    protected function deleteImages(pasca $pasca)
    {
        foreach ($pasca->images as $image) {
            Storage::disk('public')->delete($image->gambar);

            $image->delete();
        }
    }

    public function show($id)
    {
        $pasca = Pasca::findOrFail($id);

        return view('admin.pasca.detail', compact('pasca'), [
            'title' => 'Informasi Data Pasca Panen'
        ]);
    }
}
