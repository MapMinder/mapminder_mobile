import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginInServices {
  static GoogleLoginInServices? _instance;

  factory GoogleLoginInServices() {
    _instance ??= GoogleLoginInServices._();
    return _instance!;
  }

  final GoogleSignIn signIn = GoogleSignIn.instance;
  GoogleLoginInServices._() {
    signIn.initialize();
  }

  // signInWithGoogle() get google's idToken that is required to register or create JWT token
  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount account = await signIn.authenticate();
      final auth = account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        throw Exception("Failed to authenticate user");
      }
      return idToken;
    } on GoogleSignInException catch (e) {
      throw Exception("error occurred while login with google. ${e.code}");
    } catch (error)  {
      throw Exception("Unexpected error occurred");
    }
  }
}
