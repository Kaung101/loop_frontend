import 'dart:async'; //needed to use Timer to set default time for loading screen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/auth/login/login_view.dart';
import 'package:loop/components/bottomNavigation.dart';
import '../../components/colors.dart'; // Assuming this file defines your app colors

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = const FlutterSecureStorage();
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () => navigateToLogin(context));
  }
  Future<void> checkAuthStatus() async {
    String? token = await storage.read(key: 'jwt_token');
    if (token != null) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.backgroundColor,
    body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Handle potential image loading errors
                Image.asset(
                  'image/logo.png', 
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Error loading splash image'); // Placeholder
                  },
                ),
                const SizedBox(width: 10.0), // Add space between image and text
              ],
            ),
            const SizedBox(height: 20.0), // Add space between image and loading indicator
            const SizedBox(
              width: 30.0, // overall width and height for circular loading indicator
              height: 30.0,
              child: CircularProgressIndicator(
                strokeWidth: 1.0, //line thickness
                color: AppColors.tertiaryColor, //color of the indicator
              ),
            ), 
          ],
        ),
      ),
    ),
  );
}
  void navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  RepositoryProvider(
        create: (context) => AuthRepository(),
        child: isLoggedIn ? const BottomNav() : const LoginView(),
      )),
    );
  }
}
