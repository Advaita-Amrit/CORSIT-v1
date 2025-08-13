import 'package:flutter/material.dart';
import 'package:corsit_app/screens/about_screen.dart';
import 'package:corsit_app/screens/alumni_screen.dart';
import 'package:corsit_app/screens/chat_screen.dart';
import 'package:corsit_app/screens/contact_us_screen.dart';
import 'package:corsit_app/screens/events_screen.dart';
import 'package:corsit_app/screens/home_screen.dart';
import 'package:corsit_app/screens/login_screen.dart';
import 'package:corsit_app/screens/projects_screen.dart';
import 'package:corsit_app/screens/team_screen.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _robotAnimationController;

  final List<Widget> _pages = const [
    HomeScreen(),
    EventsScreen(),
    ProjectsScreen(),
    TeamScreen(),
  ];

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
    return Scaffold(
      appBar: AppBar(
        leading: _selectedIndex == 0
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedIndex = 0),
              ),
        title: const Column(
          children: [
            Text(
              'CORSIT',
              style: TextStyle(
                color: Color(0xFFFF8C00),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
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
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFFF8C00)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CORSIT',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Club Of Robotics',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
          _buildDrawerItem('Home', Icons.home, () {
            Navigator.pop(context);
            setState(() => _selectedIndex = 0);
          }),
          _buildDrawerItem('About', Icons.info, () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            );
          }),
          _buildDrawerItem('Event', Icons.event, () {
            Navigator.pop(context);
            setState(() => _selectedIndex = 1);
          }),
          _buildDrawerItem('Projects', Icons.build, () {
            Navigator.pop(context);
            setState(() => _selectedIndex = 2);
          }),
          _buildDrawerItem('Team', Icons.people, () {
            Navigator.pop(context);
            setState(() => _selectedIndex = 3);
          }),
          _buildDrawerItem('Alumni', Icons.school, () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AlumniScreen()),
            );
          }),
          _buildDrawerItem('Contact Us', Icons.contact_support, () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactUsScreen()),
            );
          }),
          const Divider(color: Colors.grey),
          _buildDrawerItem('Login', Icons.login, () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }),
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
}
