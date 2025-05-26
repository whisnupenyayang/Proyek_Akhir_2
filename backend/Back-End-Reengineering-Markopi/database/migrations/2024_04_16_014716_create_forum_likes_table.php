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
        Schema::create('forum_likes', function (Blueprint $table) {
            $table->increments('id_forum_likes');
            $table->unsignedInteger('forum_id');
            $table->unsignedInteger('user_id');
            $table->enum('like',[0, 1, 2]);
            $table->timestamps();

            $table->foreign('forum_id')->references('id_forums')->on('forums')->onDelete('cascade');
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
        Schema::dropIfExists('forum_likes');
    }
};
