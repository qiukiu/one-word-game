import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const OneWordApp());
}

class OneWordApp extends StatelessWidget {
  const OneWordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Word Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final TextEditingController _controller = TextEditingController();
  final String gameId = "demo-game"; // temporary shared room
  final String playerId = DateTime.now().millisecondsSinceEpoch.toString();

  void _submitWord() async {
    if (_controller.text.isEmpty) return;

    final roundRef = FirebaseFirestore.instance
        .collection('games')
        .doc(gameId)
        .collection('rounds')
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    await roundRef.set({
      'playerId': playerId,
      'word': _controller.text.trim().toLowerCase(),
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("One Word Game")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('games')
                  .doc(gameId)
                  .collection('rounds')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['word'] ?? ''),
                      subtitle: Text("Player: ${data['playerId']}"),
                    );
                  },
                );
              },
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
                  onPressed: _submitWord,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
