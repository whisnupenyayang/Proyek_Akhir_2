<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LikeForum extends Model
{
    use HasFactory;
    protected $table = 'forum_likes';
    protected $primaryKey = 'id_forum_likes';

    protected $fillable = [
        'like',
        'forum_id',
        'user_id',
    ];

    public function forum() {
        return $this->belongsTo(Forum::class, 'forum_id', 'id_forums');
    }

    public function user() {
        return $this->belongsTo(User::class, 'user_id', 'id_users');
    }
}
