import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Required for JSON decoding
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// A simple model to represent a team member, with optional fields
// that can be fetched from the API.
class TeamMember {
  final String name;
  final String role;
  final String year;
  final String? profilePhotoUrl; // Added profile photo URL field

  TeamMember({
    required this.name,
    required this.role,
    required this.year,
    this.profilePhotoUrl,
  });

  // Factory constructor to create a TeamMember from a JSON map
  factory TeamMember.fromJson(Map<String, dynamic> json) {
    // Correctly mapping the JSON keys to the TeamMember model.
    // The keys from your Sheety API response are in lowercase.
    // We now try to parse the 'year' string into an integer.
    // String yearValue = '';
    // if (json['year'] is String) {
    //   // Assuming the format is "Xth Year" or similar, we extract the first digit.
    //   // If parsing fails, it defaults to 0.
    //   yearValue = int.tryParse(json['year'].toString().split(' ')[0]) ?? 0;
    // } else if (json['year'] is int) {
    //yearValue = json['year'];
    // }

    return TeamMember(
      name: json['name'] ?? 'No Name',
      role: json['role'] ?? 'Member',
      year: json['year'] ?? ' ',
      profilePhotoUrl: json['profilePhoto'] as String?,
    );
  }
}

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  List<TeamMember> _members = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTeamMembers();
  }

  // Asynchronous function to fetch team members from the Sheety API
  Future<void> _fetchTeamMembers() async {
    // The API URL provided in our last conversation.
    const String apiUrl =
        'https://api.sheety.co/11176e6932ade43f8fe0cd2e9c58baea/teamMember/credentials';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // The list of members is under the key 'credentials'
        final List<dynamic> jsonData = responseData['credentials'] ?? [];

        setState(() {
          _members = jsonData
              .map((jsonMember) => TeamMember.fromJson(jsonMember))
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load team members');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch team members: $e')),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  // A helper widget to build a single team member card
  Widget _buildTeamMember(TeamMember member) {
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
          // Display a square profile photo
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFFF8C00),
            ),
            child:
                member.profilePhotoUrl != null &&
                    member.profilePhotoUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      member.profilePhotoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            'Image not found',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Text(
                      'Image not found',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
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
                  member.year,
                  style: const TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Implement messaging functionality
            },
            icon: Image.asset('assets/icons/linkedin.png'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                  if (_members.isEmpty)
                    const Center(
                      child: Text(
                        'No team members found.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    ..._members.map((member) => _buildTeamMember(member)),
                ],
              ),
            ),
    );
  }
}
