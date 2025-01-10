import 'package:flutter/material.dart';
import 'package:we_yapping_app/src/story_model/add_to_story.dart';
import 'package:we_yapping_app/src/story_model/view_story_page.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'package:we_yapping_app/src/utils/story_state.dart';

class StoryProfile extends StatelessWidget {
  final String avatar;
  final String name;
  final bool isOwner;
  final bool hasPostedStory; // Add a flag to indicate if a story is posted

  const StoryProfile({
    Key? key,
    required this.avatar,
    required this.name,
    this.isOwner = false,
    this.hasPostedStory = false, // Default to false
  }) : super(key: key);

  // In story_profile.dart
  // In story_profile.dart
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, String?>>(
      valueListenable: StoryState.userStories,
      builder: (context, userStories, _) {
        final storyPath = userStories[name]; // Get the story for this user

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                if (storyPath != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewStoryPage(storyPath: storyPath),
                    ),
                  );
                }
              },
              child: Stack(
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
                      backgroundImage: AssetImage(avatar),
                      radius: 30,
                    ),
                  ),
                  if (isOwner && storyPath == null)
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddToStoryPage(),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
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
        );
      },
    );
  }
}
