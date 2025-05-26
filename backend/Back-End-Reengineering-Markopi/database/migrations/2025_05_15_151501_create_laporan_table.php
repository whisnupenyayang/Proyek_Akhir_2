<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateLaporanTable extends Migration
{
    public function up()
    {
        Schema::create('laporan', function (Blueprint $table) {
            $table->increments('id');
            $table->string('judul_laporan');
            $table->text('isi_laporan')->nullable();
            $table->unsignedInteger('user_id');
            $table->timestamps();

            // jika ingin relasi ke tabel users
            $table->foreign('user_id')->references('id_users')->on('users')->onDelete('cascade');
        });
    }

    public function down()
    {
        Schema::dropIfExists('laporan');
    }
}
