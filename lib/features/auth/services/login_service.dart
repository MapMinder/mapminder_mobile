import 'package:mapminder_mobile/core/security_store.dart';
import 'package:mapminder_mobile/features/auth/repository/google_login_repository.dart';

class LoginServices {
  static LoginServices? _instance;

  factory LoginServices() {
    _instance ??= LoginServices._();
    return _instance!;
  }

  LoginServices._();
  final securityStorage = SecurityStore();
  final googleLoginRepository = GoogleLoginRepository();

  Future<bool> jwtTokenExists() async {
    try {
      String? jwtToken = await securityStorage.readData("jwt_token");
      if (jwtToken != null && jwtToken.isNotEmpty) {
        return true;
      }
      return false;
    } catch (error){
      throw Exception("Unexpected error occurred");
    }
  }

  Future<bool> isValidJwtToken() async {
    try {
      await googleLoginRepository.getUserInfo();
      return true;
    } catch (error) {
      return false;
    }
  }
}
