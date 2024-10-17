import 'package:flutter/material.dart';
import 'package:we_yapping_app/src/screens/splashscreen/splash_screen.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Work_Sans',
        colorScheme: ColorScheme.fromSeed(seedColor: BaseColor.primaryColor),
        useMaterial3: true,
      ),
      // Set SplashScreen as the initial screen
      home: const SplashScreen(),
    );
  }
}
