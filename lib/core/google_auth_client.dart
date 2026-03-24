import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthClient {
  static GoogleAuthClient? _instance;

  factory GoogleAuthClient() {
    _instance ??= GoogleAuthClient._();
    return _instance!;
  }

  final GoogleSignIn auth = GoogleSignIn.instance;

  GoogleAuthClient._() {
    auth.initialize();
  }

  Future<GoogleSignInAccount> authenticate() async {
    return await auth.authenticate();
  }

  Future<void> signOut() async {
    return await auth.signOut();
  }

}
