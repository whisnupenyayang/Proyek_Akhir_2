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
        Schema::create('pengajuans', function (Blueprint $table) {
            $table->increments('id_pengajuans');
            $table->unsignedInteger('user_id')->unique();
            $table->string('foto_ktp')->nullable();
            $table->string('foto_selfie')->nullable();
            $table->text('deskripsi_pengalaman');
            $table->string('foto_sertifikat')->nullable();
            $table->enum('tipe_pengajuan', ['fasilitator', 'pengepul']);
            $table->enum('status', [0, 1, 2])->default(0);
            $table->timestamps();

            $table->foreign('user_id')->references('id_users')->on('users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('pengajuans');
    }
};
