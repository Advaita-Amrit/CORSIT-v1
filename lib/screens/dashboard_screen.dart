import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:corsit_app/models/user_session.dart';
import 'package:corsit_app/screens/profile_screen.dart';
import 'package:corsit_app/screens/add_project.dart';
import 'package:corsit_app/screens/edit_project_screen.dart';
import 'package:corsit_app/models/project.dart'; // Import the central Project model

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Project> _userProjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProjects();
  }

  Future<void> _fetchUserProjects() async {
    final user = UserSession().currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in.')));
      }
      return;
    }

    const String sheetyApiUrl =
        'https://api.sheety.co/11176e6932ade43f8fe0cd2e9c58baea/teamMember/project';

    try {
      final response = await http.get(Uri.parse(sheetyApiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> projectsJson = responseData['project'] ?? [];

        final List<Project> allProjects = projectsJson
            .map((jsonProject) => Project.fromJson(jsonProject))
            .toList();

        // Filter projects by the logged-in user's username
        final userProjects = allProjects
            .where((project) => project.submittedBy == user['username'])
            .toList();

        setState(() {
          _userProjects = userProjects;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch projects.');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error fetching projects: $e')));
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = UserSession().currentUser;
    final userName = user?['name'] ?? 'User';

    return Scaffold(
      appBar: AppBar(title: Text('Welcome, $userName')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'What would you like to do?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFFFF8C00),
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Previous Submitted Projects',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (_userProjects.isEmpty)
                    const Text(
                      'No projects submitted yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    ..._userProjects.map(
                      (project) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(project.name),
                          subtitle: Text(project.description),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProjectScreen(project: project),
                                ),
                              ).then(
                                (_) => _fetchUserProjects(),
                              ); // Refresh on return
                            },
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_circle),
                    label: const Text('Add New Project'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFFFF8C00),
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddProjectScreen(),
                        ),
                      ).then((_) => _fetchUserProjects()); // Refresh on return
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
