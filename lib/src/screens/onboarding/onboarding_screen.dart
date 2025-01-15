import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:we_yapping_app/src/screens/login/login_screen.dart';
import 'package:we_yapping_app/src/screens/signup/signup_screen.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'package:we_yapping_app/src/widgets/base_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      if (_currentPage == 2) {
        _animationController.forward();
      } else {
        _animationController.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          // Logo
          Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.1,
              left: screenWidth * 0.2,
              right: screenWidth * 0.2,
            ),
            child: Image.asset(
              'assets/logos/image.png',
              height: screenHeight * 0.1,
            ),
          ),
          SizedBox(
            height: screenHeight * 0.5,
            width: double.infinity,
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                buildPage(
                  image: 'assets/images/onboarding1.jpg',
                  title: 'Welcome!',
                  description:
                      'Join us and explore a world of seamless communication.',
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
                buildPage(
                  image: 'assets/images/onboarding2.jpg',
                  title: 'Stay Connected!',
                  description:
                      'Experience messaging like never before, fast and simple.',
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
                buildPage(
                  image: 'assets/images/onboarding3.jpg',
                  title: 'Keep on Yapping!',
                  description:
                      'Chat instantly and yap with your friends effortlessly.',
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: const ExpandingDotsEffect(
              activeDotColor: BaseColor.primaryColor,
              dotColor: Colors.grey,
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 3,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1,
              vertical: screenHeight * 0.05,
            ),
            child: BaseButton(
              onPressed: () {
                if (_currentPage == 2) {
                  // Navigate to sign-up screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  );
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              text: _currentPage == 2 ? 'Sign Up with Phone number' : 'Next >>',
            ),
          ),
          // Animated "Already have an account?" text with sliding effect
          if (_currentPage == 2) ...[
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _animationController,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.off(() => const LoginScreen());
                        },
                        child: const Text(
                          "Login here",
                          style: TextStyle(
                            color: BaseColor.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildPage({
    required String image,
    required String title,
    required String description,
    required double screenHeight,
    required double screenWidth,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: screenHeight * 0.3,
          width: screenWidth * 0.8,
          fit: BoxFit.cover,
        ),
        SizedBox(height: screenHeight * 0.02),
        Text(
          title,
          style: TextStyle(
            fontSize: screenHeight * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: screenHeight * 0.02),
          ),
        ),
      ],
    );
  }
}
