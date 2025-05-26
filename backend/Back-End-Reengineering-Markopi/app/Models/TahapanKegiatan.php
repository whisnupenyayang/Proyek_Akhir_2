<?php

// App\Models\TahapanKegiatan.php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TahapanKegiatan extends Model
{
    use HasFactory;

    protected $fillable = [
     'nama_tahapan',
     'kegiatan',
     'jenis_kopi',
    ];

    // Relasi One to Many ke JenisTahapanKegiatan
    public function jenisTahapanKegiatan()
    {
        return $this->hasMany(JenisTahapanKegiatan::class, 'tahapan_kegiatan_id');
    }
}
