import 'package:flutter/material.dart';

class BaseSearchBar extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;

  const BaseSearchBar({
    Key? key,
    this.hintText = "Search...",
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine current theme brightness
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          onChanged: onChanged,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle:
                TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
            prefixIcon: Icon(
              Icons.search,
              color: isDarkMode ? Colors.white70 : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
