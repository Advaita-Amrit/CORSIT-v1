import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:corsit_app/models/project.dart';
import 'package:corsit_app/screens/project_detail_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<Project> _allProjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllProjects();
  }

  Future<void> _fetchAllProjects() async {
    const String sheetyApiUrl =
        'https://api.sheety.co/11176e6932ade43f8fe0cd2e9c58baea/teamMember/project';

    try {
      final response = await http.get(Uri.parse(sheetyApiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> projectsJson = responseData['project'] ?? [];

        setState(() {
          _allProjects = projectsJson
              .map((jsonProject) => Project.fromJson(jsonProject))
              .toList();
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

  Widget _buildProjectCard(Project project) {
    // Split the description to show only a couple of lines with "Read More"
    String shortDescription = project.description;
    if (shortDescription.length > 100) {
      shortDescription = '${shortDescription.substring(0, 100)}...';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailScreen(project: project),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFF8C00).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Image
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: Colors.grey[800],
              ),
              child: project.imageUrl != null && project.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        project.imageUrl!.split(
                          ',',
                        )[0], // Show the first image if multiple exist
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 60,
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.image, color: Colors.grey, size: 60),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: const TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tags: ${project.tags}',
                    style: const TextStyle(
                      color: Color(0xFFFF8C00),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    shortDescription,
                    style: const TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Projects')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                  if (_allProjects.isEmpty)
                    const Center(
                      child: Text(
                        'No projects available.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio:
                                0.75, // Adjust this to fit content
                          ),
                      itemCount: _allProjects.length,
                      itemBuilder: (context, index) {
                        return _buildProjectCard(_allProjects[index]);
                      },
                    ),
                ],
              ),
            ),
    );
  }
}
