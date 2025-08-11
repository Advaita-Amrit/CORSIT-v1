import 'package:flutter/material.dart';

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
