// Importing the Flutter Material package for UI components
import 'package:flutter/material.dart';

// Importing additional screens and utilities
import 'new_contacts_screen.dart'; // Custom screen for adding new contacts
import 'package:we_yapping_app/src/utils/base_colors.dart'; // Base colors for consistent styling

// Importing Dart packages for file handling and generating random values
import 'dart:io'; // For handling file paths and file-based images
import 'dart:math'; // For generating random colors

// Main Contacts screen widget
class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

// State for the ContactsScreen widget
class _ContactsScreenState extends State<ContactsScreen> {
  // List of predefined contacts
  final List<Map<String, dynamic>> _contacts = [
    {
      'name': 'Veiy Sokheng',
      'phones': ['0979294797'],
      'image': 'assets/images/avatar1.jpg',
    },
    {
      'name': 'In Sothiry',
      'phones': ['086605205'],
      'image': 'assets/images/avatar2.jpg',
    },
    // More predefined contacts...
  ];

  // Variables for search and sorting
  String _searchQuery = ""; // Tracks the search input from the user
  bool _isAscending = true; // Determines sorting order

  // Initialize state and sort contacts by default
  @override
  void initState() {
    super.initState();
    _sortContacts();
  }

  // Adds a new contact to the list
  void _addContact(Map<String, dynamic> newContact) {
    setState(() {
      _contacts.add(newContact);
    });
  }

  // Deletes a contact from the list by index
  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  // Generates a random color for contact avatars without an image
  final _random = Random();
  Color _generateRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  // Sorts the contacts list alphabetically
  void _sortContacts() {
    setState(() {
      _contacts.sort((a, b) {
        String nameA = a['name'].toString().toLowerCase();
        String nameB = b['name'].toString().toLowerCase();
        return _isAscending ? nameA.compareTo(nameB) : nameB.compareTo(nameA);
      });
      _isAscending = !_isAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filters contacts based on search query
    final filteredContacts = _contacts.where((contact) {
      final name = contact['name'] as String;
      final phones = (contact['phones'] as List).join(', ');
      final searchTarget = name.toLowerCase() + phones.toLowerCase();
      return searchTarget.contains(_searchQuery.toLowerCase());
    }).toList();

    // Groups contacts by the first letter of their names
    final Map<String, List<Map<String, dynamic>>> groupedContacts = {};
    for (var contact in filteredContacts) {
      String initial = (contact['name'] as String).substring(0, 1).toUpperCase();
      groupedContacts.putIfAbsent(initial, () => []).add(contact);
    }

    // UI for the ContactsScreen
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BaseColor.primaryColor, // Custom primary color
        centerTitle: true,
        title: const Text(
          'Contacts',
          style: TextStyle(
            color: BaseColor.backgroundColor, // Custom background color
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
        actions: [
          // Add new contact button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewContactScreen(),
                ),
              ).then((newContact) {
                if (newContact != null) {
                  _addContact(newContact);
                }
              });
            },
            icon: const Icon(Icons.person_add, color: Colors.white),
          ),
          // Sort contacts button
          IconButton(
            onPressed: _sortContacts,
            icon: Icon(
              _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Contacts list
          Expanded(
            child: ListView(
              children: [
                ...groupedContacts.entries.map((entry) {
                  final initial = entry.key;
                  final contacts = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Group header (initial)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Text(
                          initial,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      // List of contacts under the group
                      ...contacts.asMap().entries.map((entry) {
                        final index = entry.key;
                        final contact = entry.value;

                        return Dismissible(
                          key: ValueKey(contact['name']),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            final contactIndex = _contacts.indexOf(contact);
                            _deleteContact(contactIndex); // Deletes the contact
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 40,
                              backgroundImage: contact['image'] != null
                                  ? contact['image'].toString().startsWith('assets/')
                                  ? AssetImage(contact['image']) as ImageProvider
                                  : FileImage(File(contact['image']))
                                  : null,
                              backgroundColor: contact['image'] == null
                                  ? _generateRandomColor()
                                  : null,
                              child: contact['image'] == null
                                  ? Text(
                                (contact['name'] as String)[0],
                                style: const TextStyle(color: Colors.white),
                              )
                                  : null,
                            ),
                            title: Text(contact['name']),
                            subtitle: Text(
                              (contact['phones'] != null && contact['phones'].isNotEmpty)
                                  ? contact['phones'].join(', ')
                                  : contact['status'] ?? "No status",
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
