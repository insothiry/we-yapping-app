import 'package:flutter/material.dart';
import 'package:we_yapping_app/src/utils/base_colors.dart';

class UserProfileScreen extends StatelessWidget {
  final String userName;
  final String lastSeen;
  final String profileImage;

  UserProfileScreen({
    required this.userName,
    required this.lastSeen,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BaseColor.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: BaseColor.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Edit',
                style: TextStyle(
                  color: BaseColor.primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: BaseColor.backgroundColor,
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(profileImage),
            ),
            const SizedBox(height: 20),
            Text(
              userName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              lastSeen,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconButton(Icons.call, 'Call'),
                  _buildIconButton(Icons.videocam, 'Video'),
                  _buildIconButton(Icons.notifications, 'Mute'),
                  _buildIconButton(Icons.search, 'Search'),
                  _buildIconButton(Icons.more_vert, 'More'),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'mobile',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        '+855 92 999 999',
                        style: TextStyle(
                            color: BaseColor.primaryColor, fontSize: 18),
                      ),
                      Divider(
                        color: Colors.black12,
                      ),
                      Text(
                        'username',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        '@kimjiwon99',
                        style: TextStyle(
                            color: BaseColor.primaryColor, fontSize: 18),
                      ),
                      Divider(
                        color: Colors.black12,
                      ),
                      Text(
                        'bio',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'I love you til the day that i die',
                        style: TextStyle(fontSize: 18),
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label) {
    return Container(
      width: 70,
      height: 70,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(icon),
            iconSize: 24,
            color: BaseColor.primaryColor,
            onPressed: () {
              // Handle button action here
            },
          ),
          Text(
            label,
            style: const TextStyle(
                color: BaseColor.primaryColor,
                fontSize: 12), // Reduced font size
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
