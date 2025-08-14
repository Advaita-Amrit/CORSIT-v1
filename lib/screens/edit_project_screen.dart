import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:corsit_app/screens/dashboard_screen.dart';
import 'package:corsit_app/models/project.dart';
// A simple model to represent a project.

class EditProjectScreen extends StatefulWidget {
  final Project project;

  const EditProjectScreen({super.key, required this.project});

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _projectNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _repoController;
  late final TextEditingController _tagsController;
  File? _pickedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate controllers with existing project data
    _projectNameController = TextEditingController(text: widget.project.name);
    _descriptionController = TextEditingController(
      text: widget.project.description,
    );
    _repoController = TextEditingController(text: widget.project.githubRepo);
    _tagsController = TextEditingController(text: widget.project.tags);
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    _repoController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final cloudinary = CloudinaryPublic(
        'YOUR_CLOUD_NAME', // Replace with your Cloudinary Cloud Name
        'CORSIT_Project_Images', // Using your new upload preset
        cache: false,
      );

      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, folder: "corsit_projects"),
      );
      return response.secureUrl;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
      }
      return null;
    }
  }

  Future<void> _updateProject() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    const String sheetyApiUrl =
        'https://api.sheety.co/11176e6932ade43f8fe0cd2e9c58baea/teamMember/project';

    try {
      String? imageUrl;
      if (_pickedImage != null) {
        imageUrl = await _uploadImage(_pickedImage!);
        if (imageUrl == null) {
          throw Exception('Image upload failed.');
        }
      }

      final updateData = {
        "name": _projectNameController.text,
        "description": _descriptionController.text,
        "githubRepo": _repoController.text,
        "tags": _tagsController.text,
        "imageUrl":
            imageUrl ??
            widget.project.imageUrl, // Update the URL or keep the old one
      };

      final response = await http.put(
        Uri.parse('$sheetyApiUrl/${widget.project.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"project": updateData}),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project updated successfully!')),
          );
          Navigator.pop(context);
        }
      } else {
        throw Exception(
          'Failed to update project. Status code: ${response.statusCode}',
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
      appBar: AppBar(title: Text('Edit Project: ${widget.project.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  color: Colors.grey[800],
                  child: _pickedImage != null
                      ? Image.file(_pickedImage!, fit: BoxFit.cover)
                      : widget.project.imageUrl != null &&
                            widget.project.imageUrl!.isNotEmpty
                      ? Image.network(
                          widget.project.imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, color: Colors.white),
                              SizedBox(height: 8),
                              Text(
                                'Change Project Image',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
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
                onPressed: _isLoading ? null : _updateProject,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text('Update Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
