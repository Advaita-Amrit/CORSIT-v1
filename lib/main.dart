import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const ProfileScreen();
            } else {
              return const RootPage();
            }
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _robotAnimationController;

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
            Navigator.pop(context); // Close drawer
            setState(() => _selectedIndex = 0);
          }),
          _buildDrawerItem('About', Icons.info, () {
            Navigator.pop(context); // Close drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            );
          }),
          _buildDrawerItem('Event', Icons.event, () {
            Navigator.pop(context); // Close drawer
            setState(() => _selectedIndex = 1);
          }),
          _buildDrawerItem('Projects', Icons.build, () {
            Navigator.pop(context); // Close drawer
            setState(() => _selectedIndex = 2);
          }),
          _buildDrawerItem('Team', Icons.people, () {
            Navigator.pop(context); // Close drawer
            setState(() => _selectedIndex = 3);
          }),
          _buildDrawerItem('Alumni', Icons.school, () {
            Navigator.pop(context); // Close drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AlumniScreen()),
            );
          }),
          _buildDrawerItem('Contact Us', Icons.contact_support, () {
            Navigator.pop(context); // Close drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactUsScreen()),
            );
          }),
          const Divider(color: Colors.grey),
          _buildDrawerItem('Login', Icons.login, () {
            Navigator.pop(context); // Close drawer
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Member Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'CORSIT Member Login',
                  style: TextStyle(
                    color: Color(0xFFFF8C00),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Color(0xFFE0E0E0)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFFE0E0E0)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Color(0xFFE0E0E0)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFFE0E0E0)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xFFFF8C00)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C00),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _isLoading ? null : _signIn,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                          )
                        : const Text('Login', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                    );
                  },
                  child: const Text(
                    'Create an account',
                    style: TextStyle(color: Color(0xFFFF8C00)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // This is your whitelist of approved emails.
  // You can easily update this list.
  final List<String> _whitelistedEmails = [
    'advaitaamrit@gmail.com',
    'yashuyashu@corsit.sit',
    'jishnukhargharia@corsit.sit',
    'dogeshbhai@corsit.com',
  ];

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();

    if (!_whitelistedEmails.contains(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are not an authorized member to register.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.pop(context); // Pop registration screen on success
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Member Registration'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'CORSIT Member Registration',
                  style: TextStyle(
                    color: Color(0xFFFF8C00),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Color(0xFFE0E0E0)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFFE0E0E0)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Color(0xFFE0E0E0)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFFE0E0E0)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C00),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _isLoading ? null : _registerUser,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                          )
                        : const Text('Register', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent. Check your inbox!')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reset Password'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Forgot your password?',
                  style: TextStyle(
                    color: Color(0xFFFF8C00),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter your email address below to receive a password reset link.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Color(0xFFE0E0E0)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFFE0E0E0)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C00),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _isLoading ? null : _resetPassword,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                          )
                        : const Text('Send Reset Link', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome, you are logged in!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

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
          // Left side - Text
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
          // Right side - Animated Robot
          Expanded(
            flex: 1,
            child: AnimatedBuilder(
              animation: _robotAnimationController,
              builder: (context, child) {
                return Lottie.asset(
                  'assets/animations/robo.json', // Replace with your file name
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
              Icon(
                Icons.calendar_today,
                color: Color(0xFFFF8C00),
                size: 20,
              ),
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

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: SingleChildScrollView(
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
              'CORSIT offers free workshops on IoT, Arduino, cloud, and more, providing students with hands-on experience in building basic bots suchs as LFR, Bluetooth, and obstacle-avoiding bots. Participants learn to code and use different components to program the bots brain. The club also conducts a paid workshop where a mentor guides students on emerging technologies with a mix of studio practice and lectures. The workshop aims to enhance practical skills and teach the theory and context behind the practice.',
              'Yet to be announced',
              'Yet to be announced',
              Icons.school,
            ),
            _buildEventCard(
              'RoboCor',
              'Robocor, a nationally renowned Robotics Competition, which is one of the biggest events in Karnataka. It provides a platform for participants to showcase their innovative designs and compete for glory. In Robocor, the team has successfully organized several events such as Dcode, Spardha, Rugged Rage, Robo Soccer, Arduino Clash, Binary Rash, Project Symposium, Paper Presentation, and Init_Rc.',
              'Yet to be announced',
              'Yet to be announced',
              Icons.emoji_events,
            ),
            _buildEventCard(
              'RoboExpo',
              'ROBOEXPO is an annual event organized by the Robotics club of SIT CORSIT. The primary objective is to introduce the club and its activities to the newcomers by displaying the bots that the members have created over the year. The event showcases various bots such as Line Follower Robots (LFR), Roboracer, Gesture controlled bots, Bluetooth controlled bots, etc. The exhibition provides students with an opportunity to witness and understand the workings of these bots up close. It serves as an excellent platform for the Robotics club to attract new members who are interested in this field.',
              'Yet to be announced',
              'Yet to be announced',
              Icons.person,
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bots & Projects',
              style: TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildProjectCard(
              'Line Following Robot',
              'Building a self-navigating robot using Arduino and sensors',
              'Completed',
              Icons.smart_toy,
            ),
            _buildProjectCard(
              'Gesture Controlled Bot',
              'A robot that responds to hand gestures using OpenCV.',
              'Completed',
              Icons.gesture,
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
      ),
    );
  }
}

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final List<TeamMember> _members = [
    TeamMember(
      'Advaita Amrit',
      'Member',
      'advaitaamrit@gmail.com',
      Icons.person,
    ),
    TeamMember(
      'Yash Jadhav',
      'Member',
      'yashuyashu@corsit.sit',
      Icons.engineering,
    ),
    TeamMember(
      'Jishnu Khargharia',
      'Treasurer',
      'treasurersahab@corsit.sit',
      Icons.manage_accounts,
    ),
    TeamMember(
      'Dogesh Bhai',
      'Elite Member',
      'dogeshbhai@corsit.com',
      Icons.pets,
    ),
  ];

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _members[index].image = File(pickedFile.path);
      });
    }
  }

  Widget _buildTeamMember(int index) {
    final member = _members[index];
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
          GestureDetector(
            onTap: () => _pickImage(index),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: const Color(0xFFFF8C00),
              child: member.image != null
                  ? ClipOval(
                      child: Image.file(
                        member.image!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(member.icon, color: Colors.black, size: 40),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  member.role,
                  style: const TextStyle(
                    color: Color(0xFFFF8C00),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  member.email,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team'),
      ),
      body: SingleChildScrollView(
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
            ..._members
                .asMap()
                .entries
                .map((entry) => _buildTeamMember(entry.key))
                .toList(),
          ],
        ),
      ),
    );
  }
}

