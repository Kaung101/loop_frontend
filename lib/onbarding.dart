import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop/auth/auth_repo.dart';
import 'package:loop/auth/login/login_view.dart';
import 'package:loop/components/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  void completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTimeUser', false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: [
          buildOnboardingPage(
            'image/Asset 1.png', // Replace with your actual image asset paths
            "Don't Toss It, Transform It",
            "Waste management and resource conservation are critical issues today. Traditional waste disposal methods contribute to pollution, habitat destruction, and climate change. Our app empowers you to reduce waste and conserve resources.",
          ),
          buildOnboardingPage(
            'image/Asset 2.png', // Replace with your actual image asset paths
            "Support Sustainable Development",
            "Our app aligns with the UN SDGs, promoting sustainable economic growth, responsible consumption, and climate action. By connecting with artists to upcycle items, you contribute to a more sustainable future.",
          ),
          buildOnboardingPage(
            'image/Asset 3.png', // Replace with your actual image asset paths
            "Join the Upcycling Revolution",
            "Reduce waste, conserve resources, and support artists. Create personalized upcycling projects, enjoy seamless communication, and be part of a thriving upcycling community.",
          ),
        ],
      ),
      bottomSheet: Container(
        color:
            AppColors.tertiaryColor, // Set your desired background color here
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: currentIndex == 2
            ? TextButton(
                onPressed: completeOnboarding,
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold), // Button text color
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentIndex == 0
                      ? const SizedBox()
                      : TextButton(
                          onPressed: () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          child: const Text(
                            "Previous",
                            style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.bold), // Button text color
                          ),
                        ),
                  TextButton(
                    onPressed: () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold), // Button text color
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildOnboardingPage(
      String assetPath, String title, String description) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetPath, height: 300),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
