import 'package:flutter/widgets.dart';

import 'services/auth_repository.dart';
import 'services/manager_repository.dart';

/// Kumpulan repository aplikasi (satu tempat untuk menukar dummy <-> API).
class AppDependencies {
  final AuthRepository auth;
  final ManagerRepository manager;
  final bool modeDemo;

  /// Opsional: diisi saat Portal CEO (Dev 3) digabung. Bila null, login dengan
  /// role CEO ditolak dengan pesan bahwa aplikasi ini khusus Manajer.
  final WidgetBuilder? ceoPortalBuilder;

  const AppDependencies({
    required this.auth,
    required this.manager,
    this.modeDemo = true,
    this.ceoPortalBuilder,
  });

  factory AppDependencies.dummy() => AppDependencies(
        auth: DummyAuthRepository(),
        manager: DummyManagerRepository(),
      );

  /// flutter run --dart-define=USE_API=true
  factory AppDependencies.api() => AppDependencies(
        auth: ApiAuthRepository(),
        manager: ApiManagerRepository(),
        modeDemo: false,
      );

  factory AppDependencies.fromEnvironment() =>
      const bool.fromEnvironment('USE_API') ? AppDependencies.api() : AppDependencies.dummy();
}
