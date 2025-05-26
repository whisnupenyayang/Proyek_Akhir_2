<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pengepul extends Model
{
    use HasFactory;

    protected $table = 'pengepuls';

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
