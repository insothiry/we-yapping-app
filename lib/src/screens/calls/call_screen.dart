import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class CallScreen extends StatefulWidget {
  final String userName;
  final String profileImageUrl;
  final String callStatus;

  const CallScreen({
    Key? key,
    required this.userName,
    required this.profileImageUrl,
    required this.callStatus,
  }) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late List<Color> gradientColors;
  late bool isFirstGradient;

  @override
  void initState() {
    super.initState();
    gradientColors = [
      Colors.blue.withOpacity(0.5),
      Colors.purple.withOpacity(0.5),
    ];
    isFirstGradient = true;

    // Start a timer to change the gradient colors every 5 seconds
    Future.delayed(const Duration(seconds: 1), _changeGradientColors);
  }

  void _changeGradientColors() {
    if (mounted) {
      setState(() {
        if (isFirstGradient) {
          gradientColors = [
            Colors.pink.withOpacity(0.5),
            Colors.orange.withOpacity(0.5),
          ];
        } else {
          gradientColors = [
            Colors.blue.withOpacity(0.5),
            Colors.purple.withOpacity(0.5),
          ];
        }
        isFirstGradient = !isFirstGradient; // Toggle the gradient
      });
    }

    // Continue changing the colors every 5 seconds
    Future.delayed(const Duration(seconds: 5), _changeGradientColors);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background Gradient
          AnimatedContainer(
            duration: const Duration(seconds: 5),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          // User Details and Controls
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User Name and Call Status
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.profileImageUrl),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.callStatus,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        // Animate only the "..." part
                        AnimatedTextKit(
                          animatedTexts: [
                            WavyAnimatedText(
                              '...',
                              speed: const Duration(milliseconds: 500),
                              textStyle: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                          ],
                          repeatForever: true, // Keeps the animation going
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Call Controls
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: Icons.mic_off,
                      label: 'Mute',
                      onTap: () {
                        print('Mute button pressed');
                      },
                    ),
                    _buildControlButton(
                      icon: Icons.call_end,
                      label: 'End Call',
                      color: Colors.red,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    _buildControlButton(
                      icon: Icons.volume_up,
                      label: 'Speaker',
                      onTap: () {
                        print('Speaker button pressed');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
