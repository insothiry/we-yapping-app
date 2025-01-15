import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'package:we_yapping_app/src/widgets/settings_list_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  String selectedLanguage = "English";

  void _toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
    // Change the app's theme mode
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

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
            onPressed: () {
              Get.to(const SettingsScreen());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/avatar3.jpg'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Naksu In',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '@naksuin',
                    style: TextStyle(
                        fontSize: 18, color: textColor), // Using dynamic color
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
                    '+855 11 999 777',
                    style: TextStyle(
                        fontSize: 16, color: textColor), // Using dynamic color
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
                        child: Text(
                          language,
                          style: TextStyle(
                              color: textColor), // Using dynamic color
                        ),
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
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
