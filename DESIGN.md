# DESIGN.md — Design System & UI Guidelines

## Sistem Pencatatan Servis (ServiceTrack)

**Versi:** 1.0
**Tanggal:** 15 November 2026
**Acuan:** PRD.md & Dokumen SKPL ServiceTrack

---

## 1. Palet Warna Tailwind CSS

| Elemen | Kelas Tailwind | Keterangan |
|---|---|---|
| **Background Utama** | `bg-slate-50` | Latar belakang halaman keseluruhan. |
| **Kartu / Panel** | `bg-white shadow-sm border border-slate-200 rounded-xl` | Kontainer form, tabel, dan KPI cards. |
| **Warna Primer (Aksi Utama)** | `bg-indigo-600 hover:bg-indigo-700 text-white` | Tombol Simpan, Update, link aktif. |
| **Warna Sekunder (Reset/Batal)** | `bg-slate-200 hover:bg-slate-300 text-slate-700` | Tombol Reset / Batal Edit. |
| **Warna Sukses / Selesai** | `bg-emerald-600 text-white` | Badge status `Selesai`, alert sukses. |
| **Warna Bahaya / Error / Hapus** | `bg-rose-600 hover:bg-rose-700 text-white` | Tombol Hapus, alert error, badge peringatan. |
| **Alert Error Box** | `bg-rose-50 border border-rose-300 text-rose-700 rounded-lg p-4` | Kotak pesan error validasi (TC-01 gagal). |
| **Alert Sukses Box** | `bg-emerald-50 border border-emerald-300 text-emerald-700 rounded-lg p-4` | Kotak pesan sukses setelah simpan/update/hapus. |

### 1.1 Palet Badge Status Servis

| Status | Background | Teks | Contoh Kelas |
|---|---|---|---|
| `Diterima` | `bg-blue-100` | `text-blue-800` | `px-2.5 py-0.5 rounded-full text-xs font-medium` |
| `Diperiksa` | `bg-amber-100` | `text-amber-800` | `px-2.5 py-0.5 rounded-full text-xs font-medium` |
| `Diproses` | `bg-indigo-100` | `text-indigo-800` | `px-2.5 py-0.5 rounded-full text-xs font-medium` |
| `Selesai` | `bg-emerald-100` | `text-emerald-800` | `px-2.5 py-0.5 rounded-full text-xs font-medium` |
| `Diambil` | `bg-slate-100` | `text-slate-600` | `px-2.5 py-0.5 rounded-full text-xs font-medium` |

---

## 2. Tipografi & Hierarki

### 2.1 Font Family

```css
@import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');

body {
  font-family: 'Plus Jakarta Sans', 'Inter', ui-sans-serif, system-ui, sans-serif;
}
```

### 2.2 Hierarki Teks

| Elemen | Kelas Tailwind | Penggunaan |
|---|---|---|
| Judul Aplikasi (Header) | `text-2xl font-bold text-slate-800` | Judul "ServiceTrack" di header bar. |
| Subjudul Header | `text-sm text-slate-500` | Keterangan "Sistem Pencatatan Servis". |
| Judul Section / Kartu | `text-lg font-semibold text-slate-700` | Judul form, judul tabel. |
| Label Form | `text-sm font-medium text-slate-600` | Label di atas setiap field input. |
| Isi Tabel | `text-sm text-slate-700` | Teks di dalam sel tabel. |
| Header Tabel | `text-xs font-semibold text-slate-500 uppercase tracking-wider` | Header kolom tabel. |
| Angka KPI Card | `text-2xl font-bold text-slate-800` | Angka besar di kartu ringkasan. |
| Label KPI Card | `text-sm font-medium text-slate-500` | Keterangan di bawah angka KPI. |

### 2.3 Format Angka, Mata Uang & Tanggal (Locale Indonesia)

Seluruh angka mata uang dan tanggal WAJIB diformat menggunakan locale `id-ID`:

```javascript
// Format Rupiah
function formatRupiah(angka) {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(angka);
}
// Contoh output: Rp150.000

// Format Tanggal
function formatTanggal(dateString) {
  return new Intl.DateTimeFormat('id-ID', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  }).format(new Date(dateString));
}
// Contoh output: 15 November 2026
```

---

## 3. Aturan Komponen Interaktif

### 3.1 Loading State pada Tombol

