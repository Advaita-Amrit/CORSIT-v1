import 'dart:convert';

// A simple model to represent a project.
class Project {
  final int id; // The row ID from Sheety, crucial for PUT/DELETE requests
  final String name;
  final String description;
  final String githubRepo;
  final String tags;
  final String submittedBy;
  final String? imageUrl;
  final String developer;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.githubRepo,
    required this.tags,
    required this.submittedBy,
    this.imageUrl,
    required this.developer,
  });

  // Factory constructor to create a Project from a JSON map
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'No Name',
      description: json['details'] ?? '',
      githubRepo: json['githubRepo'] ?? '',
      tags: json['tags'] ?? '',
      submittedBy: json['author'] ?? '',
      imageUrl: json['photos'] as String?,
      developer: json['developer'] ?? '',
    );
  }
}
