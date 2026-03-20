import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewChatScreen extends StatelessWidget {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
        "Hello, I am your voice assistant. How can I help you today?",
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(color: Colors.white54, fontSize: 16, decoration: TextDecoration.none),
      ),
      )
    );
  }
}
