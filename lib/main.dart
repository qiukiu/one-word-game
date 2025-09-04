import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const OneWordApp());
}

class OneWordApp extends StatelessWidget {
  const OneWordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Word Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080'),
  );
  final List<String> _words = [];

  void _sendWord() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text.trim());
      _controller.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _channel.stream.listen((message) {
      setState(() {
        _words.add(message);
      });
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("One Word Game")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _words.map((w) => ListTile(title: Text(w))).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter your word",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendWord,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
