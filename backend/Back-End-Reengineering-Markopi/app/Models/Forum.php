<?php

namespace App\Models;

use Illuminate\Support\Facades\DB;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Forum extends Model
{
    use HasFactory;
    protected $table = 'forums';
    protected $primaryKey = 'id_forums';

    protected $fillable = [
        'title',
        'deskripsi',
        'user_id',
    ];

    // Relasi dengan ImageForum
    public function images()
    {
        return $this->hasMany(ImageForum::class, 'forum_id');
    }

    // Relasi dengan KomentarForum
    public function komentar()
    {
        return $this->hasMany(KomentarForum::class);
    }

    // Relasi dengan User
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'id_users');
    }

    public function likes()
    {
        return $this->hasMany(LikeForum::class, 'forum_id');
    }
}
