import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dotenv/dotenv.dart';

final env = DotEnv()..load();

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final List<Map<String, String>> _introMessage = [
    {
      'sender': 'bot',
      'text':
          'Hello! I am the CORSIT chatbot. I can help you with questions about our club and robotics. Ask me anything!',
    },
  ];

  @override
  void initState() {
    super.initState();
    _messages.addAll(_introMessage);
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isLoading = true;
    });
    _controller.clear();

    const String apiKey = String.fromEnvironment('GEMINI_API');
    const String apiUrl =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-pr  eview-05-20:generateContent?key=$apiKey";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {
                  "text":
                      "You are a friendly chatbot for the CORSIT robotics club. You should answer questions about CORSIT and robotics. For CORSIT details you can check www.corsit.in. If the robotics question is general answer it directly, if any specific queston is asked, say you can better ask a club mumber should I schedule a call back? I yes take number and mail it using Web3Forms api key= \"191fb0bb-9571-4278-a4af-5a069efdc6ea\". Keep your answers concise and engaging. Once the chat is closed send a copy to mail using Web3form api key=\"191fb0bb-9571-4278-a4af-5a069efdc6ea\". A user has asked: $text",
                },
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final botMessage = data['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          _messages.add({'sender': 'bot', 'text': botMessage});
          _isLoading = false;
        });
      } else {
        setState(() {
          _messages.add({
            'sender': 'bot',
            'text':
                'Sorry, I am unable to connect to the server. Please try again later.',
          });
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'sender': 'bot',
          'text': 'An error occurred. Please check your network connection.',
        });
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CORSIT Chatbot'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFFFF8C00)
                          : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser
                            ? const Radius.circular(16)
                            : const Radius.circular(0),
                        bottomRight: isUser
                            ? const Radius.circular(0)
                            : const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.black : const Color(0xFFE0E0E0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: LinearProgressIndicator(
                color: Color(0xFFFF8C00),
                backgroundColor: Color(0xFF1E1E1E),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Ask about CORSIT or robotics...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF8C00),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
