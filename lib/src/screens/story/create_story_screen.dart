import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'package:http/http.dart' as http;

class CreateStoryScreen extends StatefulWidget {
  final String userId;
  final String username;
  final String profilePic;

  const CreateStoryScreen({
    Key? key,
    required this.userId,
    required this.username,
    required this.profilePic,
  }) : super(key: key);

  @override
  _CreateStoryScreenState createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedMedia;
  bool isUploading = false;

  Future<void> _pickFromGallery() async {
    final media = await _picker.pickImage(source: ImageSource.gallery);
    if (media != null) {
      setState(() {
        _selectedMedia = media;
      });
    }
  }

  Future<void> _openCamera() async {
    final media = await _picker.pickImage(source: ImageSource.camera);
    if (media != null) {
      setState(() {
        _selectedMedia = media;
      });
    }
  }

  void _clearMedia() {
    setState(() {
      _selectedMedia = null;
    });
  }

  Future<void> postImageStory(
      String userId, String profilePic, String name, File mediaFile) async {
    String imageUrl = '';

    if (mediaFile != null) {
      try {
        setState(() => isUploading = true);

        // Generate a unique file name for the story image
        final fileName =
            'story_images/${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Upload the image to Supabase storage
        final storageResponse = await Supabase.instance.client.storage
            .from('we-yapping-images')
            .upload(fileName, mediaFile);

        // Get the public URL of the uploaded image
        final publicUrl = Supabase.instance.client.storage
            .from('we-yapping-images')
            .getPublicUrl(fileName);
        imageUrl = publicUrl;

        // Proceed to create the story with the uploaded image URL
        Get.snackbar('Success', 'Story uploaded successfully',
            snackPosition: SnackPosition.BOTTOM);

        // Reset uploading state
        setState(() => isUploading = false);

        // Call the method to send the new story data to your backend
        createStory(userId, profilePic, name, imageUrl);
      } catch (error) {
        // Handle upload failure
        Get.snackbar('Error', 'An error occurred while uploading image: $error',
            snackPosition: SnackPosition.BOTTOM);
        setState(() => isUploading = false);
      }
    }
  }

  void createStory(
      String userId, String profilePic, String name, String imageUrl) async {
    final newStory = {
      'user_id': userId,
      'profile_picture': profilePic,
      'name': name,
      'image': imageUrl,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/story/add-story'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newStory),
      );

      if (response.statusCode == 201) {
        // Successfully created the story
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Story created successfully!')),
        );
      } else {
        throw Exception('Failed to create story.');
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              if (_selectedMedia != null) {
                final file = File(_selectedMedia!.path);
                postImageStory(
                    widget.userId, widget.profilePic, widget.username, file);
              }
            },
            child: const Text(
              "Upload",
              style: TextStyle(color: BaseColor.primaryColor, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Media Preview
          _selectedMedia != null
              ? Image.file(
                  File(_selectedMedia!.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : const Center(
                  child: Text(
                    "No media selected",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
          // Bottom Delete Button
          if (_selectedMedia != null)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  iconSize: 30,
                  onPressed: _clearMedia,
                ),
              ),
            ),
          // Bottom Toolbar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: _openCamera,
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo, color: Colors.white),
                    onPressed: _pickFromGallery,
                  ),
                  IconButton(
                    icon: const Icon(Icons.text_fields, color: Colors.white),
                    onPressed: () {
                      print("Add text overlay");
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      print("Add drawing");
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.sticky_note_2, color: Colors.white),
                    onPressed: () {
                      print("Add sticker");
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
