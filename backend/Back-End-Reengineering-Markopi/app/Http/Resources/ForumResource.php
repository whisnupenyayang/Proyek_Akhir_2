<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ForumResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        return [
            'id_forums' => $this->id_forums,
            'title' => $this->title,
            'deskripsi' => $this->deskripsi,
            'user_id' => $this->user_id,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'images' => $this->images,
            // Mengambil data user yang terhubung
            'user' => [
                'id_users' => $this->user->id_users,
                'nama_lengkap' => $this->user->nama_lengkap,
                'username' => $this->user->username,
                // Anda bisa menambahkan field lainnya dari relasi user jika diperlukan
            ],
        ];
    }
}
