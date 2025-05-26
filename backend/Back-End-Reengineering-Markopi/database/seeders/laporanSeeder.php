<?php

namespace Database\Seeders;

use Carbon\Carbon;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class laporanSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('kebuns')->insert([
            [
                'user_id' => 1,
                'nama_kebun' => 'Kebun Arabika',
                'lokasi' => 'Kecamatan Cigugur',
                'luas_kebun' => 2.5,
            ],
            [
                'user_id' => 1,
                'nama_kebun' => 'Kebun Robusta',
                'lokasi' => 'Kecamatan Lebakwangi',
                'luas_kebun' => 1.8,
            ]
        ]);

        DB::table('pendapatan_kebuns')->insert([
            [
                'kebun_id' => 1,
                'jenis_kopi' => 'Arabika',
                'tanggal_panen' => Carbon::parse('2025-04-10'),
                'tempat_penjualan' => 'Pasar Kuningan',
                'tanggal_penjualan' => Carbon::parse('2025-04-12'),
                'harga_per_kg' => 75000,
                'berat_kg' => 100,
                'total_pendapatan' => 7500000,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'kebun_id' => 2,
                'jenis_kopi' => 'Robusta',
                'tanggal_panen' => Carbon::parse('2025-03-15'),
                'tempat_penjualan' => 'Koperasi Petani',
                'tanggal_penjualan' => Carbon::parse('2025-03-18'),
                'harga_per_kg' => 60000,
                'berat_kg' => 80,
                'total_pendapatan' => 4800000,
                'created_at' => now(),
                'updated_at' => now(),
            ]
        ]);

        DB::table('pengeluaran_kebuns')->insert([
            [
                'kebun_id' => 1,
                'deskripsi_biaya' => 'Pembelian pupuk',
                'nominal' => 300000,
                'tanggal' => Carbon::parse('2025-03-05'),
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'kebun_id' => 2,
                'deskripsi_biaya' => 'Upah pekerja panen',
                'nominal' => 500000,
                'tanggal' => Carbon::parse('2025-03-16'),
                'created_at' => now(),
                'updated_at' => now(),
            ]
        ]);
    }
}
