import 'package:mapminder_mobile/core/google_auth_client.dart';
import 'package:mapminder_mobile/core/security_store.dart';

class LogoutService {
  static LogoutService? _instance;

  factory LogoutService() {
    _instance ??= LogoutService._();
    return _instance!;
  }

  LogoutService._();
  final securityStorage = SecurityStore();
  final googleClient = GoogleAuthClient();

  Future<void> logout() async {
    await securityStorage.deleteData("jwt_token");
    await googleClient.signOut();
  }
}
