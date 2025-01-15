import 'package:flutter/material.dart';
import 'package:we_yapping_app/src/utils/story_state.dart';

class AddToStoryWithSelectionPage extends StatefulWidget {
  @override
  _AddToStoryWithSelectionPageState createState() =>
      _AddToStoryWithSelectionPageState();
}

class _AddToStoryWithSelectionPageState
    extends State<AddToStoryWithSelectionPage> {
  final List<String> imagePaths = [
    'assets/images/avatar1.jpg',
    'assets/images/avatar2.jpg',
    'assets/images/avatar3.jpg',
    'assets/images/avatar4.jpg',
    'assets/images/avatar5.jpg',
  ];

  final Set<String> selectedImages = Set<String>();

  // Toggle selection of image
  void toggleSelection(String imagePath) {
    setState(() {
      if (selectedImages.contains(imagePath)) {
        selectedImages.remove(imagePath);
      } else {
        selectedImages.add(imagePath);
      }
    });
  }

  // Function to post the selected images
  void postStory() {
    if (selectedImages.isNotEmpty) {
      // Example: Replace with actual username
      StoryState.userStories.value = {
        ...StoryState.userStories.value,
        "Thiry": selectedImages.toList(), // Store all selected images as a list
      };

      // Navigate back after posting
      Navigator.pop(context);
    }
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
            Navigator.pop(context); // Close the page and navigate back
          },
        ),
        title: Text(
          'Add to story',
          style: TextStyle(color: Colors.orange, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 32.0), // Add bottom padding here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[900],
                          ),
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Camera',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Recently Photos',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.0, // Square grid cells
                ),
                itemCount: imagePaths.length,
                itemBuilder: (context, index) {
                  String imagePath = imagePaths[index];
                  bool isSelected = selectedImages.contains(imagePath);

                  return GestureDetector(
                    onTap: () {
                      toggleSelection(imagePath);
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit
                                .cover, // Ensures the image covers the grid cell
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Color(0xFFFFA500),
                            size: 30,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Display the selected images at the bottom
            if (selectedImages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedImages.length,
                    itemBuilder: (context, index) {
                      String selectedImage = selectedImages.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            selectedImage,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Your Story label and arrow button
            if (selectedImages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.person, color: Colors.white),
                      label: Text(
                        'Your Story',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward, color: Colors.orange),
                      onPressed: postStory,
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
