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
        Schema::create('jenis_tahapan_kegiatans', function (Blueprint $table) {
            $table->id();
            $table->string('judul');
            $table->text('deskripsi');
            $table->string('nama_file')->nullable();
            $table->string('url_gambar')->nullable();
            $table->unsignedBigInteger('tahapan_kegiatan_id');
            $table->foreign('tahapan_kegiatan_id')->references('id')->on('tahapan_kegiatans');
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
        Schema::dropIfExists('jenis_tahapan_kegiatans');
    }
};
