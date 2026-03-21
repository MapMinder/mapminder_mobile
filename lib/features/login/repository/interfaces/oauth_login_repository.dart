import 'package:mapminder_mobile/features/login/domain/user.dart';

abstract class OauthLoginRepository {
  Future<String> login(String idToken);
  Future<User> getUserInfo();
}
