import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:voice_assist/provider/provider.dart';
import 'package:flutter/services.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContentProvider>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 25, 18, 18),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 12, 12, 12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              child: Text(
                provider.content,
                style: GoogleFonts.mPlus1Code(
                  color: Colors.white54,
                  fontSize: 16,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.copy, size: 15, color: Colors.white54),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: provider.content));
              },
            ),
          ),
        ],
      ),
    );
  }
}
