import 'package:flutter/material.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        leading: TextButton(
          child: const Text(
            'Sort',
            style: TextStyle(color: BaseColor.primaryColor),
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                color: BaseColor.primaryColor,
              ))
        ],
      ),
      body: const Column(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: SearchBar(
            elevation: MaterialStatePropertyAll(1),
            backgroundColor:
                MaterialStatePropertyAll(BaseColor.backgroundColor),
            hintText: 'Search',
            leading: Icon(
              Icons.search,
            ),
          ),
        )
      ]),
    );
  }
}
