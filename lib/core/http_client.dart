import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapminder_mobile/core/security_store.dart';

class HttpClient {
  static HttpClient? _instance;

  factory HttpClient() {
    _instance ??= HttpClient._();
    return _instance!;
  }

  final dio = Dio(BaseOptions(
      baseUrl: dotenv.get('LOCAL_BASE_URL')
  ));
  final securityStorage = SecurityStore();

  HttpClient._() {
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handlers) async {
          final jwtToken = await securityStorage.readData("jwt_token");
          if(jwtToken != null) {
            options.headers["Authorization"] = "Bearer $jwtToken";
          }
          handlers.next(options);
        }
    ));
  }
}
