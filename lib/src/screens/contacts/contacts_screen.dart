import 'package:flutter/material.dart';
import 'new_contacts_screen.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';
import 'dart:io';
import 'dart:math';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
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
    {
      'name': 'Thoeun Pisethta',
      'phones': ['012846888'],
      'image': 'assets/images/avatar7.jpg',
    },
    {
      'name': 'Mam Sovanratana',
      'phones': ['012570906'],
      'image': 'assets/images/avatar6.jpg',
    },
    {
      'name': 'Pok Tepvignou',
      'phones': ['012559886'],
      'image': 'assets/images/avatar8.jpg',
    },
  ];

  String _searchQuery = "";
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _sortContacts();
  }

  void _addContact(Map<String, dynamic> newContact) {
    setState(() {
      _contacts.add(newContact);
    });
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  final _random = Random();
  Color _generateRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

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
    final filteredContacts = _contacts.where((contact) {
      final name = contact['name'] as String;
      final phones = (contact['phones'] as List).join(', '); // Combine phone numbers into a string
      final searchTarget = name.toLowerCase() + phones.toLowerCase();
      return searchTarget.contains(_searchQuery.toLowerCase());
    }).toList();

    final Map<String, List<Map<String, dynamic>>> groupedContacts = {};
    for (var contact in filteredContacts) {
      String initial = (contact['name'] as String).substring(0, 1).toUpperCase();
      groupedContacts.putIfAbsent(initial, () => []).add(contact);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BaseColor.primaryColor,
        centerTitle: true,
        title: const Text(
          'Contacts',
          style: TextStyle(
            color: BaseColor.backgroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
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
          Expanded(
            child: ListView(
              children: [
                ...groupedContacts.entries.map((entry) {
                  final initial = entry.key;
                  final contacts = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            final contactIndex =
                            _contacts.indexOf(contact);
                            _deleteContact(contactIndex);
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
