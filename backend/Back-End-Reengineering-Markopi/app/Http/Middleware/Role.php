<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class Role
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @param  string  $role
     * @return \Illuminate\Http\Response|\Illuminate\Http\RedirectResponse
     */
    public function handle(Request $request, Closure $next, $role)
    {
        // if (auth()->check()) {
        //     Log::info('Checking user role in middleware', [
        //         'user_id' => $request->user()->id,
        //         'user_role' => $request->user()->role,
        //         'required_role' => $role
        //     ]);

        //     if ($request->user()->role == $role) {
        //         Log::info('User role matched', ['user_role' => $request->user()->role]);
        //         return $next($request);
        //     }
        // }

        // Log::warning('User role mismatch or not authenticated', [
        //     'user_id' => auth()->check() ? $request->user()->id : 'guest',
        //     'user_role' => auth()->check() ? $request->user()->role : 'guest',
        //     'required_role' => $role
        // ]);

        $user_id = session('user_id');
        $user_role = session('user_role');
        
        if ($user_id && $user_role === $role) {
            return $next($request);
        } else {
            Log::warning('User role mismatch or not authenticated', ['user_id' => $user_id, 'user_role' => $user_role, 'required_role' => $role]);
            return redirect()->route('login');
        }

        return abort(403, 'Anda tidak memiliki hak mengakses laman tersebut!');
    }
}
