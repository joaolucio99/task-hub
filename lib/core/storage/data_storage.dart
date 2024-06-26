import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DataStorage {
  FlutterSecureStorage get _instance => const FlutterSecureStorage();

  Future<void> deleteAll() => _instance.deleteAll();

  Future<bool> contains(String key) => _instance.containsKey(key: key);

  Future<String?> read(String key) => _instance.read(key: key);

  Future<Map<String, String>> readAll() => _instance.readAll();

  Future<void> delete(String key) => _instance.delete(key: key);

  Future<void> write(String key, String value) =>
      _instance.write(key: key, value: value);
}
