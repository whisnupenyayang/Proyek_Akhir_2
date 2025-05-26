<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ImageArtikel extends Model
{
    protected $table = 'image_artikels';
    protected $primaryKey = 'id_image_artikels';

    protected $fillable = ['artikel_id', 'gambar'];

    protected $appends = ['url'];

    public function artikel()
    {
        return $this->belongsTo(Artikel::class, 'artikel_id');
    }

    public function getUrlAttribute()
    {
        return asset('images/' . $this->gambar);
    }
}
