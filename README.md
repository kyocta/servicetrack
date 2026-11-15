# 🛠️ ServiceTrack — Sistem Pencatatan Servis & Tracking Multi-Stage

> Aplikasi web modern, responsif, dan aman untuk loket tempat servis: mencatat penerimaan unit, tracking multi-stage pengerjaan teknisi, pencatatan kas biaya akhir, dan audit pengujian Black Box serta Anti-XSS.

![Tech Stack](https://img.shields.io/badge/Frontend-HTML5%20%7C%20TailwindCSS%20%7C%20JS-blue)
![Database](https://img.shields.io/badge/Database-Supabase%20PostgreSQL-green)
![Security](https://img.shields.io/badge/Security-Anti--XSS%20%7C%20Zero--Leak-emerald)
![Audit Status](https://img.shields.io/badge/QA%20Status-TC--01%20%7C%20TC--02%20PASS-brightgreen)
![Design](https://img.shields.io/badge/Design%20Ref-Penpot%20%7C%20Google%20Stitch-purple)

---

## 📖 1. Tentang Proyek & Arsitektur "Spec-Driven Vibe Coding"

Aplikasi **ServiceTrack** dibangun menggunakan metodologi **Spec-Driven Vibe Coding**, di mana setiap baris kode, antarmuka visual, dan skema database diturunkan secara disiplin dari dokumen spesifikasi:

```
┌──────────────┐     ┌──────────────┐     ┌───────────────────────┐
│ Dokumen SKPL │ ──> │    PRD.md    │ ──> │ Penpot & Google Stitch│
└──────────────┘     └──────────────┘     └───────────────────────┘
                                                      │
                                                      ▼
┌──────────────┐     ┌──────────────┐     ┌───────────────────────┐
│ AUDIT_REPORT │ <── │  index.html  │ <── │ DESIGN.md & RULES.md  │
└──────────────┘     └──────────────┘     └───────────────────────┘
```

1. **SKPL (Spesifikasi Kebutuhan Perangkat Lunak)**: Titik tolak identifikasi entitas transaksi servis dan batasan sistem.
2. **`PRD.md`**: Dokumen rujukan tunggal fungsionalitas CRUD, skema PostgreSQL Supabase, dan kontrak QA.
3. **Penpot Design System**: Mengimplementasikan antarmuka dari 5 board Penpot (*Beranda Operasional*, *Tambah Servis*, *Daftar Servis*, *Catat Biaya Akhir*, dan *Detail Servis & Tracking Status*).
4. **`DESIGN.md` & `RULES.md`**: Guardrails hukum AI untuk mencegah degradasi desain, melarang injeksi XSS, dan memblokir kebocoran private API keys.
5. **`AUDIT_REPORT.md`**: Laporan audit independen DevSecOps yang mengonfirmasi lulus pengujian 100%.

---

## ✨ 2. Daftar Fitur Lengkap Sesuai SKPL

- **`REQ-01` — Penerimaan Servis Baru (Create):**
  - Form pencatatan Nama Pelanggan, Nama Barang/Unit, dan Keluhan awal.
  - Penerbitan otomatis Nomor Servis unik berformat `SRV-YYYYMMDD-XXXX`.
  - Otomatis berstatus awal `Diterima` dan mencatat estimasi biaya awal.
- **`REQ-02` — Tracking Status Multi-Stage (Update):**
  - Alur progresif satu arah: `Diterima` ➡️ `Diperiksa` ➡️ `Diproses` ➡️ `Selesai` ➡️ `Diambil`.
  - Dilengkapi *Visual Stepper 5-Tahap* interaktif dan dialog konfirmasi pencegah salah klik.
- **`REQ-03` — Pengelolaan Biaya & Catatan Teknisi (Update):**
  - Modal khusus pencatatan kas biaya akhir dengan validasi input angka positif.
  - Form catatan perbaikan/sparepart oleh teknisi.
  - Opsi instan *Tandai Barang Diambil* untuk pelunasan loket.
- **`REQ-04` — Riwayat & Tabel Data Interaktif (Read, Filter, & Delete):**
  - Tabel responsif dengan badge status berwarna sesuai standar desain Penpot.
  - Pencarian instan (real-time search) berdasarkan nomor tiket, nama pelanggan, atau jenis barang.
  - Filter kategori per tahap status pengerjaan.
  - Tombol aksi: *Lihat Detail*, *Catat Biaya*, dan *Hapus* baris dengan dialog konfirmasi aman.
- **Dashboard Operasional & Metrik Ringkasan:**
  - 4 Kartu Metrik Dinamis (*Total Masuk Hari Ini*, *Menunggu Diperiksa*, *Sedang Diproses*, *Selesai/Siap Ambil*).
  - Indikator Total Akumulasi Kas Masuk Pelunasan Servis (format Rupiah `id-ID`).
  - Panel Aksi Cepat (*Quick Action*) langsung pada baris tiket aktif di Beranda.

---

## 🛡️ 3. Kontrak Pengujian Black Box & Hasil Audit Keamanan

Aplikasi dilengkapi dengan **Panel Uji Cepat SKPL (QA & Security Mode)** di bagian atas halaman untuk memudahkan demonstrasi penguji secara 1-klik:

| Kode Uji | Skenario Pengujian | Input Data | Hasil yang Diharapkan | Status |
|:---:|---|---|---|:---:|
| **`TC-01`** | Validasi Input Negatif (Black Box) | Nominal Biaya: `-50000` | Input ditolak oleh logika JavaScript sebelum request dikirim. Muncul alert merah: *"Nominal harus lebih dari 0. Biaya akhir tidak boleh bernilai negatif."* | **PASS ✅** |
| **`TC-02`** | Validasi Positif Status Selesai | Status: `Selesai`, Biaya: `+150000` | Status berhasil diupdate menjadi Selesai, biaya akhir `150000` tersimpan ke database & terakumulasi di kas. | **PASS ✅** |
| **`SEC-01`** | Uji Ketahanan Anti-XSS | `<img src="x" onerror="alert('Jebol XSS!')">` | Seluruh data dinamis dirender murni melalui `.textContent`. Script tidak pernah dieksekusi browser, tampil 100% sebagai teks biasa. | **PASS ✅** |
| **`SEC-02`** | Audit Ketiadaan Secret Key | Inspeksi seluruh source code frontend | Kunci `service_role` dan private token dilarang keras. Hanya menggunakan Public Anon Key yang dibatasi Row Level Security (RLS). | **PASS ✅** |

---

## 🗄️ 4. Struktur Database (Supabase PostgreSQL)

Tabel utama: `public.services`

```sql
CREATE TABLE IF NOT EXISTS public.services (
  id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  no_servis       VARCHAR(30)    NOT NULL UNIQUE,
  nama_pelanggan  VARCHAR(100)   NOT NULL,
  nama_barang     VARCHAR(100)   NOT NULL,
  keluhan         TEXT           NOT NULL,
  status          VARCHAR(20)    NOT NULL DEFAULT 'Diterima'
                    CHECK (status IN ('Diterima', 'Diperiksa', 'Diproses', 'Selesai', 'Diambil')),
  estimasi_biaya  DECIMAL(12,2)  NOT NULL DEFAULT 0 CHECK (estimasi_biaya >= 0),
  biaya_akhir     DECIMAL(12,2)  NOT NULL DEFAULT 0 CHECK (biaya_akhir >= 0),
  catatan_teknisi TEXT           DEFAULT '',
  created_at      TIMESTAMPTZ    DEFAULT NOW()
);
```

> **Mode Fallback Cerdas:** Jika aplikasi belum dihubungkan dengan kredensial Supabase, sistem secara otomatis beralih ke **Mode Demo Lokal (`localStorage`)** dengan 5 record awal realistis tanpa menimbulkan crash atau error.

---

## 🚀 5. Panduan Menjalankan & Deployment ke Vercel

### Menjalankan di Lokal:
1. Clone atau download folder proyek ini.
2. Buka file `index.html` langsung di browser Anda (atau klik kanan ➡️ *Open with Live Server* di VS Code).

### Deployment ke Vercel:
1. Unggah folder proyek ini ke repository baru di **[GitHub](https://github.com/)**.
2. Buka dashboard **[Vercel](https://vercel.com/)** dan pilih **Add New... ➡️ Project**.
3. Import repository GitHub Anda, biarkan pengaturan framework pada **Other**, lalu klik **Deploy**.
4. Dalam 15 detik, aplikasi Anda live dan memiliki URL publik aktif (contoh: `https://servicetrack.vercel.app`).

---

## 📂 Struktur File Repositori

```
├── index.html            # Aplikasi Single-Page (HTML, Tailwind CSS, JS, Supabase)
├── PRD.md                # Product Requirements Document & Spesifikasi Sistem
├── DESIGN.md             # Design System & UI Guidelines
├── RULES.md              # Hukum AI Coding & Security Guardrails
├── AUDIT_REPORT.md       # Laporan Audit Resmi DevSecOps (TC-01, TC-02, SEC-01, SEC-02)
├── supabase_schema.sql   # Script Skema PostgreSQL, Constraint, & RLS Policies
├── .gitignore            # Proteksi agar kredensial rahasia tidak terunggah ke publik
└── README.md             # Dokumentasi Portofolio Proyek
```

---

*Dikembangkan untuk Workshop JKB 2026 — Sistem Informasi Servis Terintegrasi & Aman.*
