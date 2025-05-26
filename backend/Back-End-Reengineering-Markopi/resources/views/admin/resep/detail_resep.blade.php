<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Detail Resep</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css" rel="stylesheet">
        <style>
            .container {
                max-width: 800px;
                margin: 0 auto;
                padding: 20px;
                background-color: white;
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
            }

            h1 {
                text-align: center;
                margin-bottom: 20px;
            }

            .btn-back {
                margin-bottom: 15px;
                font-size: 1.2em;
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
                justify-content: space-between;
                margin-top: 20px;
                justify-content: flex-end
            }

            .btn-trash {
                background-color: #f44336;
                color: white;
                border: none;
                padding: 10px 20px;
                font-size: 1.2em;
                border-radius: 50%;
                cursor: pointer;
            }

            .btn-trash:hover {
                background-color: #d32f2f;
            }

            .btn-trash i {
                font-size: 1.5em;
            }

            .edit-icon {
                color: #007bff;
                cursor: pointer;
            }

            .edit-icon:hover {
                text-decoration: underline;
            }

            .field-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .field-container p {
                margin-bottom: 0;
            }

            .field-container .edit-icon {
                font-size: 1.2em;
            }

            .field-container input,
            .field-container textarea {
                width: 100%;
                padding: 8px;
                border-radius: 4px;
                border: 1px solid #ccc;
            }

            .field-container .edit-icon.save {
                color: #28a745;
            }

            .field-container .edit-icon.save:hover {
                text-decoration: underline;
            }

            .field-container .save-btn {
                margin-left: 10px;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <a href="{{ route('admin.resep') }}" class="btn btn-primary btn-back"><i class="bi bi-arrow-left"></i> Kembali</a>
            <h1>Detail Resep</h1>

            <div class="detail-card">
                <!-- Nama Resep -->
                <div class="field-container">
                    <h3 id="resep-name">{{ $resep->nama_resep }}</h3>
                    <a href="javascript:void(0);" id="edit-name" class="edit-icon"><i class="bi bi-pencil"></i></a>
                    <button id="save-name" class="edit-icon save-btn" style="display: none;">Simpan</button>
                </div>

                <!-- Deskripsi Resep -->
                <div class="field-container">
                    <p id="resep-desc" style="white-space: pre-line;"><strong>Deskripsi:</strong> <br>{{ $resep->deskripsi_resep }}</p>
                    <a href="javascript:void(0);" id="edit-desc" class="edit-icon"><i class="bi bi-pencil"></i></a>
                    <button id="save-desc" class="edit-icon save-btn" style="display: none;">Simpan</button>
                </div><br>

                <!-- Foto Resep -->
                <div class="field-container">
                    <div id="resep-img">
                        @if($resep->gambar_resep)
                            <img id="current-image" src="{{ asset('images/' . $resep->gambar_resep) }}" alt="gambar Resep">
                        @else
                            <p>Tidak ada foto resep.</p>
                        @endif
                    </div>
                    <a href="javascript:void(0);" id="edit-img" class="edit-icon"><i class="bi bi-pencil"></i></a>
                    <input type="file" id="edit-img-input" style="display: none;" />
                    <button id="save-img" class="edit-icon save-btn" style="display: none;">Simpan</button>
                </div>
            </div>

            <!-- Action buttons -->
            <div class="action-buttons">
                <!-- Delete button (trash icon) -->
                <form action="{{ route('resep.destroy', $resep->id) }}" method="POST">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="btn-trash">
                        <i class="bi bi-trash"></i>
                    </button>
                </form>
            </div>
        </div>

        <!-- JavaScript for inline editing -->
        <script>
            // Edit Nama Resep
            document.getElementById("edit-name").addEventListener("click", function() {
                const currentName = document.getElementById("resep-name").innerText;
                const inputField = `<input type="text" id="edit-name-input" value="${currentName}" />`;

                // Replace the h3 element with the input field
                document.getElementById("resep-name").innerHTML = inputField;

                // Show the save button
                document.getElementById("save-name").style.display = "inline-block";
                // Hide the edit icon
                document.getElementById("edit-name").style.display = "none";
            });

            // Save Nama Resep (AJAX)
            document.getElementById("save-name").addEventListener("click", function() {
                const newName = document.getElementById("edit-name-input").value;

                fetch("{{ route('resep.update', $resep->id) }}", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-CSRF-TOKEN": "{{ csrf_token() }}"
                    },
                    body: JSON.stringify({ name: newName })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.getElementById("resep-name").innerText = newName;
                        // Hide the save button and show the edit icon
                        document.getElementById("save-name").style.display = "none";
                        document.getElementById("edit-name").style.display = "inline-block";
                    } else {
                        alert("Gagal memperbarui nama resep.");
                    }
                });
            });

            // Edit Deskripsi Resep
            document.getElementById("edit-desc").addEventListener("click", function() {
                const currentDesc = document.getElementById("resep-desc").innerText.replace('Deskripsi: ', '');
                const inputField = `<textarea id="edit-desc-input">${currentDesc}</textarea>`;

                // Replace the deskripsi element with the textarea
                document.getElementById("resep-desc").innerHTML = inputField;

                // Show the save button
                document.getElementById("save-desc").style.display = "inline-block";
                // Hide the edit icon
                document.getElementById("edit-desc").style.display = "none";
            });

            // Save Deskripsi Resep (AJAX)
            document.getElementById("save-desc").addEventListener("click", function() {
                const newDesc = document.getElementById("edit-desc-input").value;

                fetch("{{ route('resep.update', $resep->id) }}", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-CSRF-TOKEN": "{{ csrf_token() }}"
                    },
                    body: JSON.stringify({ desc: newDesc })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.getElementById("resep-desc").innerText = newDesc;
                        // Hide the save button and show the edit icon
                        document.getElementById("save-desc").style.display = "none";
                        document.getElementById("edit-desc").style.display = "inline-block";
                    } else {
                        alert("Gagal memperbarui deskripsi resep.");
                    }
                });
            });

            // Edit Gambar Resep
            document.getElementById("edit-img").addEventListener("click", function() {
                document.getElementById("edit-img-input").click();
            });

            // Save Gambar Resep (AJAX)
            document.getElementById("edit-img-input").addEventListener("change", function() {
                const formData = new FormData();
                const imageFile = document.getElementById("edit-img-input").files[0];
                formData.append("image", imageFile);

                fetch("{{ route('resep.update', $resep->id) }}", {
                    method: "POST",
                    headers: {
                        "X-CSRF-TOKEN": "{{ csrf_token() }}"
                    },
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Update the displayed image
                        const newImageUrl = data.imageUrl; // Assuming the server sends the new image URL
                        document.getElementById("current-image").src = newImageUrl;

                        // Show the save button and hide the edit icon
                        document.getElementById("save-img").style.display = "inline-block";
                        document.getElementById("edit-img").style.display = "none";
                    } else {
                        alert("Gagal memperbarui gambar resep.");
                    }
                });
            });

            // Save Gambar Resep
            document.getElementById("save-img").addEventListener("click", function() {
                const formData = new FormData();
                const imageFile = document.getElementById("edit-img-input").files[0];
                formData.append("image", imageFile);

                fetch("{{ route('resep.update', $resep->id) }}", {
                    method: "POST",
                    headers: {
                        "X-CSRF-TOKEN": "{{ csrf_token() }}"
                    },
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.getElementById("current-image").src = data.imageUrl; // Update image source
                        document.getElementById("save-img").style.display = "none"; // Hide save button
                        document.getElementById("edit-img").style.display = "inline-block"; // Show edit icon
                    }
                });
            });
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
    </html>
