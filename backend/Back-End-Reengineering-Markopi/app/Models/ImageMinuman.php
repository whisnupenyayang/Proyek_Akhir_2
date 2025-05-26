<?php

namespace App\Models;

use App\Models\Minuman;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class ImageMinuman extends Model
{
    use HasFactory;
    protected $table = 'image_minumans';
    protected $primaryKey = 'id_image_minumans';

    protected $fillable = [
        'gambar',
        'minuman_id',
    ];

    public function minuman()
    {
        return $this->belongsTo(Minuman::class, 'minuman_id');
    }
}
