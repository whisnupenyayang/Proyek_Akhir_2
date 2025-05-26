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
        Schema::create('rata_rata_herga_kopis', function (Blueprint $table) {
            $table->id();
            $table->string('jenis_kopi');
            $table->integer('rata_rata_harga');
            $table->integer('bulan');
            $table->String('tahun');
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
        Schema::dropIfExists('rata_rata_herga_kopis');
    }
};
