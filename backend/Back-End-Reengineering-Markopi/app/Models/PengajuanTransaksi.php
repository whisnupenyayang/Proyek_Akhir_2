<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PengajuanTransaksi extends Model
{
    use HasFactory;

    protected $fillable = [
        'keterengan',
        'id_user_pengaju',
        'id_user_penerima',
        'id_pengepul',
        'id_penjual_kopi',

    ];
}
