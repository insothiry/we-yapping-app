import 'package:flutter/material.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';

class SettingsListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? titleColor;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsListTile({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
    this.titleColor,
    this.iconColor,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? BaseColor.primaryColor),
      title: Text(
        title,
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 15),
      onTap: onTap,
    );
  }
}
