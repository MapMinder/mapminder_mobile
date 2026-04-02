import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapminder_mobile/core/app_logger.dart';
import 'package:mapminder_mobile/core/external_http_client.dart';

class MapRepository {
  static MapRepository? _instance;

  factory MapRepository() {
    _instance ??= MapRepository._();
    return _instance!;
  }

  MapRepository._();

  final client = ExternalHttpClient(baseUrl: 'https://nominatim.openstreetmap.org');

  Future<String?> getLocationInformation(LatLng latLang) async {
    final double latitude = latLang.latitude;
    final double longitude = latLang.longitude;
    try{
      Response response = await client.dio.get(
        "/reverse",
        queryParameters: {"lat": latitude, "lon": longitude, "format": "json"},
      );
      // FIX: need to handle this properly are doing this just for the purposes of testing
      // TODO: add documentation on what nominatim is 
      // TODO: also add documentation on what the reverse geofencing is
      return response.data["display_name"];
    } catch (e, s) {
      AppLogger().error("Unexpected error occurred", e, s);
      throw Exception("Unexpected error occurred");
    }
  }
}
