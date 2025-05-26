<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ImageForum extends Model
{
    use HasFactory;
    protected $table = 'image_forums';
    protected $primaryKey = 'id_image_forums';

    protected $fillable = [
        'gambar',
        'forum_id',
    ];

    public function forum()
    {
        return $this->belongsTo(Forum::class, 'forum_id');
    }
}
