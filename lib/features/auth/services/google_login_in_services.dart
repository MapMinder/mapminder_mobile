import 'package:google_sign_in/google_sign_in.dart';
import 'package:mapminder_mobile/core/app_logger.dart';
import 'package:mapminder_mobile/core/google_auth_client.dart';
import 'package:mapminder_mobile/core/security_store.dart';
import 'package:mapminder_mobile/features/auth/repository/google_login_repository.dart';
import 'package:mapminder_mobile/features/auth/services/interfaces/oauth_login_services.dart';

class GoogleLoginServices implements OauthLoginServices {
  static GoogleLoginServices? _instance;

  factory GoogleLoginServices() {
    _instance ??= GoogleLoginServices._();
    return _instance!;
  }

  GoogleLoginServices._();
  
  // repositories
  final googleLoginRepository = GoogleLoginRepository();

  // dependencies
  final googleClient = GoogleAuthClient();
  final securityStorage = SecurityStore();

  // signInWithGoogle() get google's idToken that is required to register or create JWT token
  @override
  Future<void> login() async {
    try {
      final GoogleSignInAccount account = await googleClient.authenticate();
      final auth = account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        AppLogger().error("Failed to authenticate user", null, null);
        throw Exception("Failed to authenticate user");
      }
      final jwtToken = await googleLoginRepository.login(idToken);
      await securityStorage.writeData("jwt_token", jwtToken);
    } on GoogleSignInException catch (e, s) {
      AppLogger().error("error occurred while login with google.", e, s);
      rethrow;
    } catch (e, s)  {
      AppLogger().error("error occurred while login with google.", e, s);
      throw Exception("Unexpected error occurred");
    }
  }
}
