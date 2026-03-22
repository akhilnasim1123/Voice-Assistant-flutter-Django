import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_assist/components/content_screen.dart';
import 'package:voice_assist/components/new_chat_screen.dart';
import 'package:voice_assist/components/voice_chat_position.dart';
import 'package:voice_assist/provider/provider.dart';
import 'package:provider/provider.dart';

class VoiceAssitant extends StatefulWidget {
  const VoiceAssitant({super.key});

  @override
  State<VoiceAssitant> createState() => _VoiceAssitantState();
}

class _VoiceAssitantState extends State<VoiceAssitant> {
  
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContentProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  const Color.fromARGB(255, 20, 20, 20),
        title: Text("Voice Assistant", style: GoogleFonts.poppins(color: Colors.white, fontSize: 20,)),
      ),
      body: Container(
      decoration: BoxDecoration(
              color: const Color.fromARGB(255, 20, 20, 20),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 20, 20, 20),
            ),
            child:provider.content.isEmpty ? NewChatScreen() : ContentScreen()
            ,
          ),
          VoiceChatPosition()
        ],
      )
    ),
    );
  }
}