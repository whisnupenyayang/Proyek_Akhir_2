<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PengepulImage extends Model
{
    use HasFactory;

    protected $fillable = ['pengepul_id', 'gambar'];

    public function pengepul()
    {
        return $this->belongsTo(Pengepul::class);
    }
}
