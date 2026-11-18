/// Tabel `pengajuan_approval`. namaProyek, namaPt, namaPemohon berasal dari JOIN.
class PengajuanModel {
  final int _id;
  final int _idProyek;
  final int _idPemohon;
  final String _namaProyek;
  final String _namaPt;
  final String _namaPemohon;
  String _jenisPengajuan;
  double _nominal;
  String _catatan;
  String _statusApproval;

  PengajuanModel({
    required int id,
    required int idProyek,
    required int idPemohon,
    String namaProyek = '',
    String namaPt = '',
    String namaPemohon = '',
    required String jenisPengajuan,
    required double nominal,
    String catatan = '',
    String statusApproval = 'Pending',
  })  : _id = id,
        _idProyek = idProyek,
        _idPemohon = idPemohon,
        _namaProyek = namaProyek,
        _namaPt = namaPt,
        _namaPemohon = namaPemohon,
        _jenisPengajuan = jenisPengajuan,
        _nominal = nominal,
        _catatan = catatan,
        _statusApproval = statusApproval;

  int get id => _id;
  int get idProyek => _idProyek;
  int get idPemohon => _idPemohon;
  String get namaProyek => _namaProyek;
  String get namaPt => _namaPt;
  String get namaPemohon => _namaPemohon;
  String get jenisPengajuan => _jenisPengajuan;
  double get nominal => _nominal;
  String get catatan => _catatan;
  String get statusApproval => _statusApproval;

  set statusApproval(String val) {
    if (val == 'Pending' || val == 'Approved' || val == 'Rejected') {
      _statusApproval = val;
    }
  }

  bool get isPending => _statusApproval == 'Pending';

  factory PengajuanModel.fromJson(Map<String, dynamic> json) {
    return PengajuanModel(
      id: json['id'],
      idProyek: json['id_proyek'],
      idPemohon: json['id_pemohon'] ?? 0,
      namaProyek: json['nama_proyek'] ?? '',
      namaPt: json['nama_pt'] ?? '',
      namaPemohon: json['nama_pemohon'] ?? '',
      jenisPengajuan: json['jenis_pengajuan'] ?? '',
      nominal: double.tryParse(json['nominal'].toString()) ?? 0.0,
      catatan: json['catatan'] ?? '',
      statusApproval: json['status_approval'] ?? 'Pending',
    );
  }
}
