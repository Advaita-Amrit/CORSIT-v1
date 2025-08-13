import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:corsit_app/models/user_session.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _repoController = TextEditingController();
  final _tagsController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    _repoController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _addProject() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Updated with the Sheety API URL for POST requests to the 'project' sheet
    const String sheetyApiUrl =
        'https://api.sheety.co/11176e6932ade43f8fe0cd2e9c58baea/teamMember/project';

    final user = UserSession().currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be logged in to add a project.'),
          ),
        );
      }
      setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(sheetyApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          // The key for the data object must match the sheet name, which is 'project'
          "project": {
            "name": _projectNameController.text,
            "description": _descriptionController.text,
            "githubRepo": _repoController.text,
            "tags": _tagsController.text,
            "submittedBy":
                user['username'], // Add the logged-in user's username
          },
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project added successfully!')),
          );
          Navigator.pop(context); // Go back to the previous screen
        }
      } else {
        throw Exception(
          'Failed to add project. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Project')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _projectNameController,
                decoration: const InputDecoration(labelText: 'Project Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a project name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _repoController,
                decoration: const InputDecoration(
                  labelText: 'GitHub Repository URL',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (e.g., flutter, web, ai)',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _addProject,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text('Submit Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
