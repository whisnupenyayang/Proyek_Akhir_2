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
        Schema::create('image_minumans', function (Blueprint $table) {
            $table->increments('id_image_minumans');
            $table->unsignedInteger('minuman_id');
            $table->string('gambar');
            $table->timestamps();

            $table->foreign('minuman_id')->references('id_minumans')->on('minumans')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('image_minumans');
    }
};
