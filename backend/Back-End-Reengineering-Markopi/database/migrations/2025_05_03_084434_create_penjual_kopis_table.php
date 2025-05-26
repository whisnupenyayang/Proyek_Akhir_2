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
        Schema::create('penjual_kopis', function (Blueprint $table) {
            $table->id();
            $table->string('nama_toko');
            $table->string('jenis_kopi');
            $table->integer('harga');
            $table->string('nama_gambar');
            $table->string('url_gambar');
            $table->string('nomor_telepon');
            $table->string('alamat');
            $table->unsignedInteger('user_id');
            $table->foreign('user_id')->references('id_users')->on('users');
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
        Schema::dropIfExists('penjual_kopis');
    }
};
