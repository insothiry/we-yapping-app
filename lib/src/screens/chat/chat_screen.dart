import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:we_yapping_app/src/screens/chat/user_profile_screen.dart';
import 'package:we_yapping_app/src/services/socket_service.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'package:we_yapping_app/src/widgets/base_chat_field.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ChatScreen extends StatefulWidget {
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String receiverAvatar;

  const ChatScreen({
    Key? key,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.receiverAvatar,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController messageController = TextEditingController();
  final SocketService socketService = SocketService();
  final ScrollController _scrollController = ScrollController();

  late String roomId;
  bool isTyping = false;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();

    print("contact receiver: ${widget.receiverAvatar}");

    // Generate a room ID by sorting the user IDs
    roomId = generateRoomId(widget.senderId, widget.receiverId);

    socketService.connect();

    // Join the room with the generated room ID
    socketService.joinRoom(roomId);
    print("Joined room: $roomId");

    fetchOldMessages();

    // Set the message receiver listener once in initState
    socketService.onMessageReceived = (message) {
      if (mounted && message['sender_id'] != widget.senderId) {
        setState(() {
          messages.add({
            "text": message['content'],
            "isUserMessage": false,
            "media":
                message['media']?.isNotEmpty == true ? message['media'] : null,
          });
        });
      }
      _scrollToBottom();
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

  void onTyping() {
    if (!isTyping) {
      socketService.typing(roomId);
    }
  }

  void onStopTyping() {
    if (isTyping) {
      socketService.stopTyping(roomId);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    socketService.socket.disconnect();
    super.dispose();
  }

  // Generate room ID by sorting the user IDs
  String generateRoomId(String userId1, String userId2) {
    List<String> userIds = [userId1, userId2];
    userIds.sort();
    return userIds.join('-');
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      final content = messageController.text;
      socketService.sendMessage(
          roomId,
          widget.senderId,
          widget.receiverId,
          content,
          '',
          widget.senderName,
          widget.receiverName,
          widget.receiverAvatar);
      print("Receiver avatar: " + widget.receiverAvatar);
      if (mounted) {
        setState(() {
          messages.add({"text": content, "isUserMessage": true});
        });
      }
      print("Sender name: ${widget.senderName}");
      _scrollToBottom();
      messageController.clear();
    }
  }

  Future<void> sendImage(String roomId, String senderId, String receiverId,
      String content, File mediaFile) async {
    String imageUrl = '';

    if (mediaFile != null) {
      try {
        setState(() => isUploading = true);
        _scrollToBottom();
        // Upload the image to Supabase Storage
        final fileName =
            'chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final storageResponse = await Supabase.instance.client.storage
            .from('we-yapping-images')
            .upload(fileName, mediaFile);

        // Get the public URL of the uploaded image
        final publicUrl = Supabase.instance.client.storage
            .from('we-yapping-images')
            .getPublicUrl(fileName);
        imageUrl = publicUrl;
      } catch (error) {
        // Handle upload failure
        Get.snackbar('Error', 'An error occurred while uploading image: $error',
            snackPosition: SnackPosition.BOTTOM);
        print(error);
        return;
      }
    }

    try {
      print("Image url: $imageUrl");
      // Send the message with or without media
      socketService.sendMessage(roomId, senderId, receiverId, content, imageUrl,
          widget.senderName, widget.receiverName, widget.receiverAvatar);

      if (mounted) {
        setState(() {
          messages.add({
            "text": content,
            "isUserMessage": true,
            "media": imageUrl.isNotEmpty ? imageUrl : null,
          });
          isUploading = false;
        });
      }
    } catch (e) {
      print("Error uploading image: $e");
      setState(() => isUploading = false);
      Get.snackbar('Error', 'An error occurred while sending message: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> sendFile(String roomId, String senderId, String receiverId,
      String content, File mediaFile) async {
    String fileUrl = '';

    if (mediaFile != null) {
      try {
        setState(() => isUploading = true);
        _scrollToBottom();
        // Upload the image to Supabase Storage
        final fileName =
            'chat_files/${DateTime.now().millisecondsSinceEpoch}.pdf';
        final storageResponse = await Supabase.instance.client.storage
            .from('we-yapping-images')
            .upload(fileName, mediaFile);

        // Get the public URL of the uploaded image
        final publicUrl = Supabase.instance.client.storage
            .from('we-yapping-images')
            .getPublicUrl(fileName);
        fileUrl = publicUrl;
      } catch (error) {
        // Handle upload failure
        Get.snackbar('Error', 'An error occurred while uploading image: $error',
            snackPosition: SnackPosition.BOTTOM);
        print(error);
        return;
      }
    }

    try {
      print("File url: $fileUrl");
      // Send the message with or without media
      socketService.sendMessage(roomId, senderId, receiverId, content, fileUrl,
          widget.senderName, widget.receiverName, widget.receiverAvatar);

      if (mounted) {
        setState(() {
          messages.add({
            "text": content,
            "isUserMessage": true,
            "media": fileUrl.isNotEmpty ? fileUrl : null,
          });
          isUploading = false;
        });
      }
    } catch (e) {
      print("Error uploading image: $e");
      setState(() => isUploading = false);
      Get.snackbar('Error', 'An error occurred while sending message: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchOldMessages() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/messages/$roomId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Data $data");

        // Check if 'data' is a list
        if (data['data'] is List) {
          List<Map<String, dynamic>> fetchedMessages =
              List<Map<String, dynamic>>.from(
            data['data'].map((message) => {
                  "text": message['content'],
                  "isUserMessage": message['sender_id'] == widget.senderId,
                  // Handle media as a string (URL or empty string)
                  "media": message['media']?.isNotEmpty == true
                      ? message['media']
                      : null,
                }),
          );
          print("Fetched messages: $fetchedMessages");
          setState(() {
            messages.insertAll(0, fetchedMessages);
          });
        } else {
          print("Expected a list, but got: ${data['data']}");
        }
      } else {
        print("Error fetching messages: ${response.body}");
      }
    } catch (e) {
      print("Error fetching old messages: $e");
    }
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // Sending the selected image
      sendImage(roomId, widget.senderId, widget.receiverId, '', imageFile);
      return imageFile;
    }
    return null;
  }

  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      sendFile(roomId, widget.senderId, widget.receiverId, '', file);
      return file;
    }
    return null;
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
                  widget.receiverName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isTyping)
                  const Text(
                    'Typing...',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  )
                else
                  const Text(
                    'Last seen recently',
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
                      userName: widget.receiverName,
                      lastSeen: 'Last seen recently',
                      profileImage: widget.receiverAvatar,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.receiverAvatar),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12.0),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isUserMessage = message['isUserMessage'];

              return Align(
                alignment: isUserMessage
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: message['media'] != null
                    ? _buildMediaMessage(message['media'], isUserMessage)
                    : _buildTextMessage(message['text'], isUserMessage),
              );
            },
          )),
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
                  onPressed: () {
                    pickFile();
                  },
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

