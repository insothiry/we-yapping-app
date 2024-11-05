import 'package:flutter/material.dart';

class BaseChatField extends StatelessWidget {
  const BaseChatField({
    super.key,
    required this.messageController,
  });

  final TextEditingController messageController;

  @override
  Widget build(BuildContext context) {
    // Determine the fill color based on the theme brightness
    Color fillColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]!
        : Colors.grey[200]!;
    Color hintTextColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.grey;
    return Flexible(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 150),
        child: TextField(
          controller: messageController,
          decoration: InputDecoration(
            hintText: 'Type a message...',
            hintStyle: TextStyle(color: hintTextColor),
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          maxLines: 10,
          minLines: 1,
          keyboardType: TextInputType.multiline,
        ),
      ),
    );
  }
}
