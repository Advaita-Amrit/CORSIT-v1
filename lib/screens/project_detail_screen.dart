import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:corsit_app/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final imageList = project.imageUrl?.split(', ').toList() ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(project.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery
            if (imageList.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageList[index],
                          width: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 60,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (imageList.isNotEmpty) const SizedBox(height: 20),

            Text(
              project.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Tags
            Text(
              'Tags: ${project.tags}',
              style: const TextStyle(
                color: Color(0xFFFF8C00),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),

            // Description
            const Text(
              'Details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(project.description),
            const SizedBox(height: 16),

            // Developer
            const Text(
              'Developer:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(project.developer),
            const SizedBox(height: 16),

            // GitHub Repo
            if (project.githubRepo.isNotEmpty)
              ElevatedButton.icon(
                icon: const Icon(Icons.code),
                label: const Text('View on GitHub'),
                onPressed: () async {
                  final url = Uri.parse(project.githubRepo);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not open GitHub link.'),
                        ),
                      );
                    }
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
