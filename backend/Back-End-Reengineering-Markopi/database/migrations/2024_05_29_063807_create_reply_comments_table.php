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
        Schema::create('reply_comments', function (Blueprint $table) {
            $table->increments('id_reply_comments');
            $table->unsignedInteger('user_id');
            $table->unsignedInteger('komentar_id');
            $table->string('komentar');
            $table->timestamps();

            $table->foreign('user_id')->references('id_users')->on('users')->onDelete('cascade');
            $table->foreign('komentar_id')->references('id_forum_komentars')->on('forum_komentars')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('reply_comments');
    }
};
