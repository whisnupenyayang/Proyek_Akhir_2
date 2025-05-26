<?php
// app/Http/Controllers/KegiatanController.php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\TahapanKegiatan;
use App\Models\JenisTahapanKegiatan;
use Illuminate\Support\Facades\Storage;

class KegiatanController extends Controller
{
    public function budidaya(Request $request)
    {
        // Mengambil input dari request untuk jenis kopi
        $jenisKopi = $request->input('jenis_kopi');

        // Mengambil data tahapan kegiatan dengan filter berdasarkan jenis kopi dan kegiatan 'budidaya'
        $tahapanBudidaya = TahapanKegiatan::when($jenisKopi, function ($query) use ($jenisKopi) {
            return $query->where('jenis_kopi', $jenisKopi);
        })->where('kegiatan', 'budidaya') // Filter berdasarkan kegiatan 'budidaya'
            ->get();

        // Mengembalikan view dengan data yang sudah difilter
        return view('admin.kegiatan.budidaya', [
            'title' => 'Kegiatan Budidaya Kopi',
            'tahapanBudidaya' => $tahapanBudidaya,
        ]);
    }

    public function dataBudidaya($namaTahapan, Request $request)
    {
        $jenisKopi = $request->input('jenis_kopi');

        $tahapanBudidaya = TahapanKegiatan::with('jenisTahapanKegiatan')
            ->where('kegiatan', 'budidaya')
            ->where('nama_tahapan', str_replace('-', ' ', $namaTahapan))
            ->when($jenisKopi, function ($query) use ($jenisKopi) {
                return $query->where('jenis_kopi', $jenisKopi);
            })
            ->get();

        return view('admin.kegiatan.data_budidaya', [
            'title' => 'Data Budidaya Kopi',
            'namaTahapan' => $namaTahapan,
            'jenisKopi' => $jenisKopi,
            'tahapanBudidaya' => $tahapanBudidaya,
        ]);
    }


    public function createBudidaya()
    {
        $existingTahapan = TahapanKegiatan::where('kegiatan', 'budidaya')->pluck('nama_tahapan')->unique();

        return view('admin.kegiatan.create_budidaya', [
            'title' => 'Buat Informasi Budidaya Kopi',
            'existingTahapan' => $existingTahapan,
        ]);
    }

    public function storeBudidaya(Request $request)
    {
        $request->validate([
            'jenis_kopi' => 'required|string',
            'judul' => 'required|string|max:255',
            'deskripsi' => 'required|string',
            'url_gambar' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
            'nama_file' => 'required|file|mimes:pdf,doc,docx,xls,xlsx,zip|max:5120',
            'nama_tahapan_existing' => 'nullable|string',
            'nama_tahapan_baru' => 'nullable|string',
        ]);

        // Validasi: hanya boleh pilih salah satu (tahapan baru atau existing)
        if ($request->filled('nama_tahapan_existing') && $request->filled('nama_tahapan_baru')) {
            return back()->withErrors(['nama_tahapan_baru' => 'Pilih salah satu: tahapan yang sudah ada atau masukkan tahapan baru.']);
        }

        // Tentukan nama tahapan
        $namaTahapan = $request->nama_tahapan_baru ?: $request->nama_tahapan_existing;

        if (!$namaTahapan) {
            return back()->withErrors(['nama_tahapan' => 'Pilih atau masukkan nama tahapan.']);
        }

        // Ambil atau buat tahapan budidaya berdasarkan jenis kopi
        $tahapan = TahapanKegiatan::firstOrCreate([
            'nama_tahapan' => $namaTahapan,
            'kegiatan' => 'budidaya',
            'jenis_kopi' => $request->jenis_kopi,
        ]);

        // Data yang akan disimpan ke jenis_tahapan_kegiatan
        $data = [
            'judul' => $request->judul,
            'deskripsi' => $request->deskripsi,
        ];

        // Upload gambar jika ada
        if ($request->hasFile('url_gambar')) {
            $gambarPath = $request->file('url_gambar')->store('gambar_budidaya', 'public');
            $data['url_gambar'] = $gambarPath;
        }

        // Upload file jika ada
        if ($request->hasFile('nama_file')) {
            $filePath = $request->file('nama_file')->store('file_budidaya', 'public');
            $data['nama_file'] = $filePath;
        }

        // Simpan melalui relasi ke tahapan
        $tahapan->jenisTahapanKegiatan()->create($data);

        return redirect()->route('kegiatan.budidaya')->with('success', 'Informasi Budidaya berhasil ditambahkan.');
    }




