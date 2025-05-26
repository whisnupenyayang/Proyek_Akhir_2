<?php

namespace App\Models;

use Illuminate\Support\Str;
use Illuminate\Support\Carbon;
use Laravel\Sanctum\HasApiTokens;
use Laravel\Sanctum\NewAccessToken;
use Illuminate\Notifications\Notifiable;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $table = 'users';
    protected $primaryKey = 'id_users';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'nama_lengkap',
        'username',
        'email',
        'password',

        // 'confirm_password',
        'tanggal_lahir',
        'jenis_kelamin',
        'provinsi',
        'kabupaten',
        'no_telp',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'confirm_password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    /**
     * Get the key for cache "minutes" value.
     *
     * @return string
      */
    // public function getKeyName()
    // {
    //     return 'username';
    // }

    public function generateToken()
    {
        return $this->createToken('token', ['*'])->plainTextToken;
    }
    public function getAuthIdentifierName()
{
    return 'id_users';
}

    // public function createCustomToken($username)
    // {
    //     $token = $this->tokens()->create([
    //         'tokenable_id' => $this->id,
    //         'tokenable_type' => get_class($this),
    //         'username' => $username,
    //         'token' => hash('sha256', $plainTextToken = Str::random(40)),
    //         'abilities' => ['*'],
    //         'created_at' => now(),
    //         'updated_at' => now(),
    //     ]);

    //     return new NewAccessToken($token, $plainTextToken);
    // }
}
