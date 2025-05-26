<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PengeluaranKebun extends Model
{
    use HasFactory;

    protected $guarded = [''];

    public function kebun()
    {
        return $this->belongsTo(Kebun::class);
    }
}
