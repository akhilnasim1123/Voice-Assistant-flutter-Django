import 'package:flutter/material.dart';
import 'package:voice_assist/container/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Assistant',
      home: VoiceAssitant(),
      theme: ThemeData(
        brightness:Brightness.dark
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
    );
  }
}
