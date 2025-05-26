<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PenjualKopi extends Model
{
    use HasFactory;

    protected $fillable = [
        'nama_toko',
        'jenis_kopi',
        'harga',
        'nomor_telepon',
        'alamat',
        'url_gambar',
        'nama_gambar',
        'user_id'
    ];
}
