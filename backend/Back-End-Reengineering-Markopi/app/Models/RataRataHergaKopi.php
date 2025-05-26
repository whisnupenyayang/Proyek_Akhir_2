<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RataRataHergaKopi extends Model
{
    use HasFactory;

    protected $fillable = [
        'jenis_kopi',
        'rata_rata_harga',
        'bulan',
        'tahun'
    ];
}
