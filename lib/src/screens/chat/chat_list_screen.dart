import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:we_yapping_app/src/screens/chat/chat_screen.dart';
import 'package:we_yapping_app/src/screens/chat/group_chat_screen.dart';
import 'package:we_yapping_app/src/screens/story/create_story_screen.dart';
import 'package:we_yapping_app/src/screens/story/story_screen.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'package:we_yapping_app/src/widgets/base_button.dart';
import 'package:we_yapping_app/src/widgets/base_search_bar.dart';
import 'package:we_yapping_app/src/widgets/story_profile.dart';

class ChatListScreen extends StatefulWidget {
  final String userId;

  const ChatListScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<dynamic> chats = [];
  List<dynamic> contacts = [];
  List<dynamic> filteredContacts = [];
  bool isLoading = true;
  String? userProfilePic;
  String? userFirstName;
  String? userLastName;
  String? username;

  @override
  void initState() {
    super.initState();
    fetchChatList();
    fetchContacts();
    fetchUserDetails();
  }

  // Future<void> fetchUserStory() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('http://localhost:3000/api/story/get-story/${widget.userId}'),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //     } else {
  //       throw Exception('Failed to load user');
  //     }
  //   } catch (e) {
  //     print('Error fetching user: $e');
  //     setState(() => isLoading = false);
  //   }
  // }

