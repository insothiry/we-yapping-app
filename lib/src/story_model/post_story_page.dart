import 'package:flutter/material.dart';
import 'package:we_yapping_app/src/utils/story_state.dart';

class PostStoryPage extends StatelessWidget {
  final String imagePath;

  PostStoryPage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.5), // Transparent circle style
          ),
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Close the page and navigate back
            },
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16), // Adjust the space as needed
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        imagePath, // Use the provided image path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16), // Adjust the space as needed
          Container(
            padding: EdgeInsets.all(8)
                .copyWith(bottom: 64), // Adds extra padding to the bottom
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.person, color: Colors.white),
                  label:
                      Text('Your Story', style: TextStyle(color: Colors.white)),
                ),
                // Update the arrow button in post_story_page.dart
                // In post_story_page.dart
                // In post_story_page.dart
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {
                    // Mark the story for the specific user
                    StoryState.userStories.value = {
                      ...StoryState.userStories.value,
                      "Thiry":
                          imagePath, // Replace "Thiry" with the dynamic current user's name
                    };

                    // Navigate back to the ChatListScreen
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
