import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:corsit_app/models/team_member.dart';

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
      appBar: AppBar(title: const Text('Team')),
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
            ..._members.asMap().entries.map(
              (entry) => _buildTeamMember(entry.key),
            ),
          ],
        ),
      ),
    );
  }
}
