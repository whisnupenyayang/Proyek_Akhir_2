<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ArtikelResourc extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'judul_artikel' => $this->judul_artikel,
            'isi_artikel' => $this->isi_artikel,
            'user_id' => $this->user_id,
            'images' => $this->images->map(function ($image) {
                return [
                    'id' => $image->id,
                    'gambar_url' => url('images/' . $image->gambar), // URL lengkap
                ];
            }),

            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
