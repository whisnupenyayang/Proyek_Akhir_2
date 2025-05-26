<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\PanenController;
use App\Http\Controllers\ArtikelController;
use App\Http\Controllers\MinumanController;
use App\Http\Controllers\BudidayaController;
use App\Http\Controllers\PengajuanController;
use App\Http\Controllers\PascaPanenController;
use App\Http\Controllers\IklanController;
use App\Http\Controllers\PengepulController;
use App\Http\Controllers\ResepController;
use App\Http\Controllers\TokoController;
use App\Http\Controllers\KegiatanController;
/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
*/

// Auth Routes
Route::get('/', [AuthController::class, 'login'])->name('login');
Route::post('/login', [AuthController::class, 'proseslogin']);
Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

Route::get('/admin/dashboard', [AuthController::class, 'dashboard'])->name('dashboard.admin');

// // Admin Routes
// Route::middleware(['auth', 'role:admin'])->prefix('admin')->group(function () {
//     Route::get('/dashboard', [AuthController::class, 'dashboard'])->name('dashboard.admin');
// });

// //Route::middleware(['auth', 'role:admin'])->group(function () {
// Route::get('/dashboard', function () {
//     return view('layouts.dashboard', ['title' => 'Dashboard']);
// })->name('dashboard');


// Fasilitator Routes
// Route::middleware(['auth', 'role:fasilitator'])->prefix('fasilitator')->group(function () {
//     Route::get('/dashboard', [ArtikelController::class, 'dashboard'])->name('dashboard.fasilitator');

//     Route::prefix('artikel')->group(function () {
//         Route::get('/', [ArtikelController::class, 'artikel'])->name('artikel.fasilitator');
//         Route::get('/create', [ArtikelController::class, 'create'])->name('artikel.form');
//         Route::post('/create', [ArtikelController::class, 'store'])->name('artikel.create');
//         Route::get('/detail/{id}', [ArtikelController::class, 'show'])->name('artikel.show');
//         Route::get('/{id}', [ArtikelController::class, 'edit'])->name('artikel.edit');
//         Route::put('/{id}', [ArtikelController::class, 'update'])->name('artikel.update');
//         Route::delete('/{id}', [ArtikelController::class, 'destroy'])->name('artikel.destroy');
//     });
// });


// Budidaya
Route::resource('budidaya', BudidayaController::class)->names(['index' => 'budidaya.index']);
Route::post('budidaya/remove-image', [BudidayaController::class, 'removeImage'])->name('budidaya.removeImage');

// Panen
Route::resource('panen', PanenController::class)->names(['index' => 'panen.index']);

// Pasca Panen
Route::resource('pasca', PascaPanenController::class)->names(['index' => 'pasca.index']);

// Iklan
Route::get('/admin/iklan', [IklanController::class, 'index'])->name('iklan.index');
Route::get('/admin/iklan/create', [IklanController::class, 'create'])->name('iklan.create');
Route::post('/admin/iklan', [IklanController::class, 'store'])->name('iklan.store');
Route::get('/admin/iklan/{id}/edit', [IklanController::class, 'edit'])->name('iklan.edit');
Route::put('/admin/iklan/{id}', [IklanController::class, 'update'])->name('iklan.update');
Route::delete('/admin/iklan/{id}', [IklanController::class, 'destroy'])->name('iklan.destroy');
Route::get('/admin/iklan/{id}', [IklanController::class, 'show'])->name('iklan.show');



//resep
Route::get('/resep', [ResepController::class, 'index'])->name('admin.resep');  // <-- Correct route name
Route::get('/resep/create', [ResepController::class, 'create'])->name('resep.create');
Route::post('/resep', [ResepController::class, 'store'])->name('resep.store');
Route::get('/resep/{id}', [ResepController::class, 'detailResep'])->name('resep.detail');
Route::get('/resep/{id}/edit', [ResepController::class, 'edit'])->name('resep.edit');
Route::delete('/resep/{id}', [ResepController::class, 'destroy'])->name('resep.destroy');
Route::post('/resep/{id}/update', [ResepController::class, 'update'])->name('resep.update');

//toko
Route::get('/toko', [TokoController::class, 'index'])->name('admin.toko');
Route::get('/toko/create', [TokoController::class, 'create'])->name('toko.create');
Route::post('/toko', [TokoController::class, 'store'])->name('toko.store');
Route::get('/toko/{id}', [TokoController::class, 'detailToko'])->name('toko.detail');
Route::delete('/toko/{id}', [TokoController::class, 'destroy'])->name('toko.destroy');
Route::post('/toko/store', [TokoController::class, 'store'])->name('toko.store');

// Artikel Admin
Route::get('admin/artikel', [ArtikelController::class, 'index'])->name('artikel.index');
Route::get('admin/artikel/create', [ArtikelController::class, 'create'])->name('artikel.create');
Route::post('admin/artikel', [ArtikelController::class, 'store'])->name('artikel.store');
Route::get('admin/artikel/{id}', [ArtikelController::class, 'show'])->name('artikel.show');
Route::get('admin/artikel/{id}/edit', [ArtikelController::class, 'edit'])->name('artikel.edit');
Route::put('admin/artikel/{id}', [ArtikelController::class, 'update'])->name('artikel.update');
Route::delete('admin/artikel/{id}', [ArtikelController::class, 'destroy'])->name('artikel.destroy');