    // Menampilkan kegiatan panen
    public function panen(Request $request)
    {
        $jenisKopi = $request->input('jenis_kopi');

        // Filter berdasarkan kegiatan 'panen' dan jenis kopi (jika ada)
        $tahapanPanen = TahapanKegiatan::when($jenisKopi, function ($query) use ($jenisKopi) {
            return $query->where('jenis_kopi', $jenisKopi);
        })->where('kegiatan', 'panen') // Filter berdasarkan kegiatan 'panen'
            ->get();

        return view('admin.kegiatan.panen', [
            'title' => 'Kegiatan Panen Kopi',
            'tahapanPanen' => $tahapanPanen,
        ]);
    }

    public function dataPanen(Request $request, $nama_tahapan)
    {
        $jenisKopi = $request->query('jenis_kopi');

        $tahapanBudidaya = TahapanKegiatan::whereRaw('LOWER(nama_tahapan) = ?', [str_replace('-', ' ', strtolower($nama_tahapan))])
            ->when($jenisKopi, function ($query) use ($jenisKopi) {
                return $query->where('jenis_kopi', $jenisKopi);
            })
            ->get();

        return view('admin.kegiatan.data_budidaya', [
            'tahapanBudidaya' => $tahapanBudidaya,
            'namaTahapan' => ucwords(str_replace('-', ' ', $nama_tahapan)),
            'jenisKopi' => $jenisKopi,
            'title' => 'Data Budidaya'
        ]);
    }

    public function createPanen()
    {
        $existingTahapan = TahapanKegiatan::where('kegiatan', 'panen')->pluck('nama_tahapan')->unique();

        return view('admin.kegiatan.create_panen', [
            'title' => 'Buat Informasi Panen Kopi',
            'existingTahapan' => $existingTahapan,
        ]);
    }

    public function storePanen(Request $request)
    {
        $request->validate([
            'jenis_kopi' => 'required|string',
            'judul' => 'required|string',
            'deskripsi' => 'required|string',
            'url_gambar' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
            'nama_file' => 'required|file|mimes:pdf,doc,docx,xls,xlsx,zip|max:5120',
        ]);

        $namaTahapan = $request->nama_tahapan_baru ?: $request->nama_tahapan_existing;

        if (!$namaTahapan) {
            return redirect()->back()->with('error', 'Silakan pilih atau isi nama tahapan.');
        }

        // Cek atau buat tahapan
        $tahapan = TahapanKegiatan::firstOrCreate([
            'nama_tahapan' => $namaTahapan,
            'kegiatan' => 'panen',
        ]);

        $data = [
            'tahapan_kegiatan_id' => $tahapan->id,
            'jenis_kopi' => $request->jenis_kopi,
            'judul' => $request->judul,
            'deskripsi' => $request->deskripsi,
        ];

        if ($request->hasFile('url_gambar')) {
            $gambarPath = $request->file('url_gambar')->store('gambar_panen', 'public');
            $data['url_gambar'] = $gambarPath;
        }

        if ($request->hasFile('nama_file')) {
            $filePath = $request->file('nama_file')->store('file_panen', 'public');
            $data['nama_file'] = $filePath;
        }

        // **Simpan data ke model JenisTahapanKegiatan**
        JenisTahapanKegiatan::create($data);

        return redirect()->route('kegiatan.panen')->with('success', 'Informasi panen berhasil ditambahkan.');
    }




    public function pascapanen(Request $request)
    {
        $jenisKopi = $request->input('jenis_kopi');

        // Filter berdasarkan kegiatan 'pascapanen' dan jenis kopi (jika ada)
        $tahapanPascapanen = TahapanKegiatan::when($jenisKopi, function ($query) use ($jenisKopi) {
            return $query->where('jenis_kopi', $jenisKopi);
        })->where('kegiatan', 'pasca_panen') // Filter berdasarkan kegiatan 'pascapanen'
            ->get();

        return view('admin.kegiatan.pascapanen', [
            'title' => 'Kegiatan Pasca Panen Kopi',
            'tahapanPascapanen' => $tahapanPascapanen,
        ]);
    }

    public function datapascapanen(Request $request, $nama_tahapan)
    {
        $jenisKopi = $request->query('jenis_kopi');

        $tahapanBudidaya = TahapanKegiatan::whereRaw('LOWER(nama_tahapan) = ?', [str_replace('-', ' ', strtolower($nama_tahapan))])
            ->when($jenisKopi, function ($query) use ($jenisKopi) {
                return $query->where('jenis_kopi', $jenisKopi);
            })
            ->get();

        return view('admin.kegiatan.data_budidaya', [
            'tahapanBudidaya' => $tahapanBudidaya,
            'namaTahapan' => ucwords(str_replace('-', ' ', $nama_tahapan)),
            'jenisKopi' => $jenisKopi,
            'title' => 'Data Budidaya'
        ]);
    }

