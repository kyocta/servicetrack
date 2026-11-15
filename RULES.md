# RULES.md — AI Coding & Security Guardrails

## Sistem Pencatatan Servis (ServiceTrack)

**Versi:** 1.0
**Tanggal:** 15 November 2026
**Status:** HUKUM WAJIB — Seluruh aturan di bawah ini bersifat mutlak dan tidak boleh dilanggar oleh AI Coding Assistant.

---

## 1. Kepatuhan Skema & Spesifikasi

### 1.1 Nama Tabel & Kolom (Identik dengan PRD.md & SKPL)

AI Coding Assistant **WAJIB** menggunakan nama tabel dan nama kolom yang **100% identik** dengan spesifikasi di `PRD.md` dan dokumen SKPL:

| Tabel | Kolom yang WAJIB digunakan |
|---|---|
| `services` | `id`, `no_servis`, `nama_pelanggan`, `nama_barang`, `keluhan`, `status`, `estimasi_biaya`, `biaya_akhir`, `catatan_teknisi`, `created_at` |

**DILARANG:**
- Mengganti nama tabel (misalnya `service_records`, `tbl_servis`).
- Mengganti nama kolom (misalnya `customer_name` bukan `nama_pelanggan`, `finalCost` bukan `biaya_akhir`).
- Menambah atau menghapus kolom tanpa persetujuan eksplisit di dokumen SKPL.

### 1.2 Kalimat Pesan Error Validasi (Identik dengan SKPL)

Setiap pesan error yang ditampilkan ke pengguna **WAJIB** menggunakan kalimat yang persis sesuai dengan kontrak pengujian di `PRD.md`:

| Skenario | Kalimat Pesan yang WAJIB Ditampilkan |
|---|---|
| TC-02: Status = `Selesai` tetapi `biaya_akhir` kosong atau `0` | **"Biaya akhir harus lebih dari 0 jika status Selesai"** |
| Nama pelanggan kosong | **"Nama pelanggan wajib diisi"** |
| Nama barang kosong | **"Nama barang wajib diisi"** |
| Keluhan kosong | **"Keluhan wajib diisi"** |
| Estimasi biaya negatif | **"Estimasi biaya tidak boleh negatif"** |
| Biaya akhir negatif | **"Biaya akhir tidak boleh negatif"** |

---

## 2. Aturan Mutlak Anti-XSS (SEC-01)

### 2.1 LARANGAN KERAS

AI Coding Assistant **DILARANG KERAS** melakukan hal-hal berikut untuk merender data yang berasal dari pengguna atau database:

```javascript
// ❌ DILARANG — Rentan terhadap XSS
element.innerHTML = dataDariDatabase;
element.outerHTML = dataDariDatabase;
document.write(dataDariDatabase);
```

### 2.2 CARA YANG BENAR

Seluruh data dinamis dari pengguna atau database **WAJIB** dirender menggunakan salah satu metode aman berikut:

**Metode 1: `.textContent` (DIUTAMAKAN)**
```javascript
// ✅ AMAN — textContent tidak mengeksekusi HTML/JS
const td = document.createElement('td');
td.textContent = row.nama_pelanggan; // Aman dari XSS
```

**Metode 2: Fungsi `escapeHtml()` (Jika terpaksa menggunakan innerHTML untuk struktur kompleks)**
```javascript
// ✅ AMAN — Fungsi sanitasi wajib
function escapeHtml(text) {
  const map = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;'
  };
  return String(text).replace(/[&<>"']/g, function(m) { return map[m]; });
}

// Penggunaan:
element.innerHTML = `<span>${escapeHtml(row.nama_pelanggan)}</span>`;
```

### 2.3 Aturan Validasi SEC-01

Saat pengujian `SEC-01` dijalankan:
- Input payload `<img src=x onerror=alert(1)>` pada field `nama_pelanggan` atau `keluhan`.
- Simpan data dan lihat tampilan tabel.
- **HARUS**: Payload ditampilkan sebagai teks biasa: `<img src=x onerror=alert(1)>`.
- **TIDAK BOLEH**: Dialog alert JavaScript muncul di browser.

---

## 3. Aturan Mutlak Validasi Input (TC-01 & TC-02)

### 3.1 Jangan Andalkan HTML Saja

```html
<!-- ❌ TIDAK CUKUP — Mudah di-bypass via Inspect Element -->
<input type="number" required min="1">
```

Atribut HTML `required`, `min`, `max`, `pattern` **boleh** digunakan sebagai lapisan pertama, tetapi **TIDAK BOLEH** menjadi satu-satunya mekanisme validasi.

### 3.2 Validasi JavaScript WAJIB Ada

