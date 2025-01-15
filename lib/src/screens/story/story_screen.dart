import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:we_yapping_app/src/widgets/base_chat_field.dart';

class StoryScreen extends StatefulWidget {
  final List<String> storyUrls;

  const StoryScreen({Key? key, required this.storyUrls}) : super(key: key);

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final TextEditingController messageController = TextEditingController();

  late PageController _pageController;
  int _currentStoryIndex = 0;
  Timer? _storyTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startStoryTimer();
  }

  @override
  void dispose() {
    _storyTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startStoryTimer() {
    _storyTimer?.cancel();
    _storyTimer = Timer(const Duration(seconds: 5), () {
      if (_currentStoryIndex < widget.storyUrls.length - 1) {
        _goToNextStory();
      } else {
        Navigator.pop(context);
      }
    });
  }

  void _goToNextStory() {
    if (_currentStoryIndex < widget.storyUrls.length - 1) {
      setState(() {
        _currentStoryIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStoryTimer();
    }
  }

  void _goToPreviousStory() {
    if (_currentStoryIndex > 0) {
      setState(() {
        _currentStoryIndex--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startStoryTimer();
    }
  }

  String _getTimeAgo() {
    final now = DateTime.now();
    final past = now.subtract(const Duration(minutes: 30));
    final difference = now.difference(past);
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour ago';
    } else {
      return DateFormat('MMM dd').format(past);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Stories
          PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.storyUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTapUp: (details) {
                  if (details.globalPosition.dx <
                      MediaQuery.of(context).size.width / 2) {
                    _goToPreviousStory();
                  } else {
                    _goToNextStory();
                  }
                },
                child: Image.network(
                  widget.storyUrls[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.broken_image, color: Colors.white),
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              );
            },
          ),
          // Progress bar
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Row(
              children: widget.storyUrls.asMap().entries.map((entry) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 2,
                    decoration: BoxDecoration(
                      color: entry.key <= _currentStoryIndex
                          ? Colors.white
                          : Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Avatar, name, and time
          Positioned(
            top: 50,
            left: 16,
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar5.jpg'),
                  radius: 25,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thiry',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      _getTimeAgo(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Close button
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Bottom actions (message, love, share)
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BaseChatField(messageController: messageController),
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: () {
                    // Handle love button press
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    // Handle share button press
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
