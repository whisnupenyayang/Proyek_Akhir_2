<?php

namespace Database\Seeders;

use Carbon\Carbon;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        DB::table('users')->insert([
            'nama_lengkap' => 'ahmad',
            'username' => 'ahmad',
            'email' => 'ahmad@gmail.com',

            'tanggal_lahir' => '2000-01-01',
            'jenis_kelamin' => 'Laki-laki',
            'provinsi' => '-',
            'kabupaten' => '-',
            'no_telp' => '081234567890',
            'password' => Hash::make('ahmad1'),
            'role' => 'petani',
        ]);

        DB::table('users')->insert([
            'nama_lengkap' => 'Admin',
            'username' => 'admin',

            'email' => 'admin@gmail.com',
            'tanggal_lahir' => '2000-01-01',
            'jenis_kelamin' => 'Laki-laki',
            'provinsi' => '-',
            'kabupaten' => '-',
            'no_telp' => '080987654321',
            'password' => Hash::make('admin01'),
            'role' => 'admin',
        ]);

        DB::table('users')->insert([
            'nama_lengkap' => 'alex',
            'username' => 'alex',
            'email' => 'fmax10469@gmail.com',

            'tanggal_lahir' => '2000-11-01',
            'jenis_kelamin' => 'Laki-laki',
            'provinsi' => '-',
            'kabupaten' => '-',
            'no_telp' => '0809876234567',
            'password' => Hash::make('alex1'),
            'role' => 'petani',
        ]);



        $this->call(laporanSeeder::class);
    }
}
