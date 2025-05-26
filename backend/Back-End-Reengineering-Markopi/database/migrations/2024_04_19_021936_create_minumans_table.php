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
        Schema::create('minumans', function (Blueprint $table) {
            $table->increments('id_minumans');
            $table->string('nama_minuman');
            $table->text('bahan_minuman');
            $table->text('langkah_minuman');
            $table->text('credit_gambar');
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
        Schema::dropIfExists('minumans');
    }
};
