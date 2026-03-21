import 'package:flutter/material.dart';
import 'package:mapminder_mobile/features/splash_screen/controller/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashScreenController = SplashScreenController();

  @override
  void initState(){
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    bool loginRequired = await splashScreenController.loginRequired();
    if (!mounted) return;
    if (loginRequired) {
      Navigator.pushNamed(context, "/login");
    } else {
      Navigator.pushNamed(context, "/map");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "MAPMINDER",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          )
        ),
      ),
    );
  }
}
