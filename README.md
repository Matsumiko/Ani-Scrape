# OtakluDesu API

API berbasis **Express + TypeScript** untuk scraping & parsing data dari beberapa sumber anime (saat ini: **Otakudesu** dan **Kuramanime**). Endpoint **Samehadaku** masih placeholder (Status: OFF).

> Catatan: Ini scraper. Struktur website sumber bisa berubah kapan saja dan bisa bikin endpoint error.

## Default Port
- Default: **7501**
- Bisa diubah via env `PORT`

## Konfigurasi (.env)
Copy contoh env:

```bash
cp .env.example .env
```

Isi penting:
- `PORT` (default `7501`)
- `SOURCE_URL` (`true`/`false`) → mengontrol apakah field `sourceUrl` ditampilkan di response

## Cara Run (pilih salah satu)

### 1) Docker Compose (recommended)

```bash
docker compose up -d --build
```

Cek:
```bash
curl http://localhost:7501/
```

Logs:
```bash
docker logs -f otakludesu-api
```

> Auto-start setelah reboot: sudah **aktif** karena `restart: unless-stopped` di `docker-compose.yaml`.

### 2) Docker (tanpa compose)

```bash
docker build -t otakludesu-api .
docker run -d --name otakludesu-api -p 7501:7501 -e PORT=7501 -e NODE_ENV=production otakludesu-api
```

### 3) PM2

```bash
npm install
npm run build
npm i -g pm2
pm2 start ecosystem.config.cjs
pm2 save
pm2 startup
```

> `pm2 startup` akan ngeluarin 1 command yang perlu kamu jalankan (biasanya pakai sudo). Itu yang bikin auto-start setelah reboot.

### 4) systemd service

```bash
# install + build
npm install
npm run build

# bikin service dan enable
bash scripts/deploy-systemd.sh
```

Cek:
```bash
sudo systemctl status otakludesu
sudo journalctl -u otakludesu -f
```

### Installer interaktif
Kalau mau tinggal pilih menu:

```bash
bash scripts/install.sh
```

## Development

```bash
npm install
npm run dev
```

Atur port custom:
```bash
PORT=7501 npm run dev
```

## Format Response
Semua response dibungkus format berikut:

```json
{
  "statusCode": 200,
  "statusMessage": "OK",
  "message": "",
  "data": {},
  "pagination": null
}
```

## API Docs
Base URL (local):
- `http://localhost:7501`

### Root
#### `GET /`
Menampilkan daftar group route.

---

## Otakudesu
Base path: `/otakudesu`

#### `GET /otakudesu`
Daftar endpoint Otakudesu.

#### `GET /otakudesu/home`
Halaman utama.

#### `GET /otakudesu/schedule`
Jadwal rilis.

#### `GET /otakudesu/anime`
Daftar semua anime.

#### `GET /otakudesu/genre`
Daftar semua genre.

#### `GET /otakudesu/ongoing?page=1`
Daftar anime ongoing.

Query:
- `page` (optional, default `1`)

#### `GET /otakudesu/completed?page=1`
Daftar anime completed.

Query:
- `page` (optional, default `1`)

#### `GET /otakudesu/search?q=naruto`
Cari anime.

Query:
- `q` (required)

#### `GET /otakudesu/genre/:genreId?page=1`
Daftar anime berdasarkan genre.

Path params:
- `genreId` (required)

Query:
- `page` (optional, default `1`)

#### `GET /otakudesu/batch/:batchId`
Detail batch.

#### `GET /otakudesu/anime/:animeId`
Detail anime.

#### `GET /otakudesu/episode/:episodeId`
Detail episode.

#### `GET|POST /otakudesu/server/:serverId`
Ambil link video dari `serverId`.

---

## Kuramanime
Base path: `/kuramanime`

#### `GET /kuramanime`
Daftar endpoint Kuramanime.

#### `GET /kuramanime/home`
Halaman utama.

#### `GET /kuramanime/anime`
Daftar anime.

Query (semua optional):
- `search` (string)
- `status` (`ongoing` | `completed` | `upcoming` | `movie`)
- `sort` (`a-z` | `z-a` | `oldest` | `latest` | `popular` | `most_viewed` | `updated`)
- `page` (default `1`)

Contoh:
```bash
curl "http://localhost:7501/kuramanime/anime?status=ongoing&page=1"
```

#### `GET /kuramanime/schedule`
Jadwal rilis.

Query:
- `day` (`all` | `random` | `monday` | `tuesday` | `wednesday` | `thursday` | `friday` | `saturday` | `sunday`) default `all`
- `page` default `1`

#### `GET /kuramanime/properties/:propertyType`
Daftar properti.

Path params:
- `propertyType` (`genre` | `season` | `studio` | `type` | `quality` | `source` | `country`)

#### `GET /kuramanime/properties/:propertyType/:propertyId`
Daftar anime berdasarkan properti.

#### `GET /kuramanime/anime/:animeId/:animeSlug`
Detail anime.

#### `GET /kuramanime/batch/:animeId/:animeSlug/:batchId`
Detail batch.

#### `GET /kuramanime/episode/:animeId/:animeSlug/:episodeId`
Detail episode.

---

## Samehadaku
Base path: `/samehadaku`

#### `GET /samehadaku`
Status: OFF (placeholder).

## Cache
- **Client cache** via header `Cache-Control` (default 1 menit) di root middleware.
- **Server cache** (LRU in-memory) untuk beberapa endpoint (TTL menit sesuai route, default 12 jam). Jika server restart, cache reset.

## License
MIT
