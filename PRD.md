# PRD — Product Requirements Document

## Sistem Pencatatan Servis (ServiceTrack)

**Versi:** 1.0
**Tanggal:** 15 November 2026
**Sumber Acuan:** Dokumen SKPL ServiceTrack

---

## 1. Identitas & Tujuan Aplikasi

| Atribut | Nilai |
|---|---|
| **Nama Aplikasi** | ServiceTrack |
| **Ringkasan Sistem** | Aplikasi web untuk mencatat penerimaan barang servis, melakukan tracking status pengerjaan multi-tahap, serta mencatat estimasi dan biaya akhir servis secara terstruktur. |
| **Target Pengguna** | Petugas Servis (single role) |
| **Tech Stack** | HTML5 + CSS3 (Tailwind CSS) + JavaScript (Vanilla) + Supabase (PostgreSQL) |

### 1.1 Capaian Utama (Main Achievement)

Terbangunnya aplikasi tracking servis berbasis web yang fungsional, mencakup manajemen transaksi servis (CRUD), multi-stage status tracking, dan kalkulasi biaya akhir yang divalidasi melalui pengujian Black Box.

### 1.2 Tujuan Aplikasi

1. Mempermudah pencatatan penerimaan barang servis dan data pelanggan.
2. Menyediakan pembaruan status pengerjaan bertahap (Diterima → Diperiksa → Diproses → Selesai → Diambil).
3. Mengelola pencatatan estimasi dan biaya akhir servis.

### 1.3 Batasan Scope

- Hanya terdapat satu role (Petugas Servis).
- Tidak mencakup inventory spare part atau portal pelanggan online.
- Tidak mencakup notifikasi WhatsApp/SMS otomatis.

### 1.4 Alur Utama Sistem

```
Buka Aplikasi → Dashboard → Tambah Servis → Terbit Nomor Servis
→ Update Status (Diterima → Diperiksa → Diproses → Selesai)
→ Catat Biaya Akhir → Barang Diambil
```

---

## 2. Spesifikasi Fungsional Lengkap (CRUD + Kalkulasi/Filter)

### REQ-01 — Penerimaan Servis (Create)

| Aspek | Deskripsi |
|---|---|
| **Deskripsi** | Sistem mencatat nama pelanggan, barang, keluhan, dan menerbitkan nomor servis secara otomatis. |
| **Form Input** | `nama_pelanggan` (wajib), `nama_barang` (wajib), `keluhan` (wajib), `estimasi_biaya` (opsional, default 0). |
| **Logika Nomor Servis** | Sistem men-generate `no_servis` otomatis dengan format `SRV-YYYYMMDD-XXX` (contoh: `SRV-20261115-001`). Nomor ini bersifat unik dan read-only di form. |
| **Status Awal** | Setiap record baru otomatis mendapatkan status `Diterima`. |
| **Tanggal Masuk** | Diisi otomatis dengan timestamp server (`created_at`). |
| **Aksi** | Tombol **Simpan** menyimpan data ke tabel `services` via Supabase API. |
| **Tombol Reset** | Tombol **Reset / Batal Edit** mengosongkan seluruh field form dan mengembalikan form ke mode Create. |

### REQ-02 — Tracking Status (Update)

| Aspek | Deskripsi |
|---|---|
| **Deskripsi** | Petugas dapat memperbarui status pengerjaan servis secara berkala. |
| **Pilihan Status** | `Diterima` → `Diperiksa` → `Diproses` → `Selesai` → `Diambil` (dropdown/select). |
| **Aturan** | Saat status diubah ke `Selesai`, field `biaya_akhir` **wajib** diisi dengan nilai lebih dari 0. |
| **Catatan Teknisi** | Field `catatan_teknisi` dapat diisi/diperbarui saat update status. |

### REQ-03 — Biaya & Catatan (Update)

