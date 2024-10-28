import 'package:flutter/material.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'package:we_yapping_app/src/widgets/base_search_bar.dart';
import 'package:we_yapping_app/src/widgets/story_profile.dart';

class ChatListScreen extends StatelessWidget {
  // Sample chat data
  final List<Map<String, String>> chats = [
    {
      'name': 'Cyrax Johnson',
      'message': 'Hey! How\'s it going?',
      'time': '2:30 PM',
      'avatar': 'assets/images/avatar1.jpg'
    },
    {
      'name': 'Naksu Smith',
      'message': 'Let\'s catch up tomorrow.',
      'time': '1:15 PM',
      'avatar': 'assets/images/avatar2.jpg'
    },
    {
      'name': 'Charlie Brown', // Fixed name typo here
      'message': 'Got the meeting notes!',
      'time': '12:00 PM',
      'avatar': 'assets/images/avatar3.jpg'
    },
    {
      'name': 'Jungkook Prince',
      'message': 'See you at the event.',
      'time': '11:45 AM',
      'avatar': 'assets/images/avatar4.jpg'
    },
    // Add more chat data as needed
  ];

  final List<Map<String, String>> stories = [
    {'name': 'Cyrax Johnson', 'avatar': 'assets/images/avatar1.jpg'},
    {'name': 'Naksu Smith', 'avatar': 'assets/images/avatar2.jpg'},
    {
      'name': 'Charlie Brown',
      'avatar': 'assets/images/avatar3.jpg'
    }, // Fixed name typo here
    // Add more users as needed
  ];

  ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            // Add action for edit button
          },
          child: const Text(
            'Edit',
            style: TextStyle(color: BaseColor.primaryColor, fontSize: 16),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Chats',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/story.png',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // Action for the story icon button
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/icons/add-chat.png',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // Action for the add chat icon button
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stories Section
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: StoryProfile(
                      avatar: "assets/images/avatar5.jpg",
                      name: "Thiry",
                      isOwner: true,
                    ),
                  );
                }
                final story = stories[index - 1];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StoryProfile(
                    avatar: story['avatar']!,
                    name: story['name']!,
                  ),
                );
              },
            ),
          ),

          const BaseSearchBar(),
          const SizedBox(height: 5),
          const Divider(),

          // Chat List Section
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ChatListItem(
                  name: chat['name']!,
                  message: chat['message']!,
                  time: chat['time']!,
                  avatar: chat['avatar']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String avatar;

  const ChatListItem({
    Key? key,
    required this.name,
    required this.message,
    required this.time,
    required this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(avatar),
            radius: 25,
          ),
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            message,
            style: const TextStyle(color: Colors.black54),
          ),
          trailing: Text(
            time,
            style: const TextStyle(color: Colors.grey),
          ),
          onTap: () {
            // Navigate to chat screen or perform any action
          },
        ),
        const Divider(
          indent: 80,
          height: 1,
          color: Colors.black12,
        )
      ],
    );
  }
}