Sebelum memanggil API Supabase (`insert` atau `update`), kode JavaScript **WAJIB** menjalankan fungsi validasi yang memeriksa logika bisnis:

```javascript
function validateForm(data) {
  const errors = [];

  // Validasi field wajib
  if (!data.nama_pelanggan || data.nama_pelanggan.trim() === '') {
    errors.push('Nama pelanggan wajib diisi');
  }
  if (!data.nama_barang || data.nama_barang.trim() === '') {
    errors.push('Nama barang wajib diisi');
  }
  if (!data.keluhan || data.keluhan.trim() === '') {
    errors.push('Keluhan wajib diisi');
  }

  // Validasi biaya
  if (data.estimasi_biaya < 0) {
    errors.push('Estimasi biaya tidak boleh negatif');
  }
  if (data.biaya_akhir < 0) {
    errors.push('Biaya akhir tidak boleh negatif');
  }

  // Validasi TC-02: Status Selesai wajib punya biaya akhir > 0
  if (data.status === 'Selesai' && (!data.biaya_akhir || data.biaya_akhir <= 0)) {
    errors.push('Biaya akhir harus lebih dari 0 jika status Selesai');
  }

  return errors;
}
```

### 3.3 Alur Validasi

```
User klik Simpan/Update
  → Ambil semua nilai dari form
  → Jalankan validateForm(data)
  → Jika errors.length > 0:
      → HENTIKAN proses simpan
      → Tampilkan pesan error di Alert Error Box (menggunakan .textContent)
      → JANGAN panggil Supabase API
  → Jika errors.length === 0:
      → Panggil Supabase API (insert/update)
      → Tampilkan Alert Sukses
      → Refresh tabel & KPI cards
```

---

## 4. Aturan Keamanan Kredensial (SEC-02)

### 4.1 BOLEH Ada di Kode Frontend (`index.html` / file `.js`)

| Variabel | Tipe | Alasan |
|---|---|---|
| `SUPABASE_URL` | Public | URL project Supabase, bukan rahasia. |
| `SUPABASE_ANON_KEY` | Public (Anon Key) | Kunci publik yang dibatasi oleh Row Level Security (RLS). |

```javascript
// ✅ BOLEH — Kredensial publik
const SUPABASE_URL = 'https://xxxxx.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIs...'; // Public Anon Key
```

### 4.2 DILARANG KERAS Ada di Kode Frontend

| Variabel | Tipe | Bahaya |
|---|---|---|
| `SUPABASE_SERVICE_ROLE_KEY` | Secret | Memberikan akses penuh bypass RLS. |
| `STITCH_API_KEY` | Secret | Kunci API Google Stitch, bukan untuk publik. |
| Password database | Secret | Akses langsung ke PostgreSQL. |

```javascript
// ❌ DILARANG KERAS — Secret key di frontend
const SUPABASE_SERVICE_ROLE_KEY = 'eyJhbGc...'; // JANGAN!
const STITCH_API_KEY = 'AIza...'; // JANGAN!
```

### 4.3 Cara Verifikasi SEC-02

1. Buka file `index.html` dan seluruh file `.js` di project.
2. Gunakan fitur Find/Search (`Ctrl+F`) untuk mencari kata kunci:
   - `service_role`
   - `SERVICE_ROLE_KEY`
   - `STITCH_API_KEY`
3. **Hasil yang diharapkan:** Tidak ada satupun yang ditemukan.

---

## 5. Aturan Tambahan

### 5.1 Konsistensi dengan DESIGN.md

- Seluruh kelas Tailwind CSS **WAJIB** mengikuti spesifikasi di `DESIGN.md`.
- Palet warna badge status **WAJIB** sesuai tabel di `DESIGN.md` Bagian 1.1.

### 5.2 Format Angka & Tanggal

- Seluruh angka mata uang **WAJIB** ditampilkan dalam format Rupiah menggunakan `Intl.NumberFormat('id-ID', ...)`.
- Seluruh tanggal **WAJIB** ditampilkan menggunakan `Intl.DateTimeFormat('id-ID', ...)`.

### 5.3 Struktur File

```
project/
├── index.html          ← File utama (HTML + Tailwind CDN + JS inline atau terpisah)
├── PRD.md              ← Product Requirements Document
├── DESIGN.md           ← Design System & UI Guidelines
├── RULES.md            ← AI Coding & Security Guardrails (file ini)
└── supabase_schema.sql ← Script SQL untuk Supabase
```

---

*Pelanggaran terhadap aturan di dokumen ini dianggap sebagai cacat kritis (critical defect) dan wajib diperbaiki sebelum deployment.*
