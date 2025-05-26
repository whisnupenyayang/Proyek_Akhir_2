<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Laporan extends Model
{
    use HasFactory;

    protected $table = 'laporan';

    // Atribut yang bisa diisi secara massal
    protected $fillable = [
        'judul_laporan',
        'isi_laporan',
        'id_users', // ID pengguna yang terkait dengan laporan
    ];

    public $timestamps = true; // Menggunakan timestamp otomatis (created_at dan updated_at)
}

