import 'package:dio/dio.dart';

class ExternalHttpClient {
  final String baseUrl;
  late final Dio dio;

  ExternalHttpClient({required this.baseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'User-Agent': 'MapMinder/1.0.0 (iOS/Android)',
        }
      ),
    );
  }
}
