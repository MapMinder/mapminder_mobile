import 'package:mapminder_mobile/features/login/services/login_service.dart';

class SplashScreenController {
  static SplashScreenController? _instance;

  factory SplashScreenController() {
    _instance ??= SplashScreenController._();
    return _instance!;
  }

  SplashScreenController._();

  final loginServices = LoginServices();

  Future<bool> loginRequired() async {
    try{
      bool tokenExists = await loginServices.jwtTokenExists();
      if (!tokenExists) {
        return true;
      }
      bool isValidJwtToken = await loginServices.isValidJwtToken();
      if (!isValidJwtToken) {
        return true;
      }
      return false;
    } catch (error) {
      throw Exception("Unexpected error occurred");
    }
  }
}
