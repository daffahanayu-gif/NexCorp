# NexCorp (Holding Corp Hub) - API Contract

**Base URL (Lokal):** `http://localhost:3000/api`
**Format Data:** JSON (`snake_case`)

---

## 1. Autentikasi (Multi-Role)

### `POST /login`

Cek `email` & `password` di tabel `pengguna`, sekaligus mengambil `id_perusahaan` melalui tabel `departemen`.

**Request Body:**

```json
{
  "email": "budi.tech@nexcorp.id",
  "password": "manajer123"
}
```

**Response `200 OK`:**

```json
{
  "status": "success",
  "data": {
    "id": 2,
    "nama": "Budi Santoso",
    "email": "budi.tech@nexcorp.id",
    "role": "Manajer",
    "id_departemen": 1,
    "id_perusahaan": 1
  }
}
```

_(Catatan: Untuk role `CEO`, `id_departemen` dan `id_perusahaan` bernilai `null`)_

---

## 2. Dashboard Eksekutif CEO (Dev 3)

### `GET /ceo/ringkasan`

Mengambil rekap seluruh anak perusahaan dari `view_ringkasan_holding` (jumlah proyek & rata-rata progres).

**Response `200 OK`:**

```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "kode_pt": "NX-TECH",
      "nama_pt": "PT NexCorp Digital Teknologi",
      "nama_sektor": "Teknologi & IT",
      "kota_pusat": "Jakarta",
      "status_operasional": "Aktif",
      "jumlah_proyek": "1",
      "rata_progres_proyek": "85.0"
    }
  ]
}
```

### `GET /ceo/keuangan`

Mengambil rekap pemasukan, pengeluaran, laba bersih, dan valuasi aset tiap anak perusahaan.

---

## 3. CRUD Anak Perusahaan

- **`GET /perusahaan`** — Ambil daftar semua anak perusahaan (JOIN `sektor_industri`).
- **`GET /perusahaan/:id`** — Ambil detail 1 anak perusahaan beserta daftar proyeknya.
- **`POST /perusahaan`** — Tambah anak perusahaan baru (`id_sektor`, `kode_pt`, `nama_pt`, `kota_pusat`, `status_operasional`).
- **`PUT /perusahaan/:id`** — Update data anak perusahaan.
- **`DELETE /perusahaan/:id`** — Hapus anak perusahaan.

---

## 4. CRUD Proyek Operasional (Dev 4)

- **`GET /proyek`** — Ambil semua proyek (bisa difilter dengan query `?id_perusahaan=1`).
- **`POST /proyek`** — Tambah proyek baru.

**Request Body (`POST /proyek`):**

```json
{
  "id_perusahaan": 1,
  "nama_proyek": "Pengembangan Mobile App",
  "target_selesai": "2027-02-20",
  "progres_persen": 0,
  "status_proyek": "Perencanaan"
}
```

- **`PUT /proyek/:id`** — Update progres & status proyek (dari Slider Manajer).

**Request Body (`PUT /proyek/:id`):**

```json
{
  "progres_persen": 75,
  "status_proyek": "Berjalan"
}
```

- **`DELETE /proyek/:id`** — Hapus proyek.

---

## 5. Pengajuan & Keputusan Approval (Dev 3 & Dev 4)

- **`GET /approval`** — Ambil daftar pengajuan approval (bisa difilter `?status=Pending`).
- **`POST /approval`** — Manajer mengajukan approval baru.

**Request Body (`POST /approval`):**

```json
{
  "id_proyek": 1,
  "id_pemohon": 2,
  "jenis_pengajuan": "Penambahan Anggaran Server",
  "nominal": 150000000,
  "catatan": "Untuk upgrade kapasitas cloud"
}
```

- **`PUT /approval/:id`** — CEO mengeksekusi keputusan (`Approved` atau `Rejected`).

**Request Body (`PUT /approval/:id`):**

```json
{
  "status_approval": "Approved"
}
```
