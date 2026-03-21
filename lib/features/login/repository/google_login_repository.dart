import 'package:dio/dio.dart';
import 'package:mapminder_mobile/core/http_client.dart';
import 'package:mapminder_mobile/features/login/dto/login_dto.dart';
import 'package:mapminder_mobile/features/login/repository/interfaces/oauth_login_repository.dart';
import 'package:mapminder_mobile/features/login/domain/user.dart';

class GoogleLoginRepository implements OauthLoginRepository {
  static GoogleLoginRepository? _instance;

  factory GoogleLoginRepository() {
    _instance ??= GoogleLoginRepository._();
    return _instance!;
  }

  GoogleLoginRepository._();
  final client = HttpClient();

  @override
  Future<String> login(String idToken) async {
    try {
      final request = GoogleLoginRequest(idToken: idToken);
      Response response = await client.dio.post(
        "/auth/google",
        data: request.toJson(),
      );
      return response.data["result"];
    } on DioException catch (e) {
      throw Exception("error occurred while calling the backend. ${e.error}");
    } catch (error) {
      throw Exception("Unexpected error occurred");
    }
  }

  @override
  Future<User> getUserInfo() async {
    try {
      Response response = await client.dio.get("/user/me");
      User user = User.fromJson(response.data["result"]);
      return user;
    } on DioException catch (e) {
      throw Exception("error occurred while calling the backend. ${e.error}");
    } catch (error){
      throw Exception("Unexpected error occurred");
    }
  }
}
