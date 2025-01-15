import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:we_yapping_app/src/screens/calls/call_screen.dart';

class CallListScreen extends StatefulWidget {
  const CallListScreen({super.key});

  @override
  _CallListScreenState createState() => _CallListScreenState();
}

class _CallListScreenState extends State<CallListScreen> {
  List<dynamic> callRecords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCallHistory();
  }

  Future<void> fetchCallHistory() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/calls/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data.containsKey('calls')) {
          setState(() {
            callRecords = data['calls'];
            isLoading = false;
          });
        } else {
          throw Exception('Invalid response format: "calls" key not found');
        }
      } else {
        throw Exception(
            'Failed to load call history (status code: ${response.statusCode})');
      }
    } catch (e) {
      print('Error fetching call history: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String getRandomCallType() {
    final callTypes = ['missed', 'outgoing', 'received'];
    return callTypes[DateTime.now().millisecondsSinceEpoch % callTypes.length];
  }

  IconData getCallIcon(String callType) {
    switch (callType) {
      case 'missed':
        return Icons.call_missed;
      case 'outgoing':
        return Icons.call_made;
      case 'received':
        return Icons.call_received;
      default:
        return Icons.phone;
    }
  }

  String getRandomDuration() {
    final randomMinutes = DateTime.now().second % 10 + 1;
    return '${randomMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call History'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : callRecords.isEmpty
              ? const Center(child: Text('No call history available.'))
              : ListView.builder(
                  itemCount: callRecords.length,
                  itemBuilder: (context, index) {
                    final call = callRecords[index];
                    final callDate = DateTime.parse(call['callDate']);
                    final formattedDate =
                        DateFormat('MMM d, h:mm a').format(callDate);
                    final callType = getRandomCallType();
                    final callDuration = getRandomDuration();

                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(call['profileImage']),
                            radius: 25,
                          ),
                          title: Text(
                            call['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          subtitle: Row(
                            children: [
                              Text(call['phoneNumber']),
                              const SizedBox(width: 10),
                              Text('($callDuration)',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formattedDate,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                getCallIcon(callType),
                                color: callType == 'missed'
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ],
                          ),
                          onTap: () {
                            // Navigate to the CallScreen with details
                            Get.to(
                              CallScreen(
                                userName: call['name'],
                                profileImageUrl: call['profileImage'],
                                callStatus: 'Contacting',
                              ),
                            );
                          },
                        ),
                        const Divider(indent: 80, thickness: 1),
                      ],
                    );
                  },
                ),
    );
  }
}
