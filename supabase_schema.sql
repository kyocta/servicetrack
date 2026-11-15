-- ============================================================
-- SUPABASE SCHEMA SQL — ServiceTrack
-- Sistem Pencatatan Servis
-- Jalankan di: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. Buat Tabel services
CREATE TABLE IF NOT EXISTS public.services (
  id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  no_servis       VARCHAR(30)    NOT NULL UNIQUE,
  nama_pelanggan  VARCHAR(100)   NOT NULL,
  nama_barang     VARCHAR(100)   NOT NULL,
  keluhan         TEXT           NOT NULL,
  status          VARCHAR(20)    NOT NULL DEFAULT 'Diterima'
                    CONSTRAINT chk_status_valid
                    CHECK (status IN ('Diterima', 'Diperiksa', 'Diproses', 'Selesai', 'Diambil')),
  estimasi_biaya  DECIMAL(12,2)  NOT NULL DEFAULT 0
                    CONSTRAINT chk_estimasi_biaya
                    CHECK (estimasi_biaya >= 0),
  biaya_akhir     DECIMAL(12,2)  NOT NULL DEFAULT 0
                    CONSTRAINT chk_biaya_akhir
                    CHECK (biaya_akhir >= 0),
  catatan_teknisi TEXT           DEFAULT '',
  created_at      TIMESTAMPTZ    DEFAULT NOW()
);

-- 2. Aktifkan Row Level Security (RLS)
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;

-- 3. Policy: SELECT — Siapapun dengan anon key dapat membaca semua data
CREATE POLICY "Allow anon select"
  ON public.services
  FOR SELECT
  TO anon
  USING (true);

-- 4. Policy: INSERT — Anon dapat menambah data dengan validasi constraint
CREATE POLICY "Allow anon insert"
  ON public.services
  FOR INSERT
  TO anon
  WITH CHECK (
    -- Field wajib tidak boleh kosong
    nama_pelanggan IS NOT NULL AND LENGTH(TRIM(nama_pelanggan)) > 0
    AND nama_barang IS NOT NULL AND LENGTH(TRIM(nama_barang)) > 0
    AND keluhan IS NOT NULL AND LENGTH(TRIM(keluhan)) > 0
    -- Status harus valid
    AND status IN ('Diterima', 'Diperiksa', 'Diproses', 'Selesai', 'Diambil')
    -- Biaya tidak boleh negatif
    AND estimasi_biaya >= 0
    AND biaya_akhir >= 0
  );

-- 5. Policy: UPDATE — Anon dapat mengupdate data dengan validasi constraint
CREATE POLICY "Allow anon update"
  ON public.services
  FOR UPDATE
  TO anon
  USING (true)
  WITH CHECK (
    -- Field wajib tidak boleh kosong
    nama_pelanggan IS NOT NULL AND LENGTH(TRIM(nama_pelanggan)) > 0
    AND nama_barang IS NOT NULL AND LENGTH(TRIM(nama_barang)) > 0
    AND keluhan IS NOT NULL AND LENGTH(TRIM(keluhan)) > 0
    -- Status harus valid
    AND status IN ('Diterima', 'Diperiksa', 'Diproses', 'Selesai', 'Diambil')
    -- Biaya tidak boleh negatif
    AND estimasi_biaya >= 0
    AND biaya_akhir >= 0
  );

-- 6. Policy: DELETE — Anon dapat menghapus data (untuk keperluan demo workshop)
CREATE POLICY "Allow anon delete"
  ON public.services
  FOR DELETE
  TO anon
  USING (true);

-- 7. Data Contoh (3 Dummy Records)
INSERT INTO public.services (no_servis, nama_pelanggan, nama_barang, keluhan, status, estimasi_biaya, biaya_akhir, catatan_teknisi, created_at)
VALUES
  (
    'SRV-20261110-001',
    'Ahmad Fauzi',
    'Laptop ASUS VivoBook 14',
    'Laptop sering mati sendiri saat digunakan, baterai cepat habis',
    'Diproses',
    350000,
    0,
    'Baterai sudah dicek, kemungkinan perlu ganti baterai dan thermal paste',
    '2026-11-10 09:30:00+07'
  ),
  (
    'SRV-20261112-001',
    'Siti Nurhaliza',
    'Printer Epson L3150',
    'Hasil cetak bergaris dan tinta tidak keluar merata',
    'Selesai',
    150000,
    175000,
    'Head print sudah dibersihkan dan tinta diisi ulang. Tes cetak normal.',
    '2026-11-12 14:15:00+07'
  ),
  (
    'SRV-20261115-001',
    'Budi Santoso',
    'HP Samsung Galaxy A54',
    'Layar retak setelah terjatuh, touchscreen tidak responsif di bagian bawah',
    'Diterima',
    500000,
    0,
    '',
    '2026-11-15 08:00:00+07'
  );

-- ============================================================
-- SELESAI. Verifikasi dengan: SELECT * FROM public.services;
-- ============================================================
