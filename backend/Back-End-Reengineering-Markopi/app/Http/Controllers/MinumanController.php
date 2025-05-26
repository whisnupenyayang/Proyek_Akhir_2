<?php

namespace App\Http\Controllers;

use Exception;
use App\Models\Minuman;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class MinumanController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $minumans = Minuman::all();
        return view('admin.minuman.minuman', compact('minumans'), [
            'title' => 'Minuman'
        ]);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('admin.minuman.minuman_form', [
            'title' => 'Tambah Data Minuman'
        ]);
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
                'nama_minuman' => 'required',
                'bahan_minuman' => 'required',
                'langkah_minuman' => 'required',
                'credit_gambar' => 'required',
                'gambar.*' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:5120'
            ]);

            $minuman = Minuman::create([
                'nama_minuman' => $request->nama_minuman,
                'bahan_minuman' => $request->bahan_minuman,
                'langkah_minuman' => $request->langkah_minuman,
                'credit_gambar' => $request->credit_gambar,
            ]);

            if ($minuman) {
                foreach ($request->file('gambar') as $gambar) {
                    $gambarPath = $gambar->store('minumanimage', 'public');

                    Log::info('Path Gambar: ' . $gambarPath);

                    $minuman->images()->create([
                        'gambar' => $gambarPath,
                    ]);
                }

                return redirect()->route('minuman.index')->with('success', 'Informasi Minuman berhasil ditambahkan');
            } else {
                $errorMessage = $minuman->status() . ': ' . $minuman->body();
                throw new Exception('Failed to add product. ' . $errorMessage);
            }
        } catch (Exception $e) {
            return redirect()->back()->with('error', $e->getMessage())->withInput();
        }
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        // Mengambil data minuman$minuman berdasarkan ID
        $minuman = Minuman::findOrFail($id);

        // Menampilkan halaman detail dengan data minuman$minuman
        return view('admin.minuman.detail', compact('minuman'),  [
            'title' => 'Detail Data Minuman'
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $minuman = Minuman::findOrFail($id);
        return view('admin.minuman.minuman_edit', compact('minuman'), [
            'title' => 'Minuman'
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
            'nama_minuman' => 'required',
            'bahan_minuman' => 'required',
            'langkah_minuman' => 'required',
            'credit_gambar' => 'required',
            'gambar.*' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:5120'
        ]);

        try {
            $minuman = Minuman::findOrFail($id);
            $minuman->nama_minuman = $request->nama_minuman;
            $minuman->bahan_minuman = $request->bahan_minuman;
            $minuman->langkah_minuman = $request->langkah_minuman;
            $minuman->credit_gambar = $request->credit_gambar;

            if ($request->hasFile('gambar')) {
                $newImages = [];

                foreach ($request->file('gambar') as $newImage) {
                    $newImagePath = $newImage->store('minumanimage', 'public');
                    $newImages[] = ['gambar' => $newImagePath];
                }

                $this->deleteImages($minuman);

                $minuman->images()->delete();
                $minuman->images()->createMany($newImages);
            }

            $minuman->save();

            if ($minuman) {
                return redirect()->route('minuman.index')->with('success', 'Informasi Minuman Kopi Berhasil di Edit');
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
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        try {
            $minuman = Minuman::findOrFail($id);
            $this->deleteImages($minuman);
            $minuman->delete();
            if ($minuman) {
                return redirect()->route('minuman.index')->with('success', 'Informasi Minuman Berhasil dihapus');
            } else {
                throw new Exception('Failed to delete.');
            }
        } catch (Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    protected function deleteImages(Minuman $minuman)
    {
        foreach ($minuman->images as $image) {
            Storage::disk('public')->delete($image->gambar);

            $image->delete();
        }
    }
}
