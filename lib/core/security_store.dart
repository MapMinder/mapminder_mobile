import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityStore {
  static SecurityStore? _instance;

  factory SecurityStore() {
    _instance ??= SecurityStore._();
    return _instance!;
  }

  SecurityStore._();
  final storage = FlutterSecureStorage();

  Future<void> writeData(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> readData(String key) async {
    String? value = await storage.read(key: key);
    return value;
  }

  Future<void> deleteData(String key) async {
    return await storage.delete(key: key);
  }
}
