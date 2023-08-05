import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// {@template secure_storage}
///
/// {@endtemplate}
class SecureStorageRepository {
  final FlutterSecureStorage _secureStorage;
  SecureStorageRepository({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  Future<void> write({required String key, required String? value}) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> read({required String key}) async {
    return _secureStorage.read(key: key);
  }

  Future<void> delete({required String key, required String? value}) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> deleteAll({required String key, required String? value}) async {
    await _secureStorage.deleteAll();
  }
}
