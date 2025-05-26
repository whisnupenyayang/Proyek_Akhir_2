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
        Schema::create('forum_komentars', function (Blueprint $table) {
            $table->increments('id_forum_komentars');
            $table->unsignedInteger('user_id');
            $table->unsignedInteger('forum_id');
            $table->string('komentar');
            $table->timestamps();

            $table->foreign('user_id')->references('id_users')->on('users')->onDelete('cascade');
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
        Schema::dropIfExists('forum_komentars');
    }
};
