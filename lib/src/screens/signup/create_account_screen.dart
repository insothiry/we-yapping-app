import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_yapping_app/src/screens/bottom_navigation/bottom_navigation.dart';
import 'package:we_yapping_app/src/services/http_service.dart';
import 'dart:io';
import 'package:we_yapping_app/src/widgets/base_button.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';

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
                  backgroundColor: BaseColor.primaryColor.withOpacity(0.2),
                  radius: 50,
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.add_a_photo, size: 30)
                      : null,
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
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        color: BaseColor.primaryColor,
                        width: 2), // Base color on focus
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
                      Get.off(() => const BottomNavigation());
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
