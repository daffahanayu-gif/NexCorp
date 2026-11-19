import '../auth/sesi_pengguna.dart';
import '../data/dummy_store.dart';
import 'api_client.dart';

/// Kontrak login. Layar hanya bergantung pada kelas ini.
abstract class AuthRepository {
  Future<SesiPengguna> login(String email, String password); // POST /api/login
}

/// Login dummy: email dicocokkan dengan data pengguna dummy Dev 3.
class DummyAuthRepository implements AuthRepository {
  static const passwordDemo = 'password123';

  @override
  Future<SesiPengguna> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final s = DummyStore.instance;
    final cocok = s.pengguna.where((u) => u.email.toLowerCase() == email.trim().toLowerCase());
    if (cocok.isEmpty || password != passwordDemo) {
      throw ApiException('Email atau password salah');
    }
    final u = cocok.first;
    if (u.isCeo) return SesiPengguna(pengguna: u);
    final dep = s.departemen.firstWhere((d) => d.id == u.idDepartemen);
    final pt = s.perusahaan.firstWhere((p) => p.id == dep.idPerusahaan);
    return SesiPengguna(
      pengguna: u,
      idPerusahaan: pt.id,
      namaPt: pt.namaPt,
      namaDepartemen: dep.namaDepartemen,
    );
  }
}

class ApiAuthRepository implements AuthRepository {
  @override
  Future<SesiPengguna> login(String email, String password) async {
    final data = await ApiClient.request(
      'POST',
      '/login',
      body: {'email': email, 'password': password},
      gagal: 'Email atau password salah',
    );
    if (data is! Map<String, dynamic>) throw ApiException('Respons login tidak valid.');
    return SesiPengguna.fromJson(data);
  }
}
