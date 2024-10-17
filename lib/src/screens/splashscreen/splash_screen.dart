import 'dart:async';

import 'package:flutter/material.dart';
import 'package:we_yapping_app/src/screens/onboarding/onboarding_screen.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to home screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColor.primaryColor,
      body: Center(
        child: Image.asset(
          'assets/logos/logo_white.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
