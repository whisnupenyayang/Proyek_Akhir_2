<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class DataUserController extends Controller
{
    public function getDataUser(){
        $user = User::all();
        return view('admin.users.index');

    }

}
