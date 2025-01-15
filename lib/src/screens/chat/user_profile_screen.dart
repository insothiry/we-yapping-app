import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_yapping_app/src/screens/calls/call_screen.dart';
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

  final List<String> mediaImages = [
    'https://images.saymedia-content.com/.image/t_share/MTc0MzIwMjM1MTk1NjcxOTEy/top-ten-cutest-japanese-wild-animals.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3YxYRnZ44OUV2-H5eY4RTdgR5ArnxSsUaFw&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2fKcQ_aQgQwpgEeziLXOEcOn1zDvBQ2A9VQ&s',
    'https://hips.hearstapps.com/womansday/assets/17/39/cola-0247.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ07Woq1wcCgLiqxkE3OxIxLNjQmAsJjtmrCg&s',
    'https://i.pinimg.com/236x/87/67/8c/87678c0b792eee373ea41802abdf07f5.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? Colors.black12 : BaseColor.backgroundColor,
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
      body: SingleChildScrollView(
        child: Container(
          color: isDarkMode ? Colors.black12 : BaseColor.backgroundColor,
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue,
                //  backgroundImage: NetworkImage(profileImage),
              ),
              const SizedBox(height: 20),
              Text(
                userName,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                lastSeen,
                style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[600]),
              ),
              const SizedBox(height: 30),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconButton(
                      context,
                      isDarkMode,
                      Icons.call,
                      'Call',
                      () {
                        Get.to(CallScreen(
                            userName: userName,
                            profileImageUrl: profileImage,
                            callStatus: 'Contacting'));
                      },
                    ),
                    _buildIconButton(
                      context,
                      isDarkMode,
                      Icons.videocam,
                      'Video',
                      () {
                        // Handle Video action here
                      },
                    ),
                    _buildIconButton(
                      context,
                      isDarkMode,
                      Icons.notifications,
                      'Mute',
                      () {
                        // Handle Mute action here
                      },
                    ),
                    _buildIconButton(
                      context,
                      isDarkMode,
                      Icons.search,
                      'Search',
                      () {
                        // Handle Search action here
                      },
                    ),
                    _buildIconButton(
                      context,
                      isDarkMode,
                      Icons.more_vert,
                      'More',
                      () {
                        // Handle More action here
                      },
                    ),
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
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mobile',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        '+855 92 999 999',
                        style: TextStyle(
                            color: BaseColor.primaryColor, fontSize: 18),
                      ),
                      Divider(color: Colors.black12),
                      Text(
                        'Username',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        '@kimjiwon99',
                        style: TextStyle(
                            color: BaseColor.primaryColor, fontSize: 18),
                      ),
                      Divider(color: Colors.black12),
                      Text(
                        'Bio',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'I love you til the day that I die',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),

              // Media (Responsive Grid)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(context),
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: mediaImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Handle image tap (e.g., open full view)
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            mediaImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dynamically determine the number of columns based on screen width
  int _getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return 3; // For smaller screens, show 2 items per row
    } else if (screenWidth < 900) {
      return 4; // For medium screens, show 3 items per row
    } else {
      return 5; // For larger screens, show 4 items per row
    }
  }

  Widget _buildIconButton(BuildContext context, bool isDarkMode, IconData icon,
      String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: BaseColor.primaryColor,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style:
                  const TextStyle(color: BaseColor.primaryColor, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
