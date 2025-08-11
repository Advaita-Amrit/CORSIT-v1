import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'About Us',
              style: TextStyle(
                color: Color(0xFFFF8C00),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'CORSIT, the robotics club of SIT, is a vibrant community of passionate robotics enthusiasts dedicated to learning, building, and innovating together. Since its inception in 2006, the club has organized national-level workshops and actively competed in prestigious events across the country. As the official hub for robotics activities at SIT, CORSIT provides students with hands-on experience, fostering creativity and technical excellence. With a mission to inspire and empower future innovators, the club continues to push the boundaries of robotics through collaboration and practical learning.',
              style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'We believe in learning by doing, and our club provides a platform for students to explore robotics, automation, and AI. We value collaboration, curiosity, and a drive to solve real-world problems.',
              style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Join us to participate in workshops, competitions, and projects that push the boundaries of technology and innovation!',
              style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
