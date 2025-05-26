<?php

namespace App\Models;

use App\Models\ImageMinuman;
use Illuminate\Support\Facades\DB;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Minuman extends Model
{
    use HasFactory;
    protected $table = 'minumans';
    protected $primaryKey = 'id_minumans';

    protected $fillable = [
        'nama_minuman',
        'bahan_minuman',
        'langkah_minuman',
        'credit_gambar'
    ];

    public function images()
    {
        return $this->hasMany(ImageMinuman::class, 'minuman_id')->select([
            'id_image_minumans', 
            'minuman_id', 
            'gambar',
            DB::raw("CONCAT('" . asset('storage/') . "','/', gambar) as url")]);
    }
}
