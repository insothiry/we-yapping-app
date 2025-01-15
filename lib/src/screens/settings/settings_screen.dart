import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:we_yapping_app/src/screens/login/login_screen.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'package:we_yapping_app/src/widgets/settings_list_tile.dart';
import 'dart:convert';

class SettingsScreen extends StatefulWidget {
  final String userId;

  const SettingsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  String selectedLanguage = "English";
  String username = '';
  String phoneNumber = '';
  String profileImage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

// Load user data based on userId
  Future<void> _loadUserData() async {
    print("WTF is user id 3 :  ${widget.userId}");
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/users/getUser/${widget.userId}'),
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      print(" Hi $userData");
      setState(() {
        username = userData['data']['username'] ?? 'Unknown';
        phoneNumber = userData['data']['phoneNumber'] ?? 'Unknown';
        profileImage = userData['data']['profileImage'] ??
            'https://i.ytimg.com/vi/5F1nUDz1CPY/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLBjJ4Gtvy8ShWy8V3pzEPTNj5uZzQ';
      });
    } else {
      print('Failed to load user data');
    }
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
    // Change the app's theme mode
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  // Function to logout
  Future<void> logout() async {
    bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != null && shouldLogout) {
      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/api/users/logout'),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          print('Logout successful!');
          Get.offAll(const LoginScreen());
        } else {
          print('Logout failed');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyText1?.color ?? Colors.black;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 35,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.qr_code,
            color: BaseColor.primaryColor,
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Edit',
              style: TextStyle(color: BaseColor.primaryColor, fontSize: 16),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: profileImage.isNotEmpty
                    ? NetworkImage(profileImage)
                    : const AssetImage('assets/images/avatar3.jpg')
                        as ImageProvider,
              ),
              const SizedBox(height: 16),
              Text(
                username.isNotEmpty ? username : 'N/A',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '@$username',
                    style: TextStyle(fontSize: 18, color: textColor),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    phoneNumber.isNotEmpty ? phoneNumber : 'N/A',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              SettingsListTile(
                  icon: Icons.save, title: 'Saved Messages', onTap: () {}),
              const Divider(),
              SettingsListTile(
                  icon: Icons.devices, title: 'Devices', onTap: () {}),
              const Divider(),
              SettingsListTile(
                  icon: Icons.key, title: 'Change Password', onTap: () {}),
              const Divider(),
              SettingsListTile(
                  icon: Icons.notifications,
                  title: 'Notifications and Sounds',
                  onTap: () {}),
              const Divider(),
              SettingsListTile(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: _toggleDarkMode,
                ),
                onTap: () {
                  _toggleDarkMode(!isDarkMode);
                },
              ),
              const Divider(),
              SettingsListTile(
                icon: Icons.language,
                title: 'Language',
                trailing: DropdownButton<String>(
                  value: selectedLanguage,
                  icon: const Icon(Icons.arrow_drop_down, size: 20),
                  items: <String>['English', 'Khmer'].map((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text(language, style: TextStyle(color: textColor)),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLanguage = newValue!;
                    });
                  },
                ),
              ),
              const Divider(),
              SettingsListTile(
                icon: Icons.logout,
                title: 'Logout',
                titleColor: Colors.red,
                iconColor: Colors.red,
                onTap: logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
