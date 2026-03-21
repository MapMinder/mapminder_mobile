import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapminder_mobile/features/login/screen/login_screen.dart';
import 'package:mapminder_mobile/features/map/screen/map_screen.dart';
import 'package:mapminder_mobile/features/splash_screen/screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  runApp(const MapMinder());
}

class MapMinder extends StatelessWidget {
  const MapMinder({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MapMinder',
      theme: ThemeData(),
      // TODO: this should be decided with environment variables
      // eg: if production the debugShowCheckedModeBanner should be false else true
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/map': (context) => const MapScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
