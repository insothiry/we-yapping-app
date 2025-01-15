import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:we_yapping_app/src/screens/splashscreen/splash_screen.dart';
import 'package:we_yapping_app/src/services/socket_service.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(
      url: 'https://fscjilkdmrvexbvtmtud.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZzY2ppbGtkbXJ2ZXhidnRtdHVkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY3MzU5NTcsImV4cCI6MjA1MjMxMTk1N30.h8S0uFxHFltpqsDgi7pCKVq1GS96BJhPQhC7a-DCvHc',
    );
    print('Supabase initialized successfully');
  } catch (e) {
    print('Error initializing Supabase: $e');
  }

  final socketService = SocketService();
  socketService.connect();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'We Yapping App',
      theme: ThemeData(
        fontFamily: 'Work_Sans',
        brightness: Brightness.light,
        useMaterial3: true,
        dividerColor: Colors.black12,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Work_Sans',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black45,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueGrey, // Primary color for dark theme
          onPrimary: Colors.white, // Color for text/icon on primary color
          secondary: BaseColor.primaryColor,
          onSecondary: Colors.white, // Color for text/icon on secondary color
          error: Colors.redAccent, // Error color for dark theme
          onError: Colors.white, // Color for text/icon on error color
          background: Colors.black45, // Background color for dark theme
          onBackground: Colors.white, // Color for text on background
          surface: Colors.grey, // Surface color for components
          onSurface: Colors.white, // Color for text/icon on surface
        ),
        dividerColor: Colors.white, // Divider color for dark theme
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