// Pengepul
Route::get('/admin/pengepuls', [PengepulController::class, 'index'])->name('admin.pengepul');
Route::get('/admin/pengepul/create', [PengepulController::class, 'create'])->name('pengepul.create');
Route::post('/admin/pengepul', [PengepulController::class, 'store'])->name('pengepul.store');
Route::get('/admin/pengepul/{id}', [PengepulController::class, 'show'])->name('pengepul.show');
Route::get('/admin/pengepul/{id}/edit', [PengepulController::class, 'edit'])->name('admin.pengepul.edit');
Route::put('/admin/pengepul/{id}/update', [PengepulController::class, 'update'])->name('admin.pengepul.update');
Route::post('/admin/pengepul/updateField', [PengepulController::class, 'updateField'])->name('admin.pengepul.updateField');


//kegiatan
Route::get('/kegiatan', [KegiatanController::class, 'index']);
Route::get('/tahapan/create', [KegiatanController::class, 'create'])->name('tahapan.create');
Route::post('/tahapan', [KegiatanController::class, 'store'])->name('tahapan.store');
Route::get('kegiatan/budidaya', [KegiatanController::class, 'budidaya'])->name('kegiatan.budidaya');
Route::get('kegiatan/panen', [KegiatanController::class, 'panen'])->name('kegiatan.panen');
Route::get('kegiatan/pascapanen', [KegiatanController::class, 'pascapanen'])->name('kegiatan.pascapanen');
Route::get('kegiatan/budidaya/{nama_tahapan}', [KegiatanController::class, 'detailTahapan'])->name('kegiatan.detailTahapan');
Route::get('kegiatan/budidaya/data/{nama_tahapan}', [KegiatanController::class, 'dataBudidaya'])->name('kegiatan.data_budidaya');
Route::get('/kegiatan/panen', [KegiatanController::class, 'panen'])->name('kegiatan.panen');
Route::get('/kegiatan/panen/{nama_tahapan}', [KegiatanController::class, 'dataPanen'])->name('kegiatan.data_panen');

Route::get('/kegiatan/pascapanen', [KegiatanController::class, 'pascapanen'])->name('kegiatan.pascapanen');
Route::get('/kegiatan/pascapanen/{nama_tahapan}', [KegiatanController::class, 'dataPascaPanen'])->name('kegiatan.data_pascapanen');

Route::get('/admin/kegiatan/budidaya/create', [KegiatanController::class, 'createBudidaya'])->name('kegiatan.budidaya.create');
Route::post('/admin/kegiatan/budidaya/store', [KegiatanController::class, 'storeBudidaya'])->name('kegiatan.budidaya.store');


Route::get('/admin/kegiatan/panen/create', [KegiatanController::class, 'createPanen'])->name('kegiatan.panen.create');
Route::post('/admin/kegiatan/panen/store', [KegiatanController::class, 'storePanen'])->name('kegiatan.panen.store');

Route::get('/admin/kegiatan/pascapanen/create', [KegiatanController::class, 'createPascapanen'])->name('kegiatan.pascapanen.create');
Route::post('/admin/kegiatan/pascapanen/store', [KegiatanController::class, 'storePascapanen'])->name('kegiatan.pascapanen.store');

Route::delete('/admin/kegiatan/budidaya/{id}', [KegiatanController::class, 'destroyBudidaya'])->name('admin.kegiatan.budidaya.destroy');
Route::delete('/admin/kegiatan/panen/{id}', [KegiatanController::class, 'destroyPanen'])->name('admin.kegiatan.panen.destroy');
Route::delete('/admin/kegiatan/pascapanen/{id}', [KegiatanController::class, 'destroyPascapanen'])->name('admin.kegiatan.pascapanen.destroy');

Route::delete('/jenis-tahapan-kegiatan/{id}', [KegiatanController::class, 'destroy'])->name('jenisTahapanKegiatan.destroy');
Route::put('/jenis-tahapan-kegiatan/{id}', [KegiatanController::class, 'update'])->name('jenisTahapanKegiatan.update');

Route::get('/admin/tahapan/create', [KegiatanController::class, 'create'])->name('tahapan.create');
Route::post('/admin/tahapan/store', [KegiatanController::class, 'store'])->name('tahapan.store');


// Penjualan
Route::get('penjualan', [BudidayaController::class, 'penjualan_index'])->name('penjualan.index');

// Pengajuan
Route::get('/pengajuan', [PengajuanController::class, 'index'])->name('pengajuan.index');
Route::post('/pengajuan/accept/{id}', [PengajuanController::class, 'accept'])->name('pengajuan.accept');
Route::post('/pengajuan/reject/{id}', [PengajuanController::class, 'reject'])->name('pengajuan.reject');

// Manajemen User
Route::get('data_user', [PengajuanController::class, 'get_data_user'])->name('getDataUser');
Route::put('/user/{id}/deactivate', [PengajuanController::class, 'deactivate'])->name('user.deactivate');
Route::delete('/user/{id}', [PengajuanController::class, 'delete'])->name('user.destroy');
Route::put('/user/{id}/activate', [PengajuanController::class, 'activate'])->name('user.activate');
Route::get('/user/{id}/edit', [PengajuanController::class, 'edit'])->name('user.edit');

    // Optional Show Routes (jika ingin digunakan kembali)
    // Route::get('/budidaya/{id}', [BudidayaController::class, 'show'])->name('budidaya.show');
    // Route::get('/panen/{id}', [PanenController::class, 'show'])->name('panen.show');
    // Route::get('/pasca/{id}', [PascaPanenController::class, 'show'])->name('pasca.show');
//});