    public function createPascapanen()
    {
        $existingTahapan = TahapanKegiatan::where('kegiatan', 'pasca_panen')->pluck('nama_tahapan')->unique();

        return view('admin.kegiatan.create_pascapanen', [
            'title' => 'Buat Informasi Pasca Panen Kopi',
            'existingTahapan' => $existingTahapan,
        ]);
    }

    // Simpan data pascapanen
    public function storePascapanen(Request $request)
    {
        $request->validate([
            'jenis_kopi' => 'required|string',
            'judul' => 'required|string|max:255',
            'deskripsi' => 'required|string',
            'url_gambar' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'nama_file' => 'required|file|mimes:pdf,doc,docx,xls,xlsx,zip|max:5120',
            'nama_tahapan_existing' => 'nullable|string',
            'nama_tahapan_baru' => 'nullable|string',
        ]);

        // Tentukan nama tahapan
        $namaTahapan = $request->nama_tahapan_baru ?: $request->nama_tahapan_existing;

        if (!$namaTahapan) {
            return back()->withErrors(['nama_tahapan' => 'Pilih atau masukkan nama tahapan.'])->withInput();
        }

        // Ambil atau buat tahapan baru
        $tahapan = TahapanKegiatan::firstOrCreate([
            'nama_tahapan' => $namaTahapan,
            'kegiatan' => 'pasca_panen',
            'jenis_kopi' => $request->jenis_kopi,
        ]);

        // Siapkan data
        $data = [
            'judul' => $request->judul,
            'deskripsi' => $request->deskripsi,
        ];

        // Upload gambar (opsional)
        if ($request->hasFile('url_gambar')) {
            $gambarPath = $request->file('url_gambar')->store('gambar_pascapanen', 'public');
            $data['url_gambar'] = $gambarPath;
        }

        // Upload dokumen
        if ($request->hasFile('nama_file')) {
            $filePath = $request->file('nama_file')->store('dokumen_pascapanen', 'public');
            $data['nama_file'] = $filePath;
        }

        // Simpan ke relasi
        $tahapan->jenisTahapanKegiatan()->create($data);

        return redirect()->route('kegiatan.pascapanen')->with('success', 'Informasi Pasca Panen berhasil disimpan.');
    }




    public function create()
    {
        return view('admin.kegiatan.create_budidaya'); // Halaman form tambah tahapan
    }

    public function store(Request $request)
    {
        $request->validate([
            'nama_tahapan' => 'required|string|max:255',
            'kegiatan' => 'required|string',
            'jenis_kopi' => 'required|string|max:255',
        ]);

        TahapanKegiatan::create([
            'nama_tahapan' => $request->nama_tahapan,
            'kegiatan' => $request->kegiatan,
            'jenis_kopi' => $request->jenis_kopi,
        ]);

        return redirect()->route('kegiatan.index'); // Redirect kembali ke halaman index kegiatan
    }

    public function destroy($id)
    {
        $jenis = JenisTahapanKegiatan::findOrFail($id);

        // Hapus file gambar dan file jika ada
        if ($jenis->url_gambar) {
            Storage::delete($jenis->url_gambar);
        }
        if ($jenis->nama_file) {
            Storage::delete($jenis->nama_file);
        }

        $jenis->delete();

        return redirect()->back()->with('success', 'Data berhasil dihapus.');
    }

    public function update(Request $request, $id)
    {
        // Validasi data input
        $request->validate([
            'judul' => 'required|string|max:255',
            'deskripsi' => 'required|string',
            'url_gambar' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
            'nama_file' => 'required|file|max:5120',
        ]);

        // Cari data berdasarkan ID
        $jenis = JenisTahapanKegiatan::findOrFail($id);

        // Update field teks
        $jenis->judul = $request->judul;
        $jenis->deskripsi = $request->deskripsi;

        // Jika ada gambar baru, simpan dan hapus yang lama
        if ($request->hasFile('url_gambar')) {
            if ($jenis->url_gambar) {
                Storage::delete('images/' . $jenis->url_gambar);
            }
            $pathGambar = $request->file('url_gambar')->store('gambar_tahapan', 'public');
            $jenis->url_gambar = $pathGambar;
        }

        // Jika ada file baru, simpan dan hapus yang lama
        if ($request->hasFile('nama_file')) {
            if ($jenis->nama_file) {
                Storage::delete('images/' . $jenis->nama_file);
            }
            $pathFile = $request->file('nama_file')->store('file_tahapan', 'public');
            $jenis->nama_file = $pathFile;
        }

        // Simpan perubahan
        $jenis->save();

        // Redirect kembali dengan pesan sukses
        return redirect()->back()->with('success', 'Data berhasil diperbarui.');
    }
}
