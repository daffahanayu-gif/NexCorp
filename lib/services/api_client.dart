import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Error dari API/jaringan yang pesannya aman ditampilkan ke pengguna.
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

/// Klien HTTP tipis untuk repository berbasis API (JSON snake_case, respons
/// `{status, data}` / `{status:'error', message}` sesuai server Dev 2).
class ApiClient {
  /// Android Emulator -> 10.0.2.2; Web/desktop/iOS -> localhost.
  /// Override: flutter run --dart-define=API_URL=https://host/api
  static String get baseUrl {
    const override = String.fromEnvironment('API_URL');
    if (override.isNotEmpty) return override;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api';
    }
    return 'http://localhost:3000/api';
  }

  static const _headers = {'Content-Type': 'application/json'};
  static const _timeout = Duration(seconds: 15);

  /// Mengembalikan field `data` dari respons sukses (bisa Map, List, atau null).
  static Future<dynamic> request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
    String gagal = 'Permintaan gagal',
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    late http.Response res;
    try {
      final enc = body == null ? null : jsonEncode(body);
      switch (method) {
        case 'GET':
          res = await http.get(uri).timeout(_timeout);
        case 'POST':
          res = await http.post(uri, headers: _headers, body: enc).timeout(_timeout);
        case 'PUT':
          res = await http.put(uri, headers: _headers, body: enc).timeout(_timeout);
        case 'DELETE':
          res = await http.delete(uri).timeout(_timeout);
        default:
          throw ArgumentError(method);
      }
    } catch (_) {
      throw ApiException('Tidak dapat terhubung ke server ($baseUrl).');
    }

    dynamic decoded;
    try {
      decoded = res.body.isEmpty ? null : jsonDecode(res.body);
    } catch (_) {}

    if (res.statusCode < 200 || res.statusCode >= 300) {
      final msg = decoded is Map ? decoded['message'] : null;
      throw ApiException(msg is String && msg.isNotEmpty ? msg : '$gagal (HTTP ${res.statusCode})');
    }
    return decoded is Map ? decoded['data'] : decoded;
  }
}