  Future<void> fetchUserDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/users/getUser/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          username = data['data']['username'];
          userFirstName = data['data']['firstName'];
          userLastName = data['data']['lastName'];
          userProfilePic = data['data']['profileImage'];
        });
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      print('Error fetching user: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchContacts() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:3000/api/contacts/contacts/${widget.userId}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data.containsKey('contacts')) {
          setState(() {
            contacts = data['contacts'];
            filteredContacts = contacts;
            isLoading = false;
          });
        } else {
          throw Exception('Contacts key not found in the response');
        }

        print("Whats the contact? : $contacts");
      } else {
        throw Exception('Failed to load contacts');
      }
    } catch (e) {
      print('Error fetching contacts: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchChatList() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:3000/api/chatList/getChatList?user_id=${widget.userId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Chat List Data: $data");

        if (data['data'] is List) {
          setState(() => chats = data['data']);
        } else {
          setState(() => chats = [data['data']]);
        }
      } else {
        print('Failed to load chat list');
      }
    } catch (e) {
      print('Error fetching chat list: $e');
    }
  }

  Future<void> _onRefresh() async {
    await fetchChatList();
  }

  final List<Map<String, String>> stories = [
    {
      'name': 'Cyrax Johnson',
      'avatar':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjLQOuhrDNslAWnZkwx4CeR56p4LhzWg_66w&s'
    },
    {
      'name': 'Naksu San',
      'avatar':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9WcG4yNLDY00D_PlvqUmEBaGLgaSvh8ildg&s'
    },
    {
      'name': 'Charlie Brown',
      'avatar':
          'https://media.themoviedb.org/t/p/w500/kZUO2s2ZsBRYZ8acu0wMzlGHpRS.jpg'
    },
  ];

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
              Get.to(() => CreateStoryScreen(
                    userId: widget.userId,
                    username: username ?? 'Unknown',
                    profilePic: userProfilePic ??
                        "https://w7.pngwing.com/pngs/177/551/png-transparent-user-interface-design-computer-icons-default-stephen-salazar-graphy-user-interface-design-computer-wallpaper-sphere-thumbnail.png",
                  ));
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/icons/add-chat.png',
              width: 24,
              height: 24,
            ),
            onPressed: () async {
              await fetchContacts();
              // ignore: use_build_context_synchronously
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: CreateGroupChatBottomSheet(
                    contacts: contacts,
                    userId: widget.userId,
                  ),
                ),
              );
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
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StoryProfile(
                      avatar: userProfilePic ??
                          "https://w7.pngwing.com/pngs/177/551/png-transparent-user-interface-design-computer-icons-default-stephen-salazar-graphy-user-interface-design-computer-wallpaper-sphere-thumbnail.png",
                      name: "${userFirstName ?? ' '} ${userLastName ?? ' '}",
                      isOwner: true,
                      onTap: () {
                        Get.to(const StoryScreen(
                          storyUrls: [
                            'https://img.freepik.com/premium-psd/seamless-random-instagram-story-collage_492486-145.jpg',
                            'https://pbs.twimg.com/media/Duf-DdCVYAAeuUc.jpg:large',
                            'https://static.vecteezy.com/system/resources/previews/030/318/024/non_2x/mountain-landscape-with-hiking-trail-and-view-of-beautiful-lakes-vertical-mobile-wallpaper-ai-generated-free-photo.jpg',
                          ],
                        ));
                      },
                    ),
                  );
                }
                final story = stories[index - 1];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StoryProfile(
                    avatar: story['avatar']!,
                    name: story['name']!,
                    onTap: () {
                      Get.to(const StoryScreen(
                        storyUrls: [
                          'https://preview.redd.it/230407-wonwoo-instagram-story-update-v0-70f45t72dhsa1.jpg?width=640&crop=smart&auto=webp&s=ba7f2ba643947cac5b065801ba55d8af4b24fb0a',
                          'https://pbs.twimg.com/media/FTiFyiWaMAEAXV9.jpg:large',
                          'https://preview.redd.it/240815-dk-instagram-story-updates-v0-2deoii91ztid1.jpg?width=640&crop=smart&auto=webp&s=a585f5fe64334f42aa1de515d47bcc7f3a905840',
                        ],
                      ));
                    },
                  ),
                );
              },
            ),
          ),
          const BaseSearchBar(),
          const SizedBox(height: 5),
          const Divider(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return ChatListItem(
                    userId: widget.userId,
                    username: username ?? 'unknown',
                    chat: chat,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateGroupChatBottomSheet extends StatefulWidget {
  final String userId;
  final List<dynamic> contacts;

  const CreateGroupChatBottomSheet({
    Key? key,
    required this.userId,
    required this.contacts,
  }) : super(key: key);

  @override
  _CreateGroupChatBottomSheetState createState() =>
      _CreateGroupChatBottomSheetState();
}

class _CreateGroupChatBottomSheetState
    extends State<CreateGroupChatBottomSheet> {
  String groupName = '';
  List<String> selectedContacts = [];
  final TextEditingController _groupNameController = TextEditingController();

  Future<void> onCreate() async {
    if (groupName.isEmpty || selectedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a group name and select members.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/groups/create-room'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'creator_id': widget.userId,
          'participants': selectedContacts,
          'isGroup': true,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        print('Group created: ${data['data']}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group created successfully.')),
        );
        final roomId = data['data']['room_id'];
        final groupName = _groupNameController.text;
        final participants = data['data']['participants'];
        final groupPhoto =
            'https://cdn.oneesports.gg/cdn-data/2023/11/MLBB_Odette_ButterflyGoddess_skin.jpg';
        Navigator.pop(context);
        Get.to(GroupChatScreen(
            senderId: widget.userId,
            roomId: roomId,
            groupPhoto: groupPhoto,
            groupName: groupName));
      } else {
        print('Failed to create group: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create group.')),
        );
      }
    } catch (e) {
      print('Error creating group: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error creating group.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Create Group Chat',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue[200],
            child: const Center(
              child: Text('G'),
            ),
          ),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Group Name (required)"),
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: _groupNameController,
            onChanged: (value) {
              setState(() {
                groupName = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Steav PP',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                    const BorderSide(color: BaseColor.primaryColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Group name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Select Members"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.contacts.length,
              itemBuilder: (context, index) {
                final contact = widget.contacts[index];
                final isSelected = selectedContacts.contains(contact['id']);
                return ListTile(
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(contact['profileImage'] ??
                            "https://i.pinimg.com/736x/54/6d/23/546d2322f91d0662ab2971862ea43cd7.jpg")),
                    title: Text(
                      '${contact['firstName'] ?? 'Unknown'} ${contact['lastName'] ?? 'Unknown'}',
                    ),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) {
                        if (value != null) {
                          setState(() {
                            if (value) {
                              if (!selectedContacts.contains(
                                  contact['contact_user_id']['_id'])) {
                                selectedContacts
                                    .add(contact['contact_user_id']['_id']);
                              }
                            } else {
                              // Remove the contact from the list
                              selectedContacts
                                  .remove(contact['contact_user_id']['_id']);
                            }
                          });
                          // Print the selected contacts list
                          print('Selected contacts: $selectedContacts');
                        }
                      },
                    ));
              },
            ),
          ),
          BaseButton(text: 'Create Group', onPressed: onCreate),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final String userId;
  final String username;
  final Map<String, dynamic> chat;

  const ChatListItem({
    Key? key,
    required this.username,
    required this.userId,
    required this.chat,
  }) : super(key: key);

  String formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final isGroup = chat['isGroup'] ?? false;

    final chatScreen = isGroup
        ? GroupChatScreen(
            senderId: userId,
            roomId: chat['room_id'] ?? '',
            groupPhoto: chat['profile_picture'] ?? '',
            groupName: chat['name'] ?? 'Group Chat',
          )
        : ChatScreen(
            senderId: userId,
            senderName: username,
            receiverId: chat['receiver_id'] ?? '',
            receiverName: chat['name'] ?? '',
            receiverAvatar: chat['profile_picture'] ?? '',
          );

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              chat['profile_picture'] ??
                  'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
            ),
            radius: 25,
          ),
          title: Text(
            chat['name'] ?? 'Unknown',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(chat['last_message'] ?? 'No message yet'),
          trailing: Text(
            formatTimestamp(
                chat['last_message_timestamp'] ?? 'No timestamp yet'),
            style: const TextStyle(color: Colors.grey),
          ),
          onTap: () {
            Get.to(chatScreen);
          },
        ),
        const Divider(indent: 80, height: 1),
      ],
    );
  }
}
