import 'package:flutter/material.dart';
import 'package:we_yapping_app/src/screens/calls/call_list_screen.dart';
import 'package:we_yapping_app/src/screens/chat/chat_list_screen.dart';
import 'package:we_yapping_app/src/screens/contacts/contacts_screen.dart';
import 'package:we_yapping_app/src/screens/settings/settings_screen.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';

class BottomNavigation extends StatefulWidget {
  final String userId;

  const BottomNavigation({Key? key, required this.userId}) : super(key: key);

  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  // List of widgets to display in each tab
  List<Widget> _widgetOptions() {
    return <Widget>[
      ContactsScreen(userId: widget.userId),
      ChatListScreen(
        userId: widget.userId,
      ),
      CallListScreen(),
      SettingsScreen(userId: widget.userId),
    ];
  }

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
        children: _widgetOptions(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.people, 0),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.chat_rounded, 1),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.phone, 2),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(Icons.settings, 3),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: BaseColor.primaryColor,
      ),
    );
  }

  // Build animated icon with scaling effect
  Widget _buildAnimatedIcon(IconData icon, int index) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Icon(
        icon,
        key: ValueKey<int>(_selectedIndex == index ? 1 : 0),
        color: _selectedIndex == index ? BaseColor.primaryColor : Colors.grey,
        size: _selectedIndex == index ? 24 : 20,
      ),
    );
  }
}
