import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:we_yapping_app/src/screens/chat/user_profile_screen.dart';
import 'package:we_yapping_app/src/services/socket_service.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'package:we_yapping_app/src/widgets/base_chat_field.dart';

class GroupChatScreen extends StatefulWidget {
  final String senderId;
  final String roomId;
  final String groupPhoto;
  final String groupName;

  const GroupChatScreen({
    Key? key,
    required this.senderId,
    required this.roomId,
    required this.groupPhoto,
    required this.groupName,
  }) : super(key: key);

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController messageController = TextEditingController();
  final SocketService socketService = SocketService();

  late String roomId;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();

    // Generate a room ID by sorting the user IDs
    roomId = widget.roomId;

    socketService.connect();

    // Join the room with the generated room ID
    socketService.joinRoom(roomId);
    print("Joined room: $roomId");

    // Set the message receiver listener once in initState
    socketService.onMessageReceived = (message) {
      if (mounted && message['sender_id'] != widget.senderId) {
        setState(() {
          messages.add({"text": message['content'], "isUserMessage": false});
        });
      }
    };

    socketService.onTyping = (data) {
      if (mounted) {
        setState(() {
          isTyping = true;
        });
      }
    };

    socketService.onStopTyping = (data) {
      if (mounted) {
        setState(() {
          isTyping = false;
        });
      }
    };
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      final content = messageController.text;
      socketService.sendGroupMessage(roomId, widget.senderId, content, '');
      if (mounted) {
        setState(() {
          messages.add({"text": content, "isUserMessage": true});
        });
      }
      messageController.clear();
    }
  }

  Future<void> sendImage(
      String roomId, String senderId, String content, File mediaFile) async {}

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // Sending the selected image
      sendImage(roomId, widget.senderId, 'Image sent', imageFile);
      return imageFile;
    }
    return null;
  }

  void onTyping() {
    socketService.typing(roomId);
  }

  void onStopTyping() {
    socketService.stopTyping(roomId);
  }

  @override
  void dispose() {
    socketService.socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.groupName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '3 members',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileScreen(
                      userName: widget.groupName,
                      lastSeen: 'Last seen recently',
                      profileImage: widget.groupPhoto,
                    ),
                  ),
                );
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    'https://i.ytimg.com/vi/5F1nUDz1CPY/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLBjJ4Gtvy8ShWy8V3pzEPTNj5uZzQ'),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message['isUserMessage'];

                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isUserMessage
                          ? BaseColor.primaryColor
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: message['media'] != null
                        ? Image.memory(
                            base64Decode(message['media']),
                            fit: BoxFit.cover,
                          )
                        : Text(
                            message['text'],
                            style: TextStyle(
                              color:
                                  isUserMessage ? Colors.white : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
          if (isTyping)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Typing...'),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file,
                      color: BaseColor.primaryColor),
                  onPressed: () {},
                ),
                IconButton(
                  onPressed: () {
                    pickImage();
                  },
                  icon: const Icon(Icons.camera_alt,
                      color: BaseColor.primaryColor),
                ),
                BaseChatField(messageController: messageController),
                IconButton(
                  icon: const Icon(Icons.send, color: BaseColor.primaryColor),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
