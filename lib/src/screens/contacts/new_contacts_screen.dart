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
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final List<TextEditingController> _phoneControllers = [TextEditingController()];
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  void _addPhoneField() {
    setState(() {
      _phoneControllers.add(TextEditingController());
    });
  }

  void _removePhoneField(int index) {
    setState(() {
      if (_phoneControllers.length > 1) {
        _phoneControllers.removeAt(index);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('At least one phone number is required')),
        );
      }
    });
  }

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

  void _createContact() {
    if (_firstNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('First Name is required')),
      );
      return;
    }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: BaseColor.primaryColor,
        toolbarHeight: 56.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            const Text(
              'New Contact',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
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
                      _removePhoneField(index);
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
            ),
            const SizedBox(height: 16.0),
            TextButton.icon(
              onPressed: _addPhoneField,
              icon: const Icon(Icons.add, color: BaseColor.backgroundColor),
              label: const Text('Add Phone', style: TextStyle(color: BaseColor.backgroundColor)),
            ),
          ],
        ),
      ),
    );
  }
}
