import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _robotAnimationController;

  @override
  void initState() {
    super.initState();
    _robotAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _robotAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _robotAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeroSection(),
          _buildEventsSection(),
          _buildProjectsSection(),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learn with us.',
                  style: TextStyle(
                    color: Color(0xFFFF8C00),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Explore the world of robotics with our innovative projects and cutting-edge technology.',
                  style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: AnimatedBuilder(
              animation: _robotAnimationController,
              builder: (context, child) {
                return Lottie.asset(
                  'assets/animations/robo.json',
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Events',
            style: TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildEventCard(
            'RoboCor',
            'The ultimate battleground for innovation, where robots clash and creativity thrives!',
          ),
          const SizedBox(height: 16),
          _buildEventCard(
            'Workshop',
            'Learn the basics of robotics and automation in this hands-on workshop.',
          ),
          const SizedBox(height: 16),
          _buildEventCard(
            'RoboExpo',
            'A showcase of cutting-edge robotics, AI, and automation innovations.',
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(String title, String tagline) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF8C00).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFF8C00),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tagline,
            style: const TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFFFF8C00), size: 20),
              SizedBox(width: 8),
              Text(
                'Yet to be announced',
                style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 14),
              ),
              SizedBox(width: 24),
              Icon(Icons.calendar_today, color: Color(0xFFFF8C00), size: 20),
              SizedBox(width: 8),
              Text(
                'Yet to be announced',
                style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Projects',
            style: TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildProjectCard(
            'Line Following Robot',
            'An autonomous robot that follows a path using sensors.',
            'Completed',
            Icons.track_changes,
          ),
          const SizedBox(height: 16),
          _buildProjectCard(
            'Gesture Controlled Bot',
            'A robot that responds to hand gestures using OpenCV.',
            'Completed',
            Icons.gesture,
          ),
          const SizedBox(height: 16),
          _buildProjectCard(
            'Smart Home Automation',
            'IoT-based home automation for energy efficiency.',
            'Completed',
            Icons.home,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(
    String title,
    String description,
    String status,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF8C00).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFFFF8C00), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFE0E0E0),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      status,
                      style: const TextStyle(
                        color: Color(0xFFFF8C00),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(color: Color(0xFFE0E0E0), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
