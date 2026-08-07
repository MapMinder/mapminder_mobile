import 'package:flutter/services.dart';

class MapStyleServices {
  static Future<String> loadDarkStyle() async {
        return await rootBundle.loadString('lib/features/map/assets/dark_map_style.json');
  }
}
