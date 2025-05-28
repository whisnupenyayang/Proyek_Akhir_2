@extends('admin.layouts.admin')

@section('title', 'Detail Resep')

@section('content')
<div class="container">
    <div class="detail-card">
        <!-- Nama Resep -->
        <div class="field-container border-bottom pb-3 mb-3">
            <div class="d-flex align-items-center w-100">
                <h3 id="resep-name" class="mb-0 me-2 flex-grow-1">{{ $resep->nama_resep }}</h3>
                <a href="javascript:void(0);" id="edit-name" class="edit-icon text-primary ms-2"><i class="bi bi-pencil"></i></a>
                <button id="save-name" class="save-btn btn btn-sm btn-success ms-2" style="display: none;">Simpan</button>
            </div>
        </div>

        <!-- Deskripsi Resep -->
        <div class="field-container border-bottom pb-3 mb-3">
            <div class="d-flex align-items-start w-100">
                <p id="resep-desc" style="white-space: pre-line;" class="me-2 flex-grow-1">
                    <strong>Deskripsi:</strong><br>{{ $resep->deskripsi_resep }}
                </p>
                <div class="mt-1 d-flex flex-column align-items-start">
                    <a href="javascript:void(0);" id="edit-desc" class="edit-icon text-primary"><i class="bi bi-pencil"></i></a>
                    <button id="save-desc" class="save-btn btn btn-sm btn-success mt-2" style="display: none;">Simpan</button>
                </div>
            </div>
        </div>

        <!-- Foto Resep -->
        <div class="field-container border-bottom pb-3 mb-3">
            <div id="resep-img" class="mb-2">
                @if($resep->gambar_resep)
                    <img id="current-image" src="{{ asset('images/' . $resep->gambar_resep) }}" alt="gambar Resep" class="img-fluid rounded">
                @else
                    <p class="text-muted">Tidak ada foto resep.</p>
                @endif
            </div>
            <div class="d-flex align-items-center">
                <a href="javascript:void(0);" id="edit-img" class="edit-icon text-primary me-2"><i class="bi bi-pencil"></i></a>
                <input type="file" id="edit-img-input" accept="image/*" style="display: none;" />
                <button id="save-img" class="save-btn btn btn-sm btn-success" style="display: none;">Simpan</button>
            </div>
        </div>
    </div>

    <!-- Tombol Hapus -->
    <div class="action-buttons mt-4">
        <form action="{{ route('resep.destroy', $resep->id) }}" method="POST">
            @csrf
            @method('DELETE')
            <button type="submit" class="btn btn-danger">Hapus</button>
        </form>
    </div>
</div>

<!-- Styles dan Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom Styles -->
<style>
    .container {
        max-width: 800px;
        margin: 0 auto;
        padding: 20px;
        background-color: white;
        box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        border-radius: 8px;
    }
    .detail-card {
        background-color: #f9f9f9;
        padding: 15px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        margin-bottom: 20px;
    }
    .detail-card img {
        width: 100%;
        height: auto;
        border-radius: 8px;
    }
    .action-buttons {
        display: flex;
        justify-content: flex-end;
    }
    .edit-icon {
        font-size: 1.2em;
        cursor: pointer;
    }
    .edit-icon:hover {
        color: #0056b3;
    }
    .save-btn {
        display: inline-block;
    }
    /* Border bottom for each field */
    .field-container {
        border-bottom: 1px solid #ccc;
        padding-bottom: 10px;
        margin-bottom: 15px;
    }
</style>

<!-- JavaScript -->
<script>
    // Edit Nama
    document.getElementById("edit-name").addEventListener("click", function () {
        const currentName = document.getElementById("resep-name").innerText;
        document.getElementById("resep-name").innerHTML = `<input type="text" id="edit-name-input" class="form-control" value="${currentName}" />`;
        document.getElementById("save-name").style.display = "inline-block";
        this.style.display = "none";
    });

    document.getElementById("save-name").addEventListener("click", function () {
        const newName = document.getElementById("edit-name-input").value;
        fetch("{{ route('resep.update', $resep->id) }}", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": "{{ csrf_token() }}"
            },
            body: JSON.stringify({ name: newName })
        }).then(res => res.json()).then(data => {
            if (data.success) {
                document.getElementById("resep-name").innerText = newName;
                this.style.display = "none";
                document.getElementById("edit-name").style.display = "inline-block";
            } else {
                alert("Gagal memperbarui nama resep.");
            }
        });
    });

    // Edit Deskripsi
    document.getElementById("edit-desc").addEventListener("click", function () {
        const currentDesc = document.getElementById("resep-desc").innerText.replace('Deskripsi:\n', '');
        document.getElementById("resep-desc").innerHTML = `<textarea id="edit-desc-input" class="form-control">${currentDesc}</textarea>`;
        document.getElementById("save-desc").style.display = "inline-block";
        this.style.display = "none";
    });

    document.getElementById("save-desc").addEventListener("click", function () {
        const newDesc = document.getElementById("edit-desc-input").value;
        fetch("{{ route('resep.update', $resep->id) }}", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": "{{ csrf_token() }}"
            },
            body: JSON.stringify({ desc: newDesc })
        }).then(res => res.json()).then(data => {
            if (data.success) {
                document.getElementById("resep-desc").innerHTML = `<strong>Deskripsi:</strong><br>${newDesc}`;
                this.style.display = "none";
                document.getElementById("edit-desc").style.display = "inline-block";
            } else {
                alert("Gagal memperbarui deskripsi resep.");
            }
        });
    });

    // Edit Gambar
    document.getElementById("edit-img").addEventListener("click", function () {
        document.getElementById("edit-img-input").click();
    });

    document.getElementById("edit-img-input").addEventListener("change", function () {
        const formData = new FormData();
        formData.append("image", this.files[0]);
        fetch("{{ route('resep.update', $resep->id) }}", {
            method: "POST",
            headers: {
                "X-CSRF-TOKEN": "{{ csrf_token() }}"
            },
            body: formData
        }).then(res => res.json()).then(data => {
            if (data.success) {
                document.getElementById("current-image").src = data.imageUrl;
                document.getElementById("save-img").style.display = "none";
                document.getElementById("edit-img").style.display = "inline-block";
            } else {
                alert("Gagal memperbarui gambar resep.");
            }
        });
    });
</script>
@endsection
