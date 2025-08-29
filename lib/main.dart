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
