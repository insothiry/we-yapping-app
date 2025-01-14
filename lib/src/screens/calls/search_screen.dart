import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class SearchScreen extends StatefulWidget {
  final List<Map<String, dynamic>> callLogs;

  const SearchScreen({super.key, required this.callLogs});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  List<Map<String, dynamic>> filteredCallLogs = [];

  @override
  void initState() {
    super.initState();
    // Initially, show all call logs
    filteredCallLogs = widget.callLogs;
  }

  void _filterSearchResults(String input) {
    setState(() {
      query = input;
      if (query.isEmpty) {
        filteredCallLogs = widget.callLogs;
      } else {
        filteredCallLogs = widget.callLogs
            .where((call) =>
                call['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search...",
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: Colors.white),
          ),
          onChanged: _filterSearchResults,
        ),
      ),
      body: filteredCallLogs.isEmpty
          ? const Center(
              child: Text(
                "No results found",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: filteredCallLogs.length,
              itemBuilder: (context, index) {
                final call = filteredCallLogs[index];
                final DateTime callTime = DateTime.parse(call["time"]);

                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                      child: Image.network(
                        call["imageUrl"],
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                  title: Text(
                    call["name"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      if (call["status"] == "missed")
                        const Icon(Icons.call_missed,
                            color: Colors.red, size: 16),
                      if (call["status"] == "declined")
                        const Icon(Icons.call_end, color: Colors.red, size: 16),
                      if (call["status"] == "received")
                        const Icon(Icons.call_received,
                            color: Colors.green, size: 16),
                      if (call["status"] == "outgoing")
                        const Icon(Icons.call_made,
                            color: Colors.purple, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        DateFormat('hh:mm a').format(callTime),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.phone, color: Colors.green),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.videocam, color: Colors.blue),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
