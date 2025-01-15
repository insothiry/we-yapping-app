import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_yapping_app/src/screens/contacts/contacts_screen.dart';
import 'package:we_yapping_app/src/screens/contacts/new_contacts_screen.dart';
import 'package:we_yapping_app/src/screens/splashscreen/splash_screen.dart';
import 'package:we_yapping_app/src/services/socket_service.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      darkTheme: ThemeData.dark().copyWith(
        textTheme: Typography().white.apply(fontFamily: 'Work_Sans'),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black38,
          foregroundColor: Colors.white,
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
      home: const ContactsScreen(),
    );
  }
}
