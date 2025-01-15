import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:we_yapping_app/src/screens/bottom_navigation/bottom_navigation.dart';
import 'dart:io';
import 'package:we_yapping_app/src/widgets/base_button.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'package:http/http.dart' as http;

class CreateAccountScreen extends StatefulWidget {
  final String phoneNumber;
  const CreateAccountScreen({super.key, required this.phoneNumber});

  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();
}

class CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  File? _profileImage;

  // Function to pick the image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> createUser(String firstName, String? lastName,
      File? profileImage, String username, String phoneNumber) async {
    String? imageUrl;

    if (profileImage != null) {
      try {
        // Upload the image to Supabase Storage
        final fileName =
            'profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final storageResponse = await Supabase.instance.client.storage
            .from('we-yapping-images')
            .upload(fileName, profileImage);

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
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'profileImage': imageUrl, // Store the image URL here
          'username': username,
          'phoneNumber': phoneNumber,
        }),
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final String userId = responseBody['data']['userId'];
        print("User ID: $userId");

        // Save userId to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', userId);

        // Navigate to BottomNavigation
        Get.offAll(() => BottomNavigation(userId: userId));
      } else {
        Get.snackbar('Error', 'Failed to create account: ${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (error) {
      Get.snackbar('Error', 'An error occurred: $error',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  child: ClipOval(
                    child: _profileImage != null
                        ? Image.file(
                            _profileImage!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.add_a_photo, size: 30),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // First Name Field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("First Name (required)"),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintText: 'Jungkook',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        color: BaseColor.primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Last Name Field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Last Name (optional)"),
              ),
              const SizedBox(height: 5),

              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintText: 'Jeon',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        color: BaseColor.primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 20),

              // Username Field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Username (required)"),
              ),
              const SizedBox(height: 5),

              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Jungkook1997',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        color: BaseColor.primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username is required';
                  }
                  // Regular expression to allow only letters and numbers
                  final RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
                  if (!regex.hasMatch(value)) {
                    return 'Username can only contain letters and numbers';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Create Account Button
              BaseButton(
                text: 'Create Account',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (widget.phoneNumber.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Phone number is required",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                    } else {
                      createUser(
                        _firstNameController.text,
                        _lastNameController.text,
                        _profileImage,
                        _usernameController.text,
                        widget.phoneNumber,
                      );
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
