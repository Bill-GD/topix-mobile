import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:topix/utils/extensions.dart' show NumDurationExtensions;

enum TokenType { access, refresh }

class TokenService {
  final FlutterSecureStorage _storage;

  TokenService(this._storage);

  Future<void> writeToken(TokenType type, String value, int ageInSeconds) async {
    final key = switch (type) {
      .access => '_at',
      .refresh => '_rt',
    };

    await _storage.write(
      key: key,
      value: value,
      aOptions: AndroidOptions(resetOnError: true),
    );
    await _storage.write(
      key: '${key}Time',
      value: '${DateTime.now().add(ageInSeconds.seconds).millisecondsSinceEpoch}',
      aOptions: AndroidOptions(resetOnError: true),
    );
  }

  Future<String?> tryGet(TokenType type) async {
    final key = switch (type) {
      .access => '_at',
      .refresh => '_rt',
    };

    final expireTimestamp = int.tryParse(await _storage.read(key: '${key}Time') ?? '0') ?? 0;
    if (expireTimestamp < DateTime.now().millisecondsSinceEpoch) {
      return null;
    }

    return _storage.read(key: key);
  }
}