class TeamMember {
  String name;
  String role;
  String email;
  IconData icon;
  File? image;

  TeamMember(this.name, this.role, this.email, this.icon, {this.image});
}

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

class AlumniScreen extends StatelessWidget {
  const AlumniScreen({super.key});

  Widget _alumniCard(String name, String year) {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFFF8C00),
          child: Icon(Icons.person, color: Colors.black),
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(year, style: const TextStyle(color: Color(0xFFE0E0E0))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Alumni Network'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _alumniCard(
            'Ojas Sangra',
            'Oracle - Associate Applications Developer',
          ),
          _alumniCard('Ashish Mahanth', 'Microchip -Software Engineer 1'),
          _alumniCard('Yashaswini', 'Saks Cloud Services - Cloud Engineer'),
        ],
      ),
    );
  }
}

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  Widget _socialIcon(IconData icon, String url) {
    return InkWell(
      onTap: () async {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $url')),
          );
        }
      },
      child: CircleAvatar(
        backgroundColor: const Color(0xFFFF8C00),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final name = nameController.text;
      final email = emailController.text;
      final message = messageController.text;

      // Replace this with your unique Web3Forms Access Key
      const accessKey = '191fb0bb-9571-4278-a4af-5a069efdc6ea';

      final url = Uri.parse('https://api.web3forms.com/submit');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'access_key': accessKey,
          'name': name,
          'email': email,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message sent successfully!')),
        );
        nameController.clear();
        emailController.clear();
        messageController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send message. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Contact Us'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'We would love to hear from you! Connect with us on social media or send us a message below.',
            style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(Icons.facebook, 'https://facebook.com'),
              const SizedBox(width: 16),
              _socialIcon(Icons.link, 'https://linkedin.com'),
              const SizedBox(width: 16),
              _socialIcon(
                Icons.code,
                'https://github.com/Advaita-Amrit/CORSIT-v1',
              ),
            ],
          ),
          const SizedBox(height: 32),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    labelStyle: TextStyle(color: Color(0xFFE0E0E0)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFFE0E0E0)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Your Email',
                    labelStyle: TextStyle(color: Color(0xFFE0E0E0)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFFE0E0E0)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: messageController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Your Message',
                    labelStyle: TextStyle(color: Color(0xFFE0E0E0)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF8C00)),
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFFE0E0E0)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a message.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C00),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _submitForm,
                    icon: const Icon(Icons.send),
                    label: const Text('Send Message', style: TextStyle(fontSize: 18)),
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

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final List<Map<String, String>> _introMessage = [
    {
      'sender': 'bot',
      'text': 'Hello! I am the CORSIT chatbot. I can help you with questions about our club and robotics. Ask me anything!',
    },
  ];

  @override
  void initState() {
    super.initState();
    _messages.addAll(_introMessage);
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isLoading = true;
    });
    _controller.clear();

    // Replace this with your actual Gemini API key
    const String apiKey = "AIzaSyBZnuJT8wtI3B4jjDyWz6d5_fJLlSKbH9A";
    const String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-05-20:generateContent?key=$apiKey";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "contents": [
            {
              "role": "user",
              "parts": [{"text": "You are a friendly chatbot for the CORSIT robotics club. You should answer questions about CORSIT and robotics. For CORSIT details you can check www.corsit.in. If the robotics question is general answer it directly, if any specific queston is asked, say you can better ask a club mumber should I schedule a call back? I yes take number and mail it using Web3Forms api key= \"191fb0bb-9571-4278-a4af-5a069efdc6ea\". Keep your answers concise and engaging. Once the chat is closed send a copy to mail using Web3form api key=\"191fb0bb-9571-4278-a4af-5a069efdc6ea\". A user has asked: $text"}]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final botMessage = data['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          _messages.add({'sender': 'bot', 'text': botMessage});
          _isLoading = false;
        });
      } else {
        setState(() {
          _messages.add({'sender': 'bot', 'text': 'Sorry, I am unable to connect to the server. Please try again later.'});
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'bot', 'text': 'An error occurred. Please check your network connection.'});
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CORSIT Chatbot'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFFFF8C00) : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(0),
                        bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.black : const Color(0xFFE0E0E0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: LinearProgressIndicator(
                color: Color(0xFFFF8C00),
                backgroundColor: Color(0xFF1E1E1E),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Ask about CORSIT or robotics...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8C00),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.black),
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

