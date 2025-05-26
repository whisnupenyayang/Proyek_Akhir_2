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
        }

        .card-artikel img {
            width: 100%;
            height: auto;
            object-fit: cover;
            border-radius: 8px;
        }

        .card-artikel-content {
            padding: 10px 0;
            text-align: center;
        }

        @media (min-width: 768px) {
            .card-artikel {
                flex-direction: row;
                align-items: center;
                gap: 20px;
            }

            .card-artikel img {
                width: 200px;
                height: 150px;
            }

            .card-artikel-content {
                text-align: left;
                flex: 1;
            }
        }
    </style>

    <div class="container-artikel">

        @foreach ($artikels as $item)
            <div class="card-artikel">
                @if ($item->images->count() > 0)
                    <img src="{{ asset('images/' . $item->images->first()->gambar) }}" alt="Gambar Artikel">
                @else
                    <p>Tidak ada gambar</p>
                    @endif

                <div class="card-artikel-content">
                    <h3>{{ $item->judul_artikel }}</h3>
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
