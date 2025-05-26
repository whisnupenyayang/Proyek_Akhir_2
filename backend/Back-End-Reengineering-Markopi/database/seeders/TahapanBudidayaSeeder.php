<?php

namespace Database\Seeders;

use App\Models\Pengepul;
use App\Models\TahapanBudidaya;
use App\Models\TahapanKegiatan;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class TahapanBudidayaSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {

        $nama_tahapan = [
            'Pemilihan Lahan',
            'Pembukaan Lahan',
            'Bahan Tanam Unggul',
            'Pembibitan',
            'Penanaman',
            'Pemupukan',
            'Pemangkasan',
            'Pengendalian Hama',

        ];


        foreach($nama_tahapan as $n ){ $tahapan = TahapanKegiatan::create([
            'nama_tahapan' => $n,
            'jenis_kopi' => 'Arabika',
            'kegiatan' => 'Budidaya'

         ]);}
         foreach($nama_tahapan as $n ){ $tahapan = TahapanKegiatan::create([
            'nama_tahapan' => $n,
            'jenis_kopi' => 'Arabika',
            'kegiatan' => 'Panen'

         ]);}
         foreach($nama_tahapan as $n ){ $tahapan = TahapanKegiatan::create([
            'nama_tahapan' => $n,
            'jenis_kopi' => 'Arabika',
            'kegiatan' => 'Pasca Panen'
         ]);}


    }
}