| Aspek | Deskripsi |
|---|---|
| **Deskripsi** | Sistem menyimpan estimasi biaya, biaya akhir, dan catatan teknisi. |
| **Field** | `estimasi_biaya` (diisi saat penerimaan), `biaya_akhir` (diisi saat/sebelum status `Selesai`), `catatan_teknisi` (teks bebas). |
| **Validasi** | `biaya_akhir` harus ≥ 0. Saat status = `Selesai`, `biaya_akhir` harus > 0. |

### REQ-04 — Tabel Riwayat Servis (Read)

| Aspek | Deskripsi |
|---|---|
| **Deskripsi** | Menampilkan seluruh data servis dalam tabel responsif, diurutkan berdasarkan data terbaru. |
| **Kolom Tabel** | No Servis, Nama Pelanggan, Nama Barang, Status (badge warna), Biaya Akhir (format Rupiah), Tanggal Masuk, Aksi (Edit & Hapus). |
| **Badge Warna Status** | `Diterima` = Biru, `Diperiksa` = Kuning/Amber, `Diproses` = Indigo, `Selesai` = Hijau/Emerald, `Diambil` = Abu-abu/Slate. |

### REQ-05 — Edit Data Servis (Update)

| Aspek | Deskripsi |
|---|---|
| **Deskripsi** | Petugas dapat menekan tombol **Edit** pada baris tabel untuk memuat data ke form input, lalu menyimpan perubahan. |
| **Perilaku Form** | Form berpindah ke mode Edit, tombol Simpan berubah label menjadi **Update**, dan tombol **Batal Edit** muncul. |

### REQ-06 — Hapus Data Servis (Delete)

| Aspek | Deskripsi |
|---|---|
| **Deskripsi** | Petugas dapat menekan tombol **Hapus** pada baris tabel. |
| **Konfirmasi** | Wajib menampilkan dialog konfirmasi (`confirm()`) sebelum menghapus: *"Yakin ingin menghapus data servis SRV-XXXXXXXX-XXX?"*. |

### REQ-07 — Pencarian & Filter (Read)

| Aspek | Deskripsi |
|---|---|
| **Deskripsi** | Petugas dapat mencari data berdasarkan kata kunci dan memfilter berdasarkan status. |
| **Kotak Pencarian** | Mencari teks pada kolom `no_servis`, `nama_pelanggan`, dan `nama_barang`. |
| **Dropdown Filter** | Filter berdasarkan status: Semua, Diterima, Diperiksa, Diproses, Selesai, Diambil. |

### REQ-08 — Kartu Ringkasan / KPI Cards (Read)

| Aspek | Deskripsi |
|---|---|
| **Deskripsi** | Dashboard menampilkan 3 kartu ringkasan di bagian atas halaman. |
| **Kartu 1** | **Total Servis Aktif** — Jumlah record dengan status selain `Diambil`. |
| **Kartu 2** | **Servis Selesai (Bulan Ini)** — Jumlah record berstatus `Selesai` atau `Diambil` pada bulan berjalan. |
| **Kartu 3** | **Total Pendapatan (Bulan Ini)** — Penjumlahan `biaya_akhir` dari record berstatus `Selesai` atau `Diambil` pada bulan berjalan, ditampilkan dalam format Rupiah (`id-ID`). |

---

## 3. Spesifikasi Skema Data (Supabase PostgreSQL)

### Tabel: `services`

> **KRITIS:** Nama tabel dan nama kolom di bawah ini adalah acuan mutlak. Seluruh kode frontend, query, dan pengujian HARUS menggunakan nama yang identik.

