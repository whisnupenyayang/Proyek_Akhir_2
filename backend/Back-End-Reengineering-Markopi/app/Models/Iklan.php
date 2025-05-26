<?php

namespace App\Models;


use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Image;

class Iklan extends Model
{
    use HasFactory;

    protected $fillable = [
        'judul_iklan',
        'deskripsi_iklan',
        'gambar',
        'link',
    ];

    public function images()
{
    return $this->hasMany(Image::class, 'iklan_id'); // sesuaikan foreign key jika berbeda
}

}
