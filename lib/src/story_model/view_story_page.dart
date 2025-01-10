import 'package:flutter/material.dart';

class ViewStoryPage extends StatefulWidget {
  final String storyPath;
  final bool isOwner; // Indicates if this is the user's own story

  const ViewStoryPage({
    Key? key,
    required this.storyPath,
    this.isOwner = false,
  }) : super(key: key);

  @override
  _ViewStoryPageState createState() => _ViewStoryPageState();
}

class _ViewStoryPageState extends State<ViewStoryPage> {
  int likesCount = 0; // Initialize likes count
  int viewerCount = 100; // Example viewer count

  void incrementLikes() {
    setState(() {
      likesCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Image with rounded corners
          Column(
            children: [
              SizedBox(height: 16), // Spacer at the top
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset(
                  widget.storyPath,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.74,
                ),
              ),
            ],
          ),

          // Viewer and like counts at the bottom
          Positioned(
            bottom: 64,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Viewer count on the left
                if (widget.isOwner || viewerCount > 0)
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$viewerCount viewers',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),

                // Likes count on the right
                if (!widget.isOwner)
                  Row(
                    children: [
                      GestureDetector(
                        onTap: incrementLikes,
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$likesCount likes',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