Widget _buildMediaMessage(String mediaUrl, bool isUserMessage) {
  final fileName = Uri.parse(mediaUrl).pathSegments.last;
  final isImage = mediaUrl.toLowerCase().endsWith('.jpg') ||
      mediaUrl.toLowerCase().endsWith('.jpeg') ||
      mediaUrl.toLowerCase().endsWith('.png');

  return GestureDetector(
    onTap: () async {
      try {
        // Open the file when clicked
        await openNetworkFile(mediaUrl);
      } catch (e) {
        print("Error opening file: $e");
        Get.snackbar(
          'Error',
          'Unable to open the file.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isUserMessage ? BaseColor.primaryColor : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: isImage
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                mediaUrl,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 80),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.insert_drive_file,
                    size: 40,
                    color:
                        isUserMessage ? Colors.white : BaseColor.primaryColor),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    fileName,
                    style: TextStyle(
                      color: isUserMessage ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    ),
  );
}

Future<void> openNetworkFile(String fileUrl) async {
  try {
    // Download the file
    final response = await http.get(Uri.parse(fileUrl));

    if (response.statusCode == 200) {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/file.pdf';
      final file = File(filePath);

      // Write the file content to a local file
      await file.writeAsBytes(response.bodyBytes);

      // Open the file using open_file package
      final result = await OpenFile.open(filePath);

      if (result.type != ResultType.done) {
        // Handle failure to open the file
        print('Failed to open the file.');
      }
    } else {
      print('Failed to download the file: ${response.statusCode}');
    }
  } catch (e) {
    print('Error opening file: $e');
  }
}

Widget _buildTextMessage(String text, bool isUserMessage) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      color: isUserMessage ? BaseColor.primaryColor : Colors.grey[300],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: isUserMessage ? Colors.white : Colors.black87,
        fontSize: 16,
      ),
    ),
  );
}
