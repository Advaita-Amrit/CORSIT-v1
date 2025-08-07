import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const CORSITApp());
}

class CORSITApp extends StatelessWidget {
  const CORSITApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CORSIT - Club Of Robotics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFF8C00),
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF8C00),
          secondary: Color(0xFFFF8C00),
          surface: Color(0xFF1E1E1E),
          background: Color(0xFF121212),
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Color(0xFFE0E0E0),
          onBackground: Color(0xFFE0E0E0),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Color(0xFFE0E0E0),
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: Color(0xFFFF8C00),
          unselectedItemColor: Color(0xFFE0E0E0),
          type: BottomNavigationBarType.fixed,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFF8C00),
          foregroundColor: Colors.black,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _robotAnimationController;
  late Animation<double> _robotAnimation;

  final List<Widget> _pages = [
    const HomeScreen(),
    const EventsScreen(),
    const ProjectsScreen(),
    const TeamScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _robotAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _robotAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _robotAnimationController,
        curve: Curves.easeInOut,
      ),
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
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Column(
          children: [
            const Text(
              'CORSIT',
              style: TextStyle(
                color: Color(0xFFFF8C00),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Welcome to our official page!',
              style: TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      drawer: _buildDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Event'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Team'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFFFF8C00)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CORSIT',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Club Of Robotics',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
          _buildDrawerItem('Home', Icons.home, () => _navigateToPage(0)),
          _buildDrawerItem('About', Icons.info, () => _navigateToPage(4)),
          _buildDrawerItem('Event', Icons.event, () => _navigateToPage(1)),
          _buildDrawerItem('Projects', Icons.build, () => _navigateToPage(2)),
          _buildDrawerItem('Team', Icons.people, () => _navigateToPage(3)),
          _buildDrawerItem('Alumni', Icons.school, () => _navigateToPage(5)),
          _buildDrawerItem(
            'Contact Us',
            Icons.contact_support,
            () => _navigateToPage(6),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFE0E0E0)),
      title: Text(title, style: const TextStyle(color: Color(0xFFE0E0E0))),
      onTap: onTap,
    );
  }

  void _navigateToPage(int index) {
    Navigator.pop(context); // Close drawer
    if (index < 4) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      // Navigate to pages not in bottom navigation
      switch (index) {
        case 4: // About
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutScreen()),
          );
          break;
        case 5: // Alumni
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AlumniScreen()),
          );
          break;
        case 6: // Contact Us
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactUsScreen()),
          );
          break;
      }
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _robotAnimationController;
  late Animation<double> _robotAnimation;

  @override
  void initState() {
    super.initState();
    _robotAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _robotAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _robotAnimationController,
        curve: Curves.easeInOut,
      ),
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
          // Left side - Text
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Learn with us.',
                  style: TextStyle(
                    color: Color(0xFFFF8C00),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Explore the world of robotics with our innovative projects and cutting-edge technology.',
                  style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
                ),
              ],
            ),
          ),
          // Right side - Animated Robot
          Expanded(
            flex: 1,
            child: AnimatedBuilder(
              animation: _robotAnimation,
              builder: (context, child) {
                return Lottie.asset(
                  'assets/animations/robo.lottie', // Replace with your file name
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
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFFFF8C00), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Yet to be announced',
                style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 14),
              ),
              const SizedBox(width: 24),
              const Icon(
                Icons.calendar_today,
                color: Color(0xFFFF8C00),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
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
            Icons.track_changes,
          ),
          const SizedBox(height: 16),
          _buildProjectCard(
            'Gesture Controlled Bot',
            'A robot that responds to hand gestures using OpenCV.',
            Icons.gesture,
          ),
          const SizedBox(height: 16),
          _buildProjectCard(
            'Smart Home Automation',
            'IoT-based home automation for energy efficiency.',
            Icons.home,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF8C00).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFFF8C00), size: 32),
          ),
          const SizedBox(width: 16),
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
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Events',
            style: TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildEventCard(
            'Robotics Workshop',
            'Learn the basics of robotics and Arduino programming',
            'Dec 15, 2024',
            '10:00 AM',
            Icons.school,
          ),
          _buildEventCard(
            'Competition Day',
            'Annual robotics competition for all members',
            'Dec 20, 2024',
            '2:00 PM',
            Icons.emoji_events,
          ),
          _buildEventCard(
            'Guest Lecture',
            'Industry expert sharing insights on AI in robotics',
            'Dec 25, 2024',
            '6:00 PM',
            Icons.person,
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(
    String title,
    String description,
    String date,
    String time,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
                      '$date at $time',
                      style: const TextStyle(
                        color: Color(0xFFE0E0E0),
                        fontSize: 14,
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
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C00),
              foregroundColor: Colors.black,
            ),
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Projects',
            style: TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildProjectCard(
            'Autonomous Robot',
            'Building a self-navigating robot using Arduino and sensors',
            'In Progress',
            Icons.smart_toy,
          ),
          _buildProjectCard(
            'Drone Control System',
            'Developing a custom flight controller for quadcopters',
            'Planning',
            Icons.flight,
          ),
          _buildProjectCard(
            'Smart Home Automation',
            'IoT-based home automation using Raspberry Pi',
            'Completed',
            Icons.home,
          ),
          _buildProjectCard(
            'Computer Vision Robot',
            'AI-powered robot with object recognition capabilities',
            'In Progress',
            Icons.visibility,
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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: const Color(0xFFFF8C00),
                child: Text(
                  '5',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Team Members',
                style: const TextStyle(color: Color(0xFFE0E0E0), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Team',
            style: TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildTeamMember(
            'Advaita Amrit',
            'Member',
            'advaitaamrit@gmail.com',
            Icons.person,
          ),
          _buildTeamMember(
            'Yash Jadhav',
            'Member',
            'yashuyashu@corsit.sit',
            Icons.engineering,
          ),
          _buildTeamMember(
            'Jishnu Khargharia',
            'Treasurer',
            'treasurersahab@corsit.sit',
            Icons.manage_accounts,
          ),
          _buildTeamMember(
            'Dogesh Bhai',
            'Elite Member',
            'dogeshbhai@corsit.com',
            Icons.pets,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(
    String name,
    String role,
    String email,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF8C00).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFFF8C00), size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  role,
                  style: const TextStyle(
                    color: Color(0xFFFF8C00),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.message, color: Color(0xFFFF8C00)),
          ),
        ],
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About CORSIT')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFF8C00), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About CORSIT',
                    style: TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'CORSIT (Club Of Robotics) is a premier robotics club dedicated to fostering innovation and technological advancement. Our mission is to inspire the next generation of robotics engineers and innovators.',
                    style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Our Mission',
              style: TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'To provide hands-on experience in robotics and automation, promote STEM education, and create a community of passionate innovators.',
              style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class AlumniScreen extends StatelessWidget {
  const AlumniScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alumni Network')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alumni Network',
              style: TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Connect with our successful alumni who have made significant contributions to the field of robotics and technology.',
              style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF8C00).withOpacity(0.3),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alumni Features',
                    style: TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '• Networking opportunities\n• Mentorship programs\n• Career guidance\n• Industry connections',
                    style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
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

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get in Touch',
              style: TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildContactCard('Email', 'contact@corsit.com', Icons.email),
            _buildContactCard('Phone', '+1 (555) 123-4567', Icons.phone),
            _buildContactCard(
              'Address',
              '123 Robotics Street, Tech City, TC 12345',
              Icons.location_on,
            ),
            const SizedBox(height: 24),
            const Text(
              'Send us a Message',
              style: TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF8C00).withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: const TextStyle(color: Color(0xFFE0E0E0)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFFF8C00)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Color(0xFFE0E0E0)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFFF8C00)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Message',
                      labelStyle: const TextStyle(color: Color(0xFFE0E0E0)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFFF8C00)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C00),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Send Message'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF8C00).withOpacity(0.3)),
      ),
      child: Row(
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Support')),
      body: Container(
        color: const Color(0xFF121212),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                color: Color(0xFFFF8C00),
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Chat Feature Coming Soon!',
                style: TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We\'re working on implementing real-time chat support.',
                style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
