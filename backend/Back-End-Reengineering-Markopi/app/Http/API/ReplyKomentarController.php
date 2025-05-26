<?php

namespace App\Http\API;

use Illuminate\Http\Request;
use App\Models\KomentarForum;
use App\Models\ReplyKomentar;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;

class ReplyKomentarController extends Controller
{
    public function reply(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id_users',
            'komentar_id' => 'required|exists:forum_komentars,id_forum_komentars',
            'komentar' => 'required|string',
        ]);

        $parentComment = KomentarForum::find($request->komentar_id);
        if (!$parentComment) {
            return response()->json(['message' => 'Komentar tidak ditemukan', 'status' => 'error'], 404);
        }

        $replyComment = ReplyKomentar::create([
            'user_id' => $request->user_id,
            'komentar_id' => $request->komentar_id,
            'komentar' => $request->komentar,
        ]);

        return response()->json([
            'message' => 'Reply berhasil ditambahkan',
            'status' => 'success',
            'data' => $replyComment,
        ], 201);
    }

    public function getRepliesByUserId($komentarId, $userId)
    {
        $replies = ReplyKomentar::where('komentar_id', $komentarId)
            ->where('user_id', $userId)->get();

        Log::info('Replies:', ['replies' => $replies]);

        if ($replies->isEmpty()) {
            return response()->json([
                'message' => 'Komentar Reply tidak ditemukan',
                'status' => 'error'
            ], 404);
        }

        return response()->json([
            'message' => 'Berhasil mengambil data reply komentar',
            'status' => 'success',
            'data' => $replies,
        ], 200);
    }

    public function get_replies($komentar_id)
    {
        try {
            $replies = ReplyKomentar::where('komentar_id', $komentar_id)->get();

            if (!$replies) {
                return response()->json(['message' => 'Balasan Forum not found', 'status' => 'error'], 404);
            }

            return response()->json(['data' => $replies, 'status' => 'success'], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to fetch balasan', 'status' => 'error', 'error' => $e->getMessage()], 500);
        }
    }

    public function getAllReplies()
    {
        try {
            $replies = DB::table('reply_comments')
                ->select('id_reply_comments', 'user_id', 'komentar_id', 'komentar')
                ->get();

            Log::info(json_encode($replies));
            if (!$replies) {
                return response()->json(['message' => 'Replies not found', 'status' => 'error'], 404);
            }

            return response()->json([
                'success' => true,
                'message' => 'Get data sukses',
                'data' => $replies
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to get Replies', 'status' => 'error', 'error' => $e->getMessage()], 500);
        }
    }

    public function updateReplyByUserId(Request $request, $komentarId, $userId, $id)
    {
        $reply = ReplyKomentar::where('komentar_id', $komentarId)
            ->where('user_id', $userId)
            ->where('id_reply_comments', $id)
            ->first();

        if (!$reply) {
            return response()->json([
                'message' => 'Reply tidak ditemukan',
                'status' => 'error'
            ], 404);
        }

        $reply->update($request->all());

        Log::info('Updated Reply:', ['reply' => $reply]);

        return response()->json([
            'message' => 'Reply berhasil diperbarui',
            'status' => 'success',
            'data' => $reply,
        ], 200);
    }

    public function deleteReplyByUserId($komentarId, $userId, $id)
    {
        $reply = ReplyKomentar::where('komentar_id', $komentarId)
            ->where('user_id', $userId)
            ->where('id_reply_comments', $id)
            ->first();

        if (!$reply) {
            return response()->json([
                'message' => 'Reply tidak ditemukan',
                'status' => 'error'
            ], 404);
        }

        $reply->delete();

        Log::info('Deleted Reply:', ['reply' => $reply]);

        return response()->json([
            'message' => 'Reply berhasil dihapus',
            'status' => 'success',
        ], 200);
    }
}
