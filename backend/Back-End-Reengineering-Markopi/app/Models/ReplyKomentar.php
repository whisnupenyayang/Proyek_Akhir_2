<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReplyKomentar extends Model
{
    use HasFactory;
    protected $table = 'reply_comments';
    protected $primaryKey = 'id_reply_comments';

    protected $fillable = [
        'komentar',
        'user_id',
        'komentar_id',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // Relasi ke Forum
    public function forum()
    {
        return $this->belongsTo(Forum::class);
    }

    // Relasi ke Comment (komentar yang direply)
    public function comment()
    {
        return $this->belongsTo(KomentarForum::class);
    }
}
