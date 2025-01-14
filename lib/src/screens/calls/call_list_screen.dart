import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'search_screen.dart';

class CallListScreen extends StatelessWidget {
  const CallListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> callLogs = [
      {
        "name": "Team Align",
        "time": "2025-01-09T12:00:00.000Z",
        "type": "voice",
        "status": "missed",
        "imageUrl": "https://randomuser.me/api/portraits/men/1.jpg"
      },
      {
        "name": "Jhon Abraham",
        "time": "2025-01-09T08:00:00.000Z",
        "type": "voice",
        "status": "outgoing",
        "imageUrl": "https://randomuser.me/api/portraits/men/2.jpg"
      },
      {
        "name": "Sabila Sayma",
        "time": "2025-01-08T10:00:00.000Z",
        "type": "video",
        "status": "declined",
        "imageUrl": "https://randomuser.me/api/portraits/women/3.jpg"
      },
      {
        "name": "Alice Cooper",
        "time": "2025-01-08T07:00:00.000Z",
        "type": "voice",
        "status": "received",
        "imageUrl": "https://randomuser.me/api/portraits/women/10.jpg"
      },
      {
        "name": "Michael Smith",
        "time": "2025-01-08T06:00:00.000Z",
        "type": "video",
        "status": "missed",
        "imageUrl": "https://randomuser.me/api/portraits/men/11.jpg"
      },
      {
        "name": "John Borino",
        "time": "2023-12-20T09:30:00.000Z",
        "type": "voice",
        "status": "outgoing",
        "imageUrl": "https://randomuser.me/api/portraits/men/5.jpg"
      },
      {
        "name": "Emily Clark",
        "time": "2025-01-06T23:00:00.000Z",
        "type": "video",
        "status": "declined",
        "imageUrl": "https://randomuser.me/api/portraits/women/6.jpg"
      },
      {
        "name": "Marcus Lee",
        "time": "2025-01-06T20:00:00.000Z",
        "type": "voice",
        "status": "received",
        "imageUrl": "https://randomuser.me/api/portraits/men/7.jpg"
      },
      {
        "name": "Sophia Turner",
        "time": "2023-12-15T14:45:00.000Z",
        "type": "video",
        "status": "outgoing",
        "imageUrl": "https://randomuser.me/api/portraits/women/8.jpg"
      },
      {
        "name": "David Morgan",
        "time": "2023-12-18T10:30:00.000Z",
        "type": "voice",
        "status": "missed",
        "imageUrl": "https://randomuser.me/api/portraits/men/9.jpg"
      },
      {
        "name": "Julia Roberts",
        "time": "2025-01-09T13:00:00.000Z",
        "type": "video",
        "status": "received",
        "imageUrl": "https://randomuser.me/api/portraits/women/11.jpg"
      },
      {
        "name": "Mark Anthony",
        "time": "2025-01-09T11:00:00.000Z",
        "type": "voice",
        "status": "outgoing",
        "imageUrl": "https://randomuser.me/api/portraits/men/12.jpg"
      }
    ];

    String formatDate(DateTime date) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));

      if (date.isAfter(today)) return "Today";
      if (date.isAfter(yesterday)) return "Yesterday";
      return DateFormat('EEEE, dd/MM/yyyy').format(date);
    }

    final Map<String, List<Map<String, dynamic>>> groupedCallLogs = {};
    for (var call in callLogs) {
      final DateTime callTime = DateTime.parse(call["time"]);
      final dateKey = formatDate(callTime);
      groupedCallLogs.putIfAbsent(dateKey, () => []).add(call);
    }

    final sortedDateKeys = groupedCallLogs.keys.toList()
      ..sort((a, b) {
        if (a == "Today") return -1;
        if (b == "Today") return 1;
        if (a == "Yesterday") return -1;
        if (b == "Yesterday") return 1;

        DateTime dateA = DateFormat('EEEE, dd/MM/yyyy').parse(a);
        DateTime dateB = DateFormat('EEEE, dd/MM/yyyy').parse(b);
        return dateB.compareTo(dateA);
      });

    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 100,
        title: const Text(
          "Calls",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(
              left: 16.0,
              top: 12.0,
              bottom: 12.0), // Increases padding on the left side
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(callLogs: callLogs),
                  ),
                );
              },
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(
                right: 16.0,
                top: 12.0,
                bottom: 12.0), // Increases padding on the right side
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(Icons.call, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: sortedDateKeys.isEmpty
            ? const Center(
                child: Text(
                  "No call history available",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: sortedDateKeys.length,
                itemBuilder: (context, index) {
                  final dateKey = sortedDateKeys[index];
                  final calls = groupedCallLogs[dateKey]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          dateKey,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Column(
                        children: calls.map((call) {
                          final callTime = DateTime.parse(call["time"]);

                          return Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey[300],
                                  child: ClipOval(
                                    child: Image.network(
                                      call["imageUrl"],
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                                    Icon(
                                      call["status"] == "missed"
                                          ? Icons.call_missed
                                          : call["status"] == "declined"
                                              ? Icons.call_end
                                              : call["status"] == "received"
                                                  ? Icons.call_received
                                                  : Icons.call_made,
                                      color: call["status"] == "missed" ||
                                              call["status"] == "declined"
                                          ? Colors.red
                                          : call["status"] == "received"
                                              ? Colors.green
                                              : Colors.purple,
                                      size: 16,
                                    ),
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
                                      icon: const Icon(
                                        Icons.phone,
                                        color: Colors.green,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.videocam,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Colors.grey,
                                height: 1,
                                thickness: 0.5,
                                indent: 75,
                                endIndent: 20,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
