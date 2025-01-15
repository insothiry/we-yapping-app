import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:we_yapping_app/src/utils/base_colors.dart';

class NewContactScreen extends StatefulWidget {
  const NewContactScreen({super.key});

  @override
  State<NewContactScreen> createState() => _NewContactScreenState();
}

class _NewContactScreenState extends State<NewContactScreen> {
  // Controllers for the first name, last name, and phone numbers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final List<TextEditingController> _phoneControllers = [TextEditingController()];

  // Variables for handling image selection
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Adds a new phone field
  void _addPhoneField() {
    setState(() {
      _phoneControllers.add(TextEditingController());
    });
  }

  // Handles image selection from the gallery
  Future<void> _selectImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  // Creates a new contact and navigates back with the contact data
  void _createContact() {
    if (_firstNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('First Name is required')),
      );
      return;
    }

    // Gather phone numbers from controllers
    final phoneNumbers = _phoneControllers
        .map((controller) => controller.text.trim())
        .where((phone) => phone.isNotEmpty)
        .toList();

    if (phoneNumbers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one phone number is required')),
      );
      return;
    }

    try {
      final newContact = {
        'name': '${_firstNameController.text} ${_lastNameController.text}'.trim(),
        'phones': phoneNumbers,
        'image': _selectedImage?.path,
        'color': Colors.blue, // Default color
        'status': 'Hey there! I am using We Yapping App!', // Default status
      };

      Navigator.pop(context, newContact); // Pass the contact back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating contact: $e')),
      );
    }
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    for (var controller in _phoneControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: BaseColor.primaryColor,
        toolbarHeight: 56.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            // Title
            const Text(
              'New Contact',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            // Save button
            TextButton(
              onPressed: _createContact,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Image selection widget
                Center(
                  child: GestureDetector(
                    onTap: _selectImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                      child: _selectedImage == null
                          ? const Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Add Photo',
                  style: TextStyle(color: BaseColor.secondaryColor),
                ),
                const SizedBox(height: 16.0),

                // Input fields for first and last name
                TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                const SizedBox(height: 16.0),

                // Phone number fields with a dismissible feature
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _phoneControllers.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key('phone_field_$index'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        final removedController = _phoneControllers.removeAt(index);
                        setState(() {
                          // Update UI immediately
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Phone field removed')),
                        );
                        removedController.dispose(); // Prevent memory leaks
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _phoneControllers[index],
                              decoration: const InputDecoration(
                                labelText: 'Phone',
                                prefixIcon: Icon(Icons.phone),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),

                // Add phone button
                TextButton.icon(
                  onPressed: _addPhoneField,
                  icon: const Icon(Icons.add, color: BaseColor.primaryColor),
                  label: const Text('Add Phone', style: TextStyle(color: BaseColor.primaryColor)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
