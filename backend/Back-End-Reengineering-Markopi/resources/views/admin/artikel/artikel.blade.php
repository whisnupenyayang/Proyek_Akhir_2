@extends('admin.layouts.admin')

@section('content')
    <style>
        .card-artikel {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            width: 100%;
            background: white;
        }

        .card-artikel img {
            width: 100%;
            height: auto;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 10px;
        }

        .card-artikel-content {
            padding: 0;
            text-align: center;
        }

        .card-artikel-content h3 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 4px;
            color: #333;
        }

        .card-artikel-content p {
            font-size: 14px;
            color: #666;
            margin: 0 0 8px 0;
            line-height: 1.4;
        }

        .read-more-link {
            font-size: 14px;
            color: #007bff;
            text-decoration: none;
            user-select: none;
        }

        .read-more-link:hover {
            text-decoration: underline;
        }

        /* Desktop & tablet */
        @media (min-width: 768px) {
            .card-artikel {
                flex-direction: row;
                align-items: center;
                gap: 20px;
            }

            .card-artikel img {
                width: 200px;
                height: 150px;
                margin-bottom: 0;
            }

            .card-artikel-content {
                text-align: left;
                flex: 1;
            }

            .card-artikel-content h3 {
                font-size: 20px;
            }

            .read-more-link {
                font-size: 15px;
            }
        }

        /* Mobile */
        @media (max-width: 767px) {
            .card-artikel {
                padding: 10px;
            }

            .card-artikel img {
                width: 100px;
                height: 100px;
                margin-bottom: 0;
                border-radius: 8px;
                object-fit: cover;
                flex-shrink: 0;
            }

            .card-artikel {
                flex-direction: row;
                align-items: center;
            }

            .card-artikel-content {
                padding-left: 15px;
                text-align: left;
                flex: 1;
            }

            .card-artikel-content h3 {
                font-size: 16px;
                margin-bottom: 6px;
                color: #333;
            }

            .read-more-link {
                font-size: 13px;
            }
        }

        .container-artikel {
            max-width: 900px;
            margin: 0 auto;
            padding: 15px;
        }

        .add-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background-color: #28a745;
            color: white;
            padding: 8px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 20px;
        }

        .add-btn:hover {
            background-color: #218838;
            color: white;
        }
    </style>

    <div class="container-artikel">
        @foreach ($artikels as $item)
            <div class="card-artikel">
                @if ($item->images->count() > 0)
                    <img src="{{ asset('images/' . $item->images->first()->gambar) }}" alt="Gambar Artikel">
                @else
                    <div style="width:100px; height:100px; background:#f0f0f0; border-radius:8px; display:flex; align-items:center; justify-content:center; color:#888; font-size:12px;">
                        Tidak ada gambar
                    </div>
                @endif

                <div class="card-artikel-content">
                    <h3>{{ $item->judul_artikel }}</h3>
                    <p>{{ \Illuminate\Support\Str::limit(strip_tags($item->isi_artikel), 30, '...') }}</p>
                    <a href="{{ route('artikel.show', $item->id_artikels) }}" class="read-more-link">Selengkapnya</a>
                </div>
            </div>
        @endforeach

        <div style="display: flex; justify-content: flex-end; gap: 10px; margin-bottom: 20px;">
            <a href="{{ route('artikel.create') }}" class="add-btn">
                <span class="material-icons">add</span>
            </a>
        </div>
    </div>
@endsection
