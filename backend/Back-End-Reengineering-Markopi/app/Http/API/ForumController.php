<?php

namespace App\Http\API;

use App\Http\Controllers\Controller;
use App\Http\Resources\ForumResource;
use App\Models\Forum;
use App\Models\ImageForum;
use App\Models\KomentarForum;
use App\Models\LikeForum;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ForumController extends Controller
{
    // Menampilkan semua forum dengan relasi gambar dan user
    public function index()
    {
        $forums = Forum::with('images', 'user')->get();
        return ForumResource::collection($forums);
    }

    // Menampilkan forum dengan limit tertentu
    public function getLimaForum(Request $request)
    {
        $limit = $request->get('limit', 5);
        $forums = Forum::orderBy('created_at', 'desc')->paginate($limit);
        return ForumResource::collection($forums);
    }

    // Menambahkan forum baru beserta gambar
    public function store(Request $request)
    {
        try {
            // Validasi input
            $request->validate([
                'title' => 'required|string',
                'deskripsi' => 'required|string',
                'gambar' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
            ]);

            $id = $request->user()->id_users;

            // Membuat forum baru
            $forum = Forum::create([
                'title' => $request->title,
                'deskripsi' => $request->deskripsi,
                'user_id' => $id,
            ]);

            // Menyimpan gambar jika ada
            if ($request->hasFile('gambar')) {
                $file = $request->file('gambar');
                if ($file->isValid()) {
                    $gambarPath = $file->store('forumimage', 'public');
                    $forum->images()->create(['gambar' => $gambarPath]);
                } else {
                    return response()->json(['message' => 'File gambar tidak valid', 'status' => 'error'], 400);
                }
            }

            return response()->json([
                'message' => 'Forum berhasil ditambahkan',
                'status' => 'success',
                'data' => $forum
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal menambahkan data',
                'status' => 'error',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    // Menampilkan forum berdasarkan ID
    public function show($id)
    {
        try {
            $forum = Forum::with('images', 'user')->find($id);
            if (!$forum) {
                return response()->json(['message' => 'Forum not found', 'status' => 'error'], 404);
            }

            $data = [
                'id_forums' => $forum->id_forums,
                'title' => $forum->title,
                'deskripsi' => $forum->deskripsi,
                'user_id' => $forum->user_id,
                'user' => [
                    'id_users' => $forum->user->id_users,
                    'nama_lengkap' => $forum->user->nama_lengkap,
                    'username' => $forum->user->username,
                    // Anda bisa menambahkan field lainnya dari relasi user jika diperlukan
                ],
                'created_at' => $forum->created_at,
                'updated_at' => $forum->updated_at,
                'images' => $forum->images,
            ];

            return response()->json(['data' => $data, 'status' => 'success'], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to fetch forum', 'status' => 'error', 'error' => $e->getMessage()], 500);
        }
    }

    // Menampilkan forum berdasarkan user_id
    public function getForumByUserId($user_id)
    {
        try {
            $forums = Forum::with('images')->where('user_id', $user_id)->get();
            if ($forums->isEmpty()) {
                return response()->json(['message' => 'No forums found for the user', 'status' => 'error'], 404);
            }
            return response()->json(['data' => $forums, 'status' => 'success'], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to fetch forum', 'status' => 'error', 'error' => $e->getMessage()], 500);
        }
    }

    // Mengupdate forum berdasarkan ID
    public function update(Request $request, $id)
    {
        try {
            $request->validate([
                'title' => 'required|string',
                'deskripsi' => 'required|string',
                'gambar' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            ]);

            $forum = Forum::find($id);
            if (!$forum) {
                return response()->json(['message' => 'Forum not found', 'status' => 'error'], 404);
            }

            // Menyimpan gambar jika ada
            if ($request->hasFile('gambar')) {
                $uploadedFile = $request->file('gambar');
                if ($uploadedFile->isValid()) {
                    $gambarPath = $uploadedFile->store('forumimage', 'public');

                    // Menghapus gambar lama jika ada
                    if ($forum->images()->exists()) {
                        $forum->images()->first()->delete();
                    }

                    $forum->images()->create(['gambar' => $gambarPath]);
                } else {
                    return response()->json(['message' => 'Gagal mengunggah gambar', 'status' => 'error'], 400);
                }
            }

            $forum->update([
                'title' => $request->title,
                'deskripsi' => $request->deskripsi,
            ]);

            return response()->json(['message' => 'Forum berhasil diperbarui', 'status' => 'success'], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to update forum', 'status' => 'error', 'error' => $e->getMessage()], 500);
        }
    }

    // Menghapus forum berdasarkan ID
    public function destroy($id)
    {
        try {
            $forum = Forum::find($id);
            if (!$forum) {
                return response()->json(['message' => 'Forum not found', 'status' => 'error'], 404);
            }

            // Menghapus gambar yang terkait dengan forum
            $forum->images->each(function ($image) {
                Storage::disk('public')->delete($image->gambar);
            });

            // Menghapus gambar dan forum
            $forum->images()->delete();
            $forum->delete();

            return response()->json(['message' => 'Forum berhasil dihapus', 'status' => 'success'], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to delete forum', 'status' => 'error', 'error' => $e->getMessage()], 500);
        }
    }

    // Menambahkan komentar ke forum
    public function storeComment(Request $request, $forum_id)
    {
        $request->validate(['komentar' => 'required']);

        $user = $request->user();
        $userid = $user->id_users;

        $forum = Forum::find($forum_id);
        if (!$forum) {
            return response()->json(['message' => 'Forum tidak ditemukan', 'status' => 'error'], 404);
        }

        $komentar = KomentarForum::create([
            'komentar' => $request->komentar,
            'forum_id' => $forum_id,
            'user_id' => $userid,
        ]);

        return $komentar
            ? response()->json('Berhasil menambahkan komentar')
            : response()->json('Gagal menambahkan komentar');
    }

    // Mengupdate komentar forum
    public function updateComment(Request $request, $id)
    {
        try {
            $request->validate(['komentar' => 'required|string']);
            $forumKomen = KomentarForum::find($id);

            if (!$forumKomen) {
                return response()->json(['message' => 'Komentar Forum tidak ditemukan', 'status' => 'error'], 404);
            }

            $forumKomen->update(['komentar' => $request->komentar]);

            return response()->json(['message' => 'Komentar Forum berhasil diperbarui', 'status' => 'success'], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Gagal memperbaharui komentar forum', 'status' => 'error', 'error' => $e->getMessage()], 500);
        }
    }

    // Menghapus komentar forum
    public function deleteComment($id)
    {
        try {
            $forumKomen = KomentarForum::find($id);

            if (!$forumKomen) {
                return response()->json(['message' => 'Komentar Forum tidak ditemukan', 'status' => 'error'], 404);
            }

            $forumKomen->delete();
            return response()->json(['message' => 'Komentar Forum berhasil dihapus', 'status' => 'success'], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Gagal menghapus komentar forum', 'status' => 'error', 'error' => $e->getMessage()], 500);
        }
    }

    // Menampilkan komentar forum berdasarkan forum_id
    public function getCommentForum($forum_id)
    {
        try {
            $forumKomentar = KomentarForum::where('forum_id', $forum_id)->with('user')->get();

            if ($forumKomentar->isEmpty()) {
                return response()->json([
                    'message' => 'Komentar Forum tidak ditemukan',
                    'status' => 'error'
                ], 404);
            }

            $data = $forumKomentar->map(function ($komentar) {
                return [
                    'id_forum_komentars' => $komentar->id_forum_komentars,
                    'user_id' => $komentar->user_id,
                    'forum_id' => $komentar->forum_id,
                    'komentar' => $komentar->komentar,
                    'created_at' => $komentar->created_at,
                    'updated_at' => $komentar->updated_at,
                    'user' => $komentar->user ? [
                        'id_users' => $komentar->user->id_users,
                        'nama_lengkap' => $komentar->user->nama_lengkap,
                        'username' => $komentar->user->username,
                    ] : null,
                ];
            });

            return response()->json([
                'data' => $data,
                'status' => 'success'
            ], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Gagal mengambil komentar forum', 'status' => 'error', 'error' => $e->getMessage()], 500);
        }
    }

    // Menambahkan like pada forum
    public function likeForum(Request $request, $forum_id)
    {
        try {
            $userId = $request->user()->id_users;

            $existingLike = LikeForum::where('forum_id', $forum_id)
                ->where('user_id', $userId)
                ->first();

            if ($existingLike && $existingLike->like == '1') {
                $existingLike->update([
                    'like' => '0',
                ]);

                return response()->json([
                    'status' => 'success',
                    'message' => 'Mengganti ke nilai like default',
                    'data' => $existingLike,
                ]);
            }

            if ($existingLike) {
                $existingLike->update([
                    'like' => '1',
                ]);

                return response()->json([
                    'status' => 'success',
                    'message' => 'Status like forum diperbarui.',
                    'data' => $existingLike,
                ]);
            } else {
                $forumLike = LikeForum::create([
                    'forum_id' => $forum_id,
                    'user_id' => $userId,
                    'like' => '1',
                ]);

                return response()->json([
                    'status' => 'success',
                    'message' => 'Forum berhasil di like.',
                    'data' => $forumLike,
                ]);
            }
        } catch (\Throwable $th) {
            return response()->json([
                'message' => 'Terjadi kesalahan',
                'status' => 'error',
                'error' => $th->getMessage()
            ], 500);
        }
    }


    // Menambahkan dislike pada forum
    public function dislikeForum(Request $request, $forum_id)
    {
        try {
            $userId = $request->user()->id_users;

            $existingLike = LikeForum::where('forum_id', $forum_id)
                ->where('user_id', $userId)
                ->first();

            if ($existingLike && $existingLike->like == '2') {
                $existingLike->update([
                    'like' => '0',
                ]);

                return response()->json([
                    'status' => 'success',
                    'message' => 'Mengganti ke nilai like default',
                    'data' => $existingLike,
                ]);
            }

            if ($existingLike) {
                $existingLike->update([
                    'like' => '2',
                ]);

                return response()->json([
                    'status' => 'success',
                    'message' => 'Status like forum diperbarui.',
                    'data' => $existingLike,
                ]);
            } else {
                $forumLike = LikeForum::create([
                    'forum_id' => $forum_id,
                    'user_id' => $userId,
                    'like' => '2',
                ]);

                return response()->json([
                    'status' => 'success',
                    'message' => 'Forum berhasil di like.',
                    'data' => $forumLike,
                ]);
            }
        } catch (\Throwable $th) {
            return response()->json([
                'message' => 'Terjadi kesalahan',
                'status' => 'error',
                'error' => $th->getMessage()
            ], 500);
        }
    }

    // get all likes
    public function countLikes(Request $request, $forum_id)
    {
        try {
            $forum = Forum::withCount([
                'likes as like_count' => function ($query) {
                    $query->where('like', '1');
                },
                'likes as dislike_count' => function ($query) {
                    $query->where('like', '2');
                }
            ])->find($forum_id);

            if (!$forum) {
                return response()->json([
                    'status' => 'failed',
                    'message' => 'Forum tidak ditemukan',
                    'data' => null,
                ], 404);
            }

            return response()->json([
                'status' => 'success',
                'message' => 'Berhasil mengambil jumlah like dan dislike',
                'data' => [
                    'forum_id' => $forum->id_forums,
                    'like_count' => $forum->like_count,
                    'dislike_count' => $forum->dislike_count,
                ],
            ]);
        } catch (\Throwable $th) {
            return response()->json([
                'status' => 'error',
                'message' => 'Terjadi kesalahan',
                'error' => $th->getMessage(),
            ], 500);
        }
    }

    public function isLiked(Request $request, $forum_id)
    {
        $user_id = $request->user()->id_users;

        $like = LikeForum::where('forum_id', $forum_id)
            ->where('user_id', $user_id)
            ->first();

        return response()->json([
            'status' => 'success',
            'like_status' => $like ? (int) $like->like : 0, // 0: belum vote, 1: like, 2: dislike
        ]);
    }
}
