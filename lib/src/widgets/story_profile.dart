import 'package:flutter/material.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';

class StoryProfile extends StatelessWidget {
  final String avatar;
  final String name;
  final bool isOwner;
  final VoidCallback onTap;

  const StoryProfile({
    Key? key,
    required this.avatar,
    required this.name,
    required this.onTap,
    this.isOwner = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: BaseColor.primaryColor,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(avatar),
                  radius: 30,
                ),
              ),
              if (isOwner)
                Positioned(
                  bottom: -15,
                  right: -15,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/icons/add-story.png',
                      width: 20,
                      height: 20,
                    ),
                    onPressed: () {
                      // Add action for the add button
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 60,
            child: Text(
              name,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
