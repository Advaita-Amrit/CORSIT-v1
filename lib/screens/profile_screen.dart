import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Corrected import
import 'dart:convert';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:corsit_app/models/user_session.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _pickedImage;
  bool _isLoading = false;
  bool _isPasswordChanging = false;

  final user = UserSession().currentUser;

  @override
  void initState() {
    super.initState();
    // Pre-populate the name field with the current user's name
    _nameController.text = user?['name'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() => _pickedImage = File(image.path));
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final cloudinary = CloudinaryPublic(
        'dn5unnavq', // Replace with your Cloudinary Cloud Name
        'corsit_profiles', // Upload preset name from your Cloudinary settings
        cache: false,
      );

      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, folder: "corsit_profiles"),
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

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate() || user == null) return;
    setState(() => _isLoading = true);

    try {
      String? photoUrl;
      if (_pickedImage != null) {
        photoUrl = await _uploadImage(_pickedImage!);
      }

      final updateData = {
        'name': _nameController.text,
        // Send the new URL or keep the existing one if no new photo was picked
        'profilePhoto': photoUrl ?? user!['profilePhoto'],
      };

      const String sheetyApiUrl =
          'https://api.sheety.co/11176e6932ade43f8fe0cd2e9c58baea/teamMember/credentials';
      final int rowId = user!['id'];

      final http.Response sheetyResponse = await http.put(
        Uri.parse('$sheetyApiUrl/$rowId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"credential": updateData}),
      );

      if (sheetyResponse.statusCode == 200) {
        // Update the local session data with the new values
        UserSession().login({
          ...user!,
          'name': _nameController.text,
          'profilePhoto': photoUrl ?? user!['profilePhoto'],
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
        }
      } else {
        throw Exception('Failed to update profile on Sheety.');
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

  // New function to handle password change
  Future<void> _changePassword() async {
    if (_passwordController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a new password.')),
        );
      }
      return;
    }

    if (_passwordController.text.length < 6) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password must be at least 6 characters.'),
          ),
        );
      }
      return;
    }

    setState(() => _isPasswordChanging = true);

    try {
      if (user == null) {
        throw Exception("User not logged in.");
      }

      const String sheetyApiUrl =
          'https://api.sheety.co/11176e6932ade43f8fe0cd2e9c58baea/teamMember/credentials';
      final int rowId = user!['id'];

      final http.Response sheetyResponse = await http.put(
        Uri.parse('$sheetyApiUrl/$rowId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "credential": {"password": _passwordController.text},
        }),
      );

      if (sheetyResponse.statusCode == 200) {
        // Update the local session data with the new password
        UserSession().login({...user!, 'password': _passwordController.text});
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully!')),
          );
          _passwordController.clear();
        }
      } else {
        throw Exception('Failed to change password on Sheety.');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isPasswordChanging = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFFFF8C00),
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : user?['profilePhoto'] != null &&
                            user!['profilePhoto'].isNotEmpty
                      ? NetworkImage(user!['profilePhoto'] as String)
                      : null,
                  child:
                      _pickedImage == null &&
                          (user?['profilePhoto'] == null ||
                              user!['profilePhoto'].isEmpty)
                      ? const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 40,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Username: ${user?['username'] ?? 'N/A'}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFFFF8C00),
                  foregroundColor: Colors.black,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text('Update Name & Photo'),
              ),
              const SizedBox(height: 40),
              const Text(
                'Change Password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return 'Password must be at least 6 characters.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isPasswordChanging ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFFFF8C00),
                  foregroundColor: Colors.black,
                ),
                child: _isPasswordChanging
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
