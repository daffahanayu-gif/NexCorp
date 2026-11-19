const _bulanPendek = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
];

/// 1500000 -> "Rp 1.500.000"
String formatRupiah(num value) {
  final negatif = value < 0;
  final s = value.abs().round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return '${negatif ? '-' : ''}Rp $buf';
}

String _desimal(double x) =>
    x.toStringAsFixed(1).replaceAll('.', ',').replaceAll(RegExp(r',0$'), '');

/// 1250000000 -> "Rp 1,3 M", 250000000 -> "Rp 250 jt"
String formatRupiahRingkas(num value) {
  final a = value.abs().toDouble();
  final tanda = value < 0 ? '-' : '';
  if (a >= 1e12) return '${tanda}Rp ${_desimal(a / 1e12)} T';
  if (a >= 1e9) return '${tanda}Rp ${_desimal(a / 1e9)} M';
  if (a >= 1e6) return '${tanda}Rp ${_desimal(a / 1e6)} jt';
  return formatRupiah(value);
}

String formatTanggal(DateTime d) =>
    '${d.day} ${_bulanPendek[d.month - 1]} ${d.year}';

/// "2026-11" -> "Nov 2026" (format bulan_tahun disarankan: YYYY-MM)
String formatBulanTahun(String s) {
  final p = s.split('-');
  if (p.length != 2) return s;
  final m = int.tryParse(p[1]);
  if (m == null || m < 1 || m > 12) return s;
  return '${_bulanPendek[m - 1]} ${p[0]}';
}
