Design a modern, professional single-page web application UI called "ServiceTrack" — a service repair tracking system. Use Tailwind CSS utility classes throughout. The design should feel clean, airy, and enterprise-ready with a slate-50 background.

=== HEADER BAR ===
- A full-width header bar with a white background, subtle bottom border (border-slate-200), and horizontal padding.
- Left side: App title "ServiceTrack" in bold text-2xl text-slate-800, with a subtitle below it: "Sistem Pencatatan Servis" in text-sm text-slate-500.
- Right side: A small badge/pill indicator showing a green dot (bg-emerald-500 rounded-full w-2 h-2 inline-block animate-pulse) followed by the text "Supabase Connected" in text-xs font-medium text-emerald-700, all inside a bg-emerald-50 border border-emerald-200 rounded-full px-3 py-1 container.

=== SUMMARY / KPI CARDS (3 Cards in a Row) ===
- Below the header, display 3 KPI summary cards in a responsive grid (grid-cols-1 md:grid-cols-3 gap-4).
- Each card: bg-white rounded-xl shadow-sm border border-slate-200 p-5.
- Card 1: Label "Total Servis Aktif" (text-sm font-medium text-slate-500), Value "12" (text-2xl font-bold text-slate-800), with a small blue icon (a wrench/tool icon) on the right side.
- Card 2: Label "Selesai Bulan Ini" (text-sm font-medium text-slate-500), Value "8" (text-2xl font-bold text-emerald-600), with a small green checkmark icon on the right side.
- Card 3: Label "Pendapatan Bulan Ini" (text-sm font-medium text-slate-500), Value "Rp2.450.000" (text-2xl font-bold text-slate-800), with a small indigo banknote/currency icon on the right side.

=== MAIN SPLIT LAYOUT (2 Responsive Columns) ===
Use a grid: grid-cols-1 lg:grid-cols-5 gap-6 with padding.

--- LEFT COLUMN (lg:col-span-2): Input Form & Validation ---
- A card (bg-white rounded-xl shadow-sm border border-slate-200 p-6) with the title "Tambah Data Servis" (text-lg font-semibold text-slate-700 mb-4). When editing, this title changes to "Edit Data Servis" with an indigo left border accent.
- Form fields stacked vertically with gap-4:
  1. "No. Servis" — a read-only input field with bg-slate-100 text-slate-500, showing placeholder "SRV-20261115-001" and a small lock icon, indicating it is auto-generated.
  2. "Nama Pelanggan" — a text input (border-slate-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500) with placeholder "Masukkan nama pelanggan".
  3. "Nama Barang" — a text input with placeholder "Masukkan nama barang".
  4. "Keluhan" — a textarea (3 rows) with placeholder "Deskripsikan keluhan pelanggan".
  5. "Status" — a select/dropdown with options: Diterima, Diperiksa, Diproses, Selesai, Diambil. Default selected: "Diterima".
  6. "Estimasi Biaya (Rp)" — a number input with placeholder "0".
  7. "Biaya Akhir (Rp)" — a number input with placeholder "0".
  8. "Catatan Teknisi" — a textarea (2 rows) with placeholder "Catatan tambahan dari teknisi (opsional)".
- Below the form fields, show an **Alert Error Box** (initially visible for demo purposes): bg-rose-50 border border-rose-300 text-rose-700 rounded-lg p-4, with a red circle-exclamation icon on the left and the text "Biaya akhir harus lebih dari 0 jika status Selesai" in text-sm font-medium.
- Below the alert, two buttons side by side:
  1. Primary button: "Simpan" — bg-indigo-600 hover:bg-indigo-700 text-white font-semibold py-2.5 px-6 rounded-lg, full width.
  2. Secondary button: "Reset" — bg-slate-200 hover:bg-slate-300 text-slate-700 font-semibold py-2.5 px-4 rounded-lg.

--- RIGHT COLUMN (lg:col-span-3): Data Table, Search & Filter ---
- A card (bg-white rounded-xl shadow-sm border border-slate-200 p-6) with the title "Riwayat Data Servis" (text-lg font-semibold text-slate-700).
- Below the title, a row with two controls side by side:
  1. A search input (flex-1) with a magnifying glass icon inside, placeholder "Cari no. servis, nama pelanggan, atau barang...", border-slate-300 rounded-lg.
  2. A filter dropdown (w-48) with options: "Semua Status", Diterima, Diperiksa, Diproses, Selesai, Diambil.
- Below the controls, a responsive table (w-full) with:
  - Table header: bg-slate-50, text-xs font-semibold text-slate-500 uppercase tracking-wider. Columns: "No. Servis", "Pelanggan", "Barang", "Status", "Biaya Akhir", "Tanggal", "Aksi".
  - Table rows (show 3 sample rows with alternating subtle hover states hover:bg-slate-50):
    - Row 1: "SRV-20261110-001", "Ahmad Fauzi", "Laptop ASUS VivoBook 14", Status badge "Diproses" (bg-indigo-100 text-indigo-800 px-2.5 py-0.5 rounded-full text-xs font-medium), "Rp0", "10 Nov 2026", Action buttons.
    - Row 2: "SRV-20261112-001", "Siti Nurhaliza", "Printer Epson L3150", Status badge "Selesai" (bg-emerald-100 text-emerald-800 px-2.5 py-0.5 rounded-full text-xs font-medium), "Rp175.000", "12 Nov 2026", Action buttons.
    - Row 3: "SRV-20261115-001", "Budi Santoso", "HP Samsung Galaxy A54", Status badge "Diterima" (bg-blue-100 text-blue-800 px-2.5 py-0.5 rounded-full text-xs font-medium), "Rp0", "15 Nov 2026", Action buttons.
  - Each row's "Aksi" column has two small buttons:
    1. "Edit" — a small outlined button with a pencil icon, text-indigo-600 hover:bg-indigo-50 border border-indigo-200 rounded-md px-2 py-1 text-xs.
    2. "Hapus" — a small outlined button with a trash icon, text-rose-600 hover:bg-rose-50 border border-rose-200 rounded-md px-2 py-1 text-xs.
- Currency values formatted in Indonesian Rupiah (e.g., "Rp175.000").
- All labels and text should be in Bahasa Indonesia.

=== GENERAL STYLE NOTES ===
- Use the font "Plus Jakarta Sans" or "Inter" (sans-serif) for all text.
- Maintain consistent rounded-xl corners on all cards and rounded-lg on inputs and buttons.
- The overall color palette: slate for neutrals, indigo-600 for primary actions, emerald for success/completion, rose for errors/delete, blue for "Diterima", amber for "Diperiksa".
- Ensure the layout is fully responsive: on mobile, the two columns stack vertically (form on top, table below), and KPI cards stack vertically.
