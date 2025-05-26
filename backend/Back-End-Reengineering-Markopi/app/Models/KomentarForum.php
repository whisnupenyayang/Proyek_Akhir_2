<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class KomentarForum extends Model
{
    use HasFactory;
    protected $table = 'forum_komentars';
    protected $primaryKey = 'id_forum_komentars';

    protected $fillable = [
        'komentar',
        'forum_id',
        'user_id',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'id_users');
    }
}
