import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatInputPosition extends StatelessWidget {
  const ChatInputPosition({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
            bottom: 30, right: 16, left: 16,
            child: Row( 
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 52, 51, 51),
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: TextField(
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      // contentPadding: EdgeInsets.zero,
                      isDense: true,
                      hintText: "Type your message here",
                      hintStyle: GoogleFonts.poppins(color: const Color.fromARGB(101, 255, 255, 255), fontSize: 16, decoration: TextDecoration.none),
                      border: InputBorder.none
                    ),
                  ),
                ),
                SizedBox(width: 8,),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 62, 62, 63),
                    shape: BoxShape.circle
                  ),
                  child: Icon(Icons.send, color: Colors.white,),
                )
              ],
            ),);
  }
}