<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('pendapatan_kebuns', function (Blueprint $table) {
            $table->id();
            $table->integer('kebun_id');
            $table->string('jenis_kopi');
            $table->date('tanggal_panen');
            $table->string('tempat_penjualan');
            $table->date('tanggal_penjualan');
            $table->integer('harga_per_kg');
            $table->integer('berat_kg');
            $table->integer('total_pendapatan');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('pendapatan_kebuns');
    }
};
