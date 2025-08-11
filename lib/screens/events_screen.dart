import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  Widget _buildEventCard(
    String title,
    String description,
    String date,
    String time,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF8C00).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFFFF8C00), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFE0E0E0),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$date at $time',
                      style: const TextStyle(
                        color: Color(0xFFE0E0E0),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(color: Color(0xFFE0E0E0), fontSize: 14),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C00),
              foregroundColor: Colors.black,
            ),
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Events',
              style: TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildEventCard(
              'Robotics Workshop',
              'CORSIT offers free workshops on IoT, Arduino, cloud, and more, providing students with hands-on experience in building basic bots suchs as LFR, Bluetooth, and obstacle-avoiding bots. Participants learn to code and use different components to program the bots brain. The club also conducts a paid workshop where a mentor guides students on emerging technologies with a mix of studio practice and lectures. The workshop aims to enhance practical skills and teach the theory and context behind the practice.',
              'Yet to be announced',
              'Yet to be announced',
              Icons.school,
            ),
            _buildEventCard(
              'RoboCor',
              'Robocor, a nationally renowned Robotics Competition, which is one of the biggest events in Karnataka. It provides a platform for participants to showcase their innovative designs and compete for glory. In Robocor, the team has successfully organized several events such as Dcode, Spardha, Rugged Rage, Robo Soccer, Arduino Clash, Binary Rash, Project Symposium, Paper Presentation, and Init_Rc.',
              'Yet to be announced',
              'Yet to be announced',
              Icons.emoji_events,
            ),
            _buildEventCard(
              'RoboExpo',
              'ROBOEXPO is an annual event organized by the Robotics club of SIT CORSIT. The primary objective is to introduce the club and its activities to the newcomers by displaying the bots that the members have created over the year. The event showcases various bots such as Line Follower Robots (LFR), Roboracer, Gesture controlled bots, Bluetooth controlled bots, etc. The exhibition provides students with an opportunity to witness and understand the workings of these bots up close. It serves as an excellent platform for the Robotics club to attract new members who are interested in this field.',
              'Yet to be announced',
              'Yet to be announced',
              Icons.person,
            ),
          ],
        ),
      ),
    );
  }
}
