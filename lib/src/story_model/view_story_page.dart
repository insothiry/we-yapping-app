import 'package:flutter/material.dart';

class ViewStoryPage extends StatefulWidget {
  final List<String> storyPaths; // Accepting multiple story paths
  final String userName;
  final String userProfilePicture;

  const ViewStoryPage({
    Key? key,
    required this.storyPaths,
    required this.userName,
    required this.userProfilePicture,
  }) : super(key: key);

  @override
  _ViewStoryPageState createState() => _ViewStoryPageState();
}

class _ViewStoryPageState extends State<ViewStoryPage>
    with TickerProviderStateMixin {
  int currentIndex = 0; // Track the current image index
  late AnimationController _progressBarController;
  final int duration = 5; // Duration for each image in seconds
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    // Initialize the PageController
    _pageController = PageController(initialPage: currentIndex);

    // Initialize the AnimationController
    _progressBarController = AnimationController(
      duration: Duration(seconds: duration),
      vsync: this,
    );

    _progressBarController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goToNextImage(); // Automatically go to the next image
      }
    });

    _startProgressBar();
  }

  // Start the progress bar for the current image
  void _startProgressBar() {
    _progressBarController.reset();
    _progressBarController.forward();
  }

  // Navigate to the next image
  void _goToNextImage() {
    if (currentIndex < widget.storyPaths.length - 1) {
      setState(() {
        currentIndex++;
      });
      _pageController.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startProgressBar(); // Start the animation for the next image
    } else {
      // If all images have been viewed, close the story
      Navigator.pop(context);
    }
  }

  // Navigate to the previous image
  void _goToPreviousImage() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _pageController.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startProgressBar(); // Restart progress bar animation for the previous image
    }
  }

  @override
  void dispose() {
    _progressBarController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.orange),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            // Profile Picture
            CircleAvatar(
              backgroundImage: AssetImage(widget.userProfilePicture),
              radius: 20,
            ),
            SizedBox(width: 8),
            // User Name
            Text(
              widget.userName,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTapUp: (details) {
          // Detect taps to move forward or backward
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 2) {
            _goToPreviousImage(); // Tap on the left half to go back
          } else {
            _goToNextImage(); // Tap on the right half to go forward
          }
        },
        child: Stack(
          children: [
            // Display the current image with rounded corners and bottom padding
            PageView.builder(
              itemCount: widget.storyPaths.length,
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(), // Prevent manual swiping
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 120.0), // Add bottom padding
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.asset(
                      widget.storyPaths[index],
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.74,
                    ),
                  ),
                );
              },
            ),

            // Animated Progress Bars above the content
            Positioned(
              top: 16, // Position the progress bars above the story content
              left: 16,
              right: 16,
              child: Row(
                children: List.generate(
                  widget.storyPaths.length,
                  (index) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: AnimatedBuilder(
                        animation: _progressBarController,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            value: currentIndex == index
                                ? _progressBarController.value
                                : (currentIndex > index ? 1.0 : 0.0),
                            backgroundColor: Colors.white.withOpacity(0.5),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.orange),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Viewer and like counts at the bottom
            Positioned(
              bottom: 40, // Position viewer and like counts near the bottom
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Viewer count on the left
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '0 viewers', // Update with actual viewer count
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),

                  // Likes count on the right
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        color: Colors.orange,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '0 likes', // Update with actual like count
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
