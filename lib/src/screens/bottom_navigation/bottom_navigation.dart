import 'package:flutter/material.dart';
import 'package:we_yapping_app/src/screens/calls/call_list_screen.dart';
import 'package:we_yapping_app/src/screens/chat/chat_list_screen.dart';
import 'package:we_yapping_app/src/screens/contacts/contacts_screen.dart';
import 'package:we_yapping_app/src/screens/settings/settings_screen.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  // List of widgets to display in each tab
  final List<Widget> _widgetOptions = <Widget>[
    const ContactsScreen(),
    ChatListScreen(),
    CallListScreen(),
    SettingsScreen(),
  ];

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: BaseColor.primaryColor,
      ),
    );
  }
}