Saat proses simpan/update/hapus sedang berjalan (menunggu respons Supabase), tombol aksi WAJIB menunjukkan loading state:

```html
<!-- Contoh: Tombol Simpan dalam loading state -->
<button disabled class="bg-indigo-400 cursor-not-allowed text-white font-semibold py-2.5 px-6 rounded-lg flex items-center gap-2">
  <svg class="animate-spin h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path>
  </svg>
  Menyimpan...
</button>
```

**Aturan:**
- Tombol menjadi `disabled` dan opacity berkurang.
- Teks berubah menjadi kata kerja progresif: *"Menyimpan..."*, *"Mengupdate..."*, *"Menghapus..."*.
- Spinner SVG animasi `animate-spin` ditampilkan di sebelah kiri teks.

### 3.2 Empty State (Tabel Kosong)

Jika tabel `services` tidak memiliki data (atau hasil filter/pencarian kosong), tampilkan empty state:

```html
<tr>
  <td colspan="7" class="text-center py-12">
    <svg class="mx-auto h-12 w-12 text-slate-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
            d="M9 12h6m-3-3v6m-7 4h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
    </svg>
    <p class="mt-2 text-sm text-slate-500">Belum ada data servis.</p>
    <p class="text-xs text-slate-400">Gunakan form di sebelah kiri untuk menambah data baru.</p>
  </td>
</tr>
```

### 3.3 Alert Banner Validasi (TC-01 / TC-02 Gagal)

Saat validasi JavaScript mendeteksi input tidak valid (misalnya skenario TC-02: status `Selesai` tetapi biaya akhir = 0), Alert Error Box WAJIB ditampilkan di dalam area form:

```html
<!-- Alert Error Box — tampil di atas tombol Simpan -->
<div id="alert-error" class="hidden bg-rose-50 border border-rose-300 text-rose-700 rounded-lg p-4 mb-4 flex items-start gap-3" role="alert">
  <svg class="h-5 w-5 text-rose-500 mt-0.5 shrink-0" fill="currentColor" viewBox="0 0 20 20">
    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm-.75-11.25a.75.75 0 011.5 0v4.5a.75.75 0 01-1.5 0v-4.5zm.75 7.5a.75.75 0 100-1.5.75.75 0 000 1.5z" clip-rule="evenodd"/>
  </svg>
  <span id="alert-error-msg" class="text-sm font-medium"><!-- Pesan error dinamis --></span>
</div>
```

**Aturan:**
- Default: `hidden`. Ditampilkan dengan menghapus class `hidden` saat validasi gagal.
- Pesan error diisi menggunakan `.textContent` (BUKAN `.innerHTML`) untuk keamanan anti-XSS.
- Alert otomatis disembunyikan saat pengguna memulai pengetikan ulang atau mengklik Reset.

### 3.4 Alert Sukses

```html
<div id="alert-success" class="hidden bg-emerald-50 border border-emerald-300 text-emerald-700 rounded-lg p-4 mb-4 flex items-start gap-3" role="alert">
  <svg class="h-5 w-5 text-emerald-500 mt-0.5 shrink-0" fill="currentColor" viewBox="0 0 20 20">
    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.06l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clip-rule="evenodd"/>
  </svg>
  <span id="alert-success-msg" class="text-sm font-medium">Data berhasil disimpan!</span>
</div>
```

---

## 4. Layout Responsif

### 4.1 Breakpoint Grid

| Breakpoint | Layout | Keterangan |
|---|---|---|
| `< md (< 768px)` | 1 kolom (stacked) | Form di atas, tabel di bawah. KPI cards stack vertikal. |
| `≥ md (768px)` | 1 kolom | Form dan tabel masih stacked tetapi lebih lega. |
| `≥ lg (1024px)` | 2 kolom (`grid-cols-5`) | Form = `col-span-2`, Tabel = `col-span-3`. |

### 4.2 Kelas Grid Utama

```html
<div class="grid grid-cols-1 lg:grid-cols-5 gap-6">
  <!-- Kolom Kiri: Form -->
  <div class="lg:col-span-2">...</div>
  <!-- Kolom Kanan: Tabel -->
  <div class="lg:col-span-3">...</div>
</div>
```

---

*Dokumen ini wajib dipatuhi oleh AI Coding Assistant saat membangun antarmuka ServiceTrack.*
