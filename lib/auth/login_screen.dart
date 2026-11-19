import 'package:flutter/material.dart';

import '../app_dependencies.dart';
import '../manager_portal/manager_home.dart';
import '../services/api_client.dart';
import '../services/auth_repository.dart';

/// Login: role Manajer -> ManagerHome. Role CEO -> `deps.ceoPortalBuilder` bila tersedia.
class LoginScreen extends StatefulWidget {
  final AppDependencies deps;
  const LoginScreen({super.key, required this.deps});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _loading = false;
  bool _sembunyi = true;
  String? _error;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final sesi = await widget.deps.auth.login(_emailC.text.trim(), _passC.text);
      if (!mounted) return;
      _passC.clear();
      if (sesi.isCeo) {
        final ceo = widget.deps.ceoPortalBuilder;
        if (ceo == null) {
          setState(() => _error = 'Akun CEO memakai Portal CEO. Aplikasi ini khusus Manajer Anak Perusahaan.');
          return;
        }
        // push (bukan replace): tombol kembali di portal CEO = keluar ke login.
        await Navigator.push(context, MaterialPageRoute(builder: ceo));
      } else {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ManagerHome(sesi: sesi, deps: widget.deps)),
        );
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Terjadi kesalahan. Coba lagi.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _isiDemo(String email) {
    _emailC.text = email;
    _passC.text = DummyAuthRepository.passwordDemo;
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.apartment_rounded, size: 64, color: tema.colorScheme.primary),
                  const SizedBox(height: 12),
                  Text('Holding Corp Hub',
                      textAlign: TextAlign.center,
                      style: tema.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Masuk sebagai Manajer Anak Perusahaan',
                      textAlign: TextAlign.center, style: tema.textTheme.bodySmall),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: _emailC,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final s = v?.trim() ?? '';
                      if (s.isEmpty) return 'Email wajib diisi';
                      if (!s.contains('@')) return 'Format email tidak valid';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passC,
                    obscureText: _sembunyi,
                    onFieldSubmitted: (_) => _login(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_sembunyi ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _sembunyi = !_sembunyi),
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: TextStyle(color: tema.colorScheme.error), textAlign: TextAlign.center),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _loading ? null : _login,
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: _loading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Masuk'),
                  ),
                  if (widget.deps.modeDemo) ...[
                    const SizedBox(height: 24),
                    Text('Mode demo (password: ${DummyAuthRepository.passwordDemo})',
                        textAlign: TextAlign.center, style: tema.textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      children: [
                        ActionChip(label: const Text('Nusantara Tech'), onPressed: () => _isiDemo('rina@nusantaratech.id')),
                        ActionChip(label: const Text('Maju Logistik'), onPressed: () => _isiDemo('bagas@majulogistik.id')),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
