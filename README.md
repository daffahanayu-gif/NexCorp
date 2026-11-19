# Holding Corp Hub — Portal Manajer (Dev 4), aplikasi mandiri
Branch: feature/dev4-flutter-manager. Tidak bergantung pada kode Dev 3.

## Menjalankan
- `flutter pub get && flutter run` (mode dummy, tanpa backend). Akun demo: rina@nusantaratech.id / bagas@majulogistik.id (password `password123`).
- Mode API: `flutter run --dart-define=USE_API=true [--dart-define=API_URL=https://host/api]` (Android Emulator otomatis `10.0.2.2:3000`).
- Di mode dummy, tab Pengajuan punya ikon labu (🧪) untuk mensimulasikan keputusan CEO.

## Struktur lib/
- `auth/` login + sesi · `manager_portal/` layar Manajer · `services/` repository (dummy + API) · `models/` ProyekModel, PengajuanModel, PenggunaModel (OOP) · `data/dummy_store.dart` · `utils/format.dart` · `widgets/muat_data.dart`

## Fitur
Login Manajer · daftar proyek PT · tambah proyek (DatePicker) · update progres (Slider + status) · ajukan approval · riwayat pengajuan · hapus proyek (dialog konfirmasi).

## Menggabung dengan Portal CEO (Dev 3) nanti
Isi `AppDependencies.ceoPortalBuilder` (mis. `(_) => CeoHome(repo: ...)`) agar login role CEO masuk ke portal CEO. Model di `models/` sengaja salinan terpisah; saat monorepo digabung, pilih satu versi.

## Kontrak API yang dibutuhkan dari Dev 2
- `POST /api/login` -> `data: {id, nama, email, role, id_departemen, id_perusahaan, nama_pt, nama_departemen}`
- `GET /api/proyek?id_perusahaan=` · `POST /api/proyek` (201) · `PUT /api/proyek/:id` · `DELETE /api/proyek/:id`
- `POST /api/approval` (201; `id_proyek,id_pemohon,jenis_pengajuan,nominal,catatan,status_approval`) · `GET /api/approval?id_pemohon=`
- Sukses `{status:'success', data}`, gagal `{status:'error', message}`. FK id_proyek di pengajuan_approval harus ON DELETE CASCADE.

Catatan: belum dikompilasi di lingkungan pembuatan; jalankan `flutter analyze` dan `flutter test`.
