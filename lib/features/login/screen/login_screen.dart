import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mapminder_mobile/features/login/services/google_login_in_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final googleLoginServices = GoogleLoginServices();

  void loginInWithGoogle() async {
    try {
      await googleLoginServices.login();
      if (!mounted) return;
      Navigator.pushNamed(context, "/map");
    } on GoogleSignInException catch(e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return;
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong.. Could you retry again')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "MAPMINDER",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            SizedBox(height: 20),
            // TODO: add actual google and apple icons for the buttons
            ElevatedButton.icon(
              onPressed: loginInWithGoogle,
              style: ElevatedButton.styleFrom(
                       fixedSize: const Size(250, 50)
                     ),
              icon: Icon(Icons.add),
              label: const Text(
                "Sign in with GOOGLE",
                style: TextStyle(color: Colors.black),
                )
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/map');
              }, 
              style: ElevatedButton.styleFrom(
                       fixedSize: const Size(250, 50)
                     ),
              icon: Icon(Icons.add),
              label: const Text(
                "Sign in with APPLE",
                style: TextStyle(color: Colors.black),
                )
            ),
          ],
        ),
      ),
    );
  }
}
