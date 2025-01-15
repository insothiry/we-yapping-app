import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:we_yapping_app/src/screens/chat/chat_screen.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'package:we_yapping_app/src/widgets/base_search_bar.dart';

class ContactsScreen extends StatefulWidget {
  final String userId;

  const ContactsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<dynamic> contacts = [];
  List<dynamic> filteredContacts = [];
  bool isLoading = true;
  String? username = '';

  @override
  void initState() {
    super.initState();
    fetchContacts();
    _loadUserData();
  }

  // Load user data based on userId
  Future<void> _loadUserData() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/users/getUser/${widget.userId}'),
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      print(" Hi $userData");
      setState(() {
        username = userData['data']['username'] ?? 'Unknown';
      });
      print(" Hi username $username");
    } else {
      print('Failed to load user data');
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
          throw Exception('Unexpected response format.');
        }
      } else {
        throw Exception('Failed to load contacts: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching contacts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredContacts = contacts;
      } else {
        filteredContacts = contacts
            .where((contact) =>
                contact['firstName']
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                contact['lastName']
                    ?.toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void showCreateContactSheet() {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Top bar: Cancel, title, Create
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'New Contact',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () async {
                        final firstName = firstNameController.text.trim();
                        final lastName = lastNameController.text.trim();
                        final phoneNumber = phoneNumberController.text.trim();

                        if (firstName.isNotEmpty &&
                            lastName.isNotEmpty &&
                            phoneNumber.isNotEmpty) {
                          final newContact = {
                            'firstName': firstName,
                            'lastName': lastName,
                            'phoneNumber': phoneNumber,
                            'creator_user_id': widget.userId,
                            'profileImage': '',
                          };

                          try {
                            final response = await http.post(
                              Uri.parse(
                                  'http://localhost:3000/api/contacts/add-contacts/'),
                              headers: {'Content-Type': 'application/json'},
                              body: json.encode(newContact),
                            );

                            if (response.statusCode == 201) {
                              Navigator.pop(context);
                              fetchContacts();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Contact created successfully!'),
                                ),
                              );
                            } else {
                              throw Exception('Failed to create contact.');
                            }
                          } catch (e) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill out all fields.'),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Create',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Profile picture and fields
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Placeholder for profile picture functionality
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person,
                            size: 40, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          TextField(
                            controller: firstNameController,
                            decoration:
                                const InputDecoration(labelText: 'First Name'),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: lastNameController,
                            decoration:
                                const InputDecoration(labelText: 'Last Name'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showCreateContactSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Divider(color: Colors.grey[300], height: 1),
          BaseSearchBar(onChanged: filterContacts),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = filteredContacts[index];
                        final receiverId = contact['contact_user_id']?['_id'];
                        final receiverName =
                            '${contact['contact_user_id']?['firstName']} ${contact['contact_user_id']?['lastName']}';
                        final receiverAvatar = contact['contact_user_id']
                                ?['profileImage'] ??
                            'assets/images/avatar1.jpg';

                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(receiverAvatar),
                              ),
                              title: Text(
                                receiverName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(contact['phoneNumber']),
                              onTap: () {
                                Get.to(
                                  ChatScreen(
                                    senderId: widget.userId,
                                    receiverId: receiverId,
                                    receiverName: receiverName,
                                    receiverAvatar: receiverAvatar,
                                    senderName: username ?? 'unknown',
                                  ),
                                );
                              },
                            ),
                            Divider(
                              indent: 10,
                              endIndent: 10,
                              height: 1,
                              thickness: 1,
                              color: Colors.grey[400],
                            ),
                          ],
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
