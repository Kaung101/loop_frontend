import 'dart:async'; //needed to use Timer to set default time for loading screen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/auth/login/login_view.dart';
import 'package:loop/components/bottomNavigation.dart';
import 'package:loop/onbarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/colors.dart'; // Assuming this file defines your app colors

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = const FlutterSecureStorage();
  bool isLoggedIn = false;
  bool isFirstTime = false;
  @override
  void initState() {
    super.initState();
    checkAuthStatus();
  }
   Future<void> checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('isFirstTimeUser') ?? true;
    String? token = await storage.read(key: 'jwtToken');

    setState(() {
      isFirstTime = firstTime;
      isLoggedIn = token != null;
      print(isLoggedIn);
      print("is login");
    });

    Timer(const Duration(seconds: 2), () {
      navigateToNextScreen(context);
    });
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
                SvgPicture.asset(
                  'image/loop_logo.svg', 
                  // errorBuilder: (context, error, stackTrace) {
                  //   return const Text('Error loading splash image'); // Placeholder
                  // },
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
void navigateToNextScreen(BuildContext context) {
    if (isFirstTime) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingView()),
      );
    } 
    // else if (isLoggedIn) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const BottomNav()),
    //   );
    // }
     else {
      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RepositoryProvider(
                          create: (context) => AuthRepository(),
                          child: const LoginView(),
                        ),
                      ),
                    );
    }
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
