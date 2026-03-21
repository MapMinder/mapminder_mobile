
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mapminder_mobile/core/security_store.dart';
import 'package:mapminder_mobile/features/login/repository/google_login_repository.dart';
import 'package:mapminder_mobile/features/login/services/interfaces/oauth_login_services.dart';

class GoogleLoginServices implements OauthLoginServices {
  static GoogleLoginServices? _instance;

  factory GoogleLoginServices() {
    _instance ??= GoogleLoginServices._();
    return _instance!;
  }

  final GoogleSignIn signIn = GoogleSignIn.instance;
  GoogleLoginServices._() {
    signIn.initialize();
  }
  final googleLoginRepository = GoogleLoginRepository();
  final securityStorage = SecurityStore();

  // signInWithGoogle() get google's idToken that is required to register or create JWT token
  @override
  Future<void> login() async {
    try {
      final GoogleSignInAccount account = await signIn.authenticate();
      final auth = account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        throw Exception("Failed to authenticate user");
      }
      final jwtToken = await googleLoginRepository.login(idToken);
      await securityStorage.writeData("jwt_token", jwtToken);
    } on GoogleSignInException catch (e) {
      throw Exception("error occurred while login with google. ${e.code}");
    } catch (error)  {
      throw Exception("Unexpected error occurred");
    }
  }
}
