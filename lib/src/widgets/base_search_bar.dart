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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 40, // Decreased height
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black54),
            prefixIcon: const Icon(Icons.search, // Search icon
                color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
