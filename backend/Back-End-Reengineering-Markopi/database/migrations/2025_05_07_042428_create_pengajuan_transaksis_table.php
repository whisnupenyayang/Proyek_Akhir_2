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
        Schema::create('pengajuan_transaksis', function (Blueprint $table) {
            $table->id();
            $table->string('keterengan');
            $table->unsignedInteger('id_user_pengaju');
            $table->unsignedInteger('id_user_penerima');
            $table->unsignedBigInteger('id_pengepul')->nullable();
            $table->unsignedBigInteger('id_penjual_kopi')->nullable();
            $table->foreign('id_user_pengaju')->references('id_users')->on('users')->onDelete('cascade');
            $table->foreign('id_user_penerima')->references('id_users')->on('users');
            $table->foreign('id_penjual_kopi')->references('id')->on('penjual_kopis');
            $table->foreign('id_pengepul')->references('id')->on('pengepuls');

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
        Schema::dropIfExists('pengajuan_transaksis');
    }
};
