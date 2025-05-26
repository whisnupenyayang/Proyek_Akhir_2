<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Kebun extends Model
{
    use HasFactory;

    protected $guarded = [''];

     public function pendapatan()
    {
        return $this->hasMany(PendapatanKebun::class);
    }

    public function pengeluaran()
    {
        return $this->hasMany(PengeluaranKebun::class);
    }
}
