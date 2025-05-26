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
        Schema::create('image_forums', function (Blueprint $table) {
            $table->increments('id_image_forums');
            $table->unsignedInteger('forum_id');
            $table->string('gambar');
            $table->timestamps();

            $table->foreign('forum_id')->references('id_forums')->on('forums')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('image_forums');
    }
};
