import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_assist/container/home.dart';
import 'package:voice_assist/provider/provider.dart';

void main() {
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ContentProvider(),
      child: const MyApp()
    )
    );
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