| # | Nama Kolom | Tipe Data PostgreSQL | Constraint / Default | Keterangan |
|---|---|---|---|---|
| 1 | `id` | `BIGINT` (PK) | `GENERATED ALWAYS AS IDENTITY` | Primary Key, auto-increment. |
| 2 | `no_servis` | `VARCHAR(30)` | `NOT NULL`, `UNIQUE` | Nomor servis unik, format `SRV-YYYYMMDD-XXX`. |
| 3 | `nama_pelanggan` | `VARCHAR(100)` | `NOT NULL` | Nama pelanggan. Tidak boleh kosong. |
| 4 | `nama_barang` | `VARCHAR(100)` | `NOT NULL` | Nama barang yang diservis. Tidak boleh kosong. |
| 5 | `keluhan` | `TEXT` | `NOT NULL` | Deskripsi keluhan pelanggan. Tidak boleh kosong. |
| 6 | `status` | `VARCHAR(20)` | `NOT NULL`, `DEFAULT 'Diterima'`, `CHECK (status IN ('Diterima','Diperiksa','Diproses','Selesai','Diambil'))` | Status pengerjaan servis. |
| 7 | `estimasi_biaya` | `DECIMAL(12,2)` | `NOT NULL`, `DEFAULT 0`, `CHECK (estimasi_biaya >= 0)` | Estimasi biaya awal. |
| 8 | `biaya_akhir` | `DECIMAL(12,2)` | `NOT NULL`, `DEFAULT 0`, `CHECK (biaya_akhir >= 0)` | Biaya akhir servis. |
| 9 | `catatan_teknisi` | `TEXT` | `DEFAULT ''` | Catatan/keterangan dari teknisi. |
| 10 | `created_at` | `TIMESTAMPTZ` | `DEFAULT NOW()` | Tanggal & waktu data dibuat. |

### Aturan Validasi Database-Level

| Constraint | Ekspresi | Tujuan |
|---|---|---|
| `chk_status_valid` | `CHECK (status IN ('Diterima','Diperiksa','Diproses','Selesai','Diambil'))` | Membatasi nilai status hanya pada 5 tahap yang sah. |
| `chk_estimasi_biaya` | `CHECK (estimasi_biaya >= 0)` | Estimasi biaya tidak boleh negatif. |
| `chk_biaya_akhir` | `CHECK (biaya_akhir >= 0)` | Biaya akhir tidak boleh negatif. |

---

## 4. Kontrak Pengujian Black Box & Keamanan (Acuan Mutlak QA)

### 4.1 Pengujian Fungsional

| ID Test | Skenario Pengujian | Input Data | Hasil yang Diharapkan | Status |
|---|---|---|---|---|
| **TC-01** | Update Status Servis (Positif) | Ubah status ke `Selesai` & Masukkan Biaya: `150000` | Status diperbarui menjadi `Selesai` & biaya akhir `150000` tersimpan di database dan ditampilkan di tabel. | PASS |
| **TC-02** | Update Status ke Selesai tanpa Biaya (Negatif) | Ubah status ke `Selesai` & Biaya Akhir dikosongkan atau diisi `0` | Proses simpan **DITOLAK**. Muncul pesan peringatan: **"Biaya akhir harus lebih dari 0 jika status Selesai"**. Data tidak berubah di database. | PASS |

### 4.2 Pengujian Keamanan

| ID Test | Skenario Pengujian | Input Data / Aksi | Hasil yang Diharapkan | Status |
|---|---|---|---|---|
| **SEC-01** | Uji Anti-XSS pada input teks | Masukkan payload `<img src=x onerror=alert(1)>` pada field `nama_pelanggan` atau `keluhan`, lalu simpan dan lihat tampilan tabel. | Payload ditampilkan sebagai **teks biasa** (plain text), **BUKAN** dieksekusi sebagai HTML/JavaScript. Tidak ada dialog alert yang muncul. | PASS |
| **SEC-02** | Audit ketiadaan Secret Key di kode frontend | Buka file `index.html` dan seluruh file `.js`, lalu cari string `service_role`, `SUPABASE_SERVICE_ROLE_KEY`, atau `STITCH_API_KEY`. | **Tidak ditemukan** satupun secret key di kode frontend. Hanya `SUPABASE_URL` dan `SUPABASE_ANON_KEY` (Public Anon Key) yang boleh ada. | PASS |

---

*Dokumen ini adalah acuan utama bagi seluruh proses pengembangan, desain UI, dan pengujian aplikasi ServiceTrack.*
