import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VoiceChatPosition extends StatefulWidget {
  const VoiceChatPosition({super.key});

  @override
  State<VoiceChatPosition> createState() => _VoiceChatPositionState();
}

class _VoiceChatPositionState extends State<VoiceChatPosition> {
  @override
  Widget build(BuildContext context) {
    String textContent = "";
    double containerWidth = 60;
    double containerHeight = 60;
    return Positioned(
      bottom: 30, right: 16, left: 16,
      child: Container(
      width: containerWidth,
      height: containerHeight,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 62, 62, 63),
        shape: BoxShape.circle
      ),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
        },
        onLongPress: (){
          HapticFeedback.vibrate();
            setState(() {
            containerHeight = 80;
            containerWidth = 80;
          });
        },
        onLongPressEnd: (_){
          HapticFeedback.lightImpact();
          setState(() {
            containerHeight = 60;
            containerWidth = 60;
          });
        },
        
        child: Icon(Icons.mic, color: Colors.white,),
      ),
    ));
  }
}