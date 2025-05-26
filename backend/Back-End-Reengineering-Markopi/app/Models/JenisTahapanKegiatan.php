<?php
// App\Models\JenisTahapanKegiatan.php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JenisTahapanKegiatan extends Model
{
    use HasFactory;

    protected $fillable = [
        'judul',
        'deskripsi',
        'nama_file',
        'url_gambar',
        'tahapan_kegiatan_id'
    ];

    // Relasi Belongs To ke TahapanKegiatan
    public function tahapanKegiatan()
    {
        return $this->belongsTo(TahapanKegiatan::class, 'tahapan_kegiatan_id');
    }
}
