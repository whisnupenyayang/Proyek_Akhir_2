<?php

namespace App\Http\Controllers;

use App\Models\Resep;
use Illuminate\Http\Request;

class ResepController extends Controller
{
    // Method for displaying all recipes
    public function index()
    {
        $title = 'Daftar Resep';  // Set the title
        $resep = Resep::all();
        return view('admin.resep.resep', compact('resep', 'title'));  // Pass $title and $resep to the view
    }

    // Method to show form for creating new recipe
    public function create()
    {
        $title = 'Tambah Resep';  // Set the title
        return view('admin.resep.tambah_resep', compact('title'));  // Pass $title to the view
    }

    // Method for storing a new recipe
    public function store(Request $request)
    {
        // Validate the incoming request data
        $validatedData = $request->validate([
            'nama_resep' => 'required|string|max:100',
            'deskripsi_resep' => 'required|string',
            'gambar_resep' => 'nullable|image|max:255',
        ]);

        // Create a new instance of the Resep model
        $resep = new Resep;
        $resep->nama_resep = $request->nama_resep;
        $resep->deskripsi_resep = $request->deskripsi_resep;

        // Handle file upload for gambar_resep
        if ($request->hasFile('gambar_resep')) {
            $file = $request->file('gambar_resep');
            $filename = time() . '.' . $file->getClientOriginalExtension();
            $file->move(public_path('images'), $filename);
            $resep->gambar_resep = $filename;
        }

        // Save the recipe data to the database
        $resep->save();

        return redirect()->route('admin.resep')->with('success', 'Resep berhasil ditambahkan');
    }

    // Method to show the details of a recipe
    public function detailResep($id)
    {
        $title = 'Detail Resep';  // Set the title
        $resep = Resep::findOrFail($id);
        return view('admin.resep.detail_resep', compact('resep', 'title'));  // Pass $title and $resep to the view
    }

    // Method to delete a recipe
    public function destroy($id)
    {
        $resep = Resep::findOrFail($id);
        $resep->delete();

        return redirect()->route('admin.resep')->with('success', 'Resep berhasil dihapus');
    }

    // Method to show the edit form
    public function edit($id)
    {
        $title = 'Edit Resep';  // Set the title
        $resep = Resep::findOrFail($id);
        return view('admin.resep.edit_resep', compact('resep', 'title'));  // Pass $title and $resep to the view
    }

    // Method to update a recipe
    public function update(Request $request, $id)
    {
        $resep = Resep::findOrFail($id);

        // Update nama and deskripsi if provided
        if ($request->has('name')) {
            $resep->nama_resep = $request->name;
        }

        if ($request->has('desc')) {
            $resep->deskripsi_resep = $request->desc;
        }

        // Process image if exists
        if ($request->hasFile('image')) {
            $image = $request->file('image');
            $filename = time() . '.' . $image->getClientOriginalExtension();
            $image->move(public_path('images'), $filename);
            $resep->gambar_resep = $filename;
        }

        $resep->save();

        return response()->json([
            'success' => true,
            'imageUrl' => asset('images/' . $resep->gambar_resep)  // Return the URL of the new image
        ]);
    }
}
