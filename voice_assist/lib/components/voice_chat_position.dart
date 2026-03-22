import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:voice_assist/provider/provider.dart';
import 'package:provider/provider.dart';

class VoiceChatPosition extends StatefulWidget {
  const VoiceChatPosition({super.key});

  @override
  State<VoiceChatPosition> createState() => _VoiceChatPositionState();
}

class _VoiceChatPositionState extends State<VoiceChatPosition>
    with SingleTickerProviderStateMixin {
  double containerSize = 60;
  bool isPressed = false;

  late AnimationController _controller;
  final audioRecorder = AudioRecorder();
  String? audioPath;
  File? voiceFile;
  String content = "";
  bool isVoiceMode = true;
  final TextEditingController _textController = TextEditingController();

  Future<void> sendText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final provider = Provider.of<ContentProvider>(context, listen: false);

    final data = {"type": "text", "text": text};
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.11:8000/api/v1/upload/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        setState(() {
          content = jsonDecode(response.body)['text'] ?? "";
          provider.updateMessage(content);
        });
        _textController.clear();
      } else {
        provider.updateMessage("");
      }
    } catch (e) {
      log("Error sending text: $e");
    }
  }

  Future<void> startRecording() async {
    if (await Permission.microphone.request().isGranted) {
      if (await audioRecorder.isEncoderSupported(AudioEncoder.aacLc)) {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/voice_message.aac';
        await audioRecorder.start(const RecordConfig(), path: filePath);
      }
    }
  }

  Future<void> stopRecording() async {
    audioPath = await audioRecorder.stop();
    voiceFile = File(audioPath!);

    if (await voiceFile!.exists()) {
      log("Audio recorded at path: $audioPath");
      await sendFile();
    } else {
      log("File does not exist at path: $audioPath");
    }
  }

  Future<void> sendFile() async {
    String? base64voice;
    if (voiceFile != null) {
      final bytes = await voiceFile!.readAsBytes();
      final mimeType = lookupMimeType(voiceFile!.path) ?? 'audio/aac';
      final base64Str = base64Encode(bytes);
      base64voice = 'data:$mimeType;base64,$base64Str';
    }
    final data = {"type": "voice", "audio": base64voice};
    final provider = Provider.of<ContentProvider>(context, listen: false);
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.11:8000/api/v1/upload/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );
      log(
        "message: HTTP response status: ${response.statusCode}, body: ${response.body}",
      );
      if (response.statusCode == 200) {
        setState(() {
          content = jsonDecode(response.body)['text'] ?? "";

          provider.updateMessage(content);
        });
      } else {
        provider.updateMessage("");
        log("Failed to send file: ${response.statusCode}");
      }
    } catch (e) {
      log("Error sending file: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    audioRecorder.dispose();
    _textController.dispose();
    super.dispose();
  }

  void startAnimation() {
    _controller.repeat();
  }

  void stopAnimation() {
    _controller.stop();
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      right: 16,
      left: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Toggle Option
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 30, 30, 30),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isVoiceMode = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isVoiceMode
                          ? const Color.fromARGB(255, 62, 62, 63)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.mic,
                      color: isVoiceMode ? Colors.white : Colors.white54,
                      size: 20,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isVoiceMode = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: !isVoiceMode
                          ? const Color.fromARGB(255, 62, 62, 63)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: !isVoiceMode ? Colors.white : Colors.white54,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Input Area
          isVoiceMode ? _buildVoiceInput() : _buildTextInput(),
        ],
      ),
    );
  }

  Widget _buildVoiceInput() {
    return Center(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
        },
        onLongPress: () {
          HapticFeedback.vibrate();
          setState(() {
            isPressed = true;
            containerSize = 80;
          });
          startAnimation();
          startRecording();
        },
        onLongPressEnd: (_) {
          HapticFeedback.lightImpact();
          setState(() {
            isPressed = false;
            containerSize = 60;
          });
          stopAnimation();
          stopRecording();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 62, 62, 63),
            shape: BoxShape.circle,
            boxShadow: isPressed
                ? [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ]
                : [],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 🔵 Rotating border
              if (isPressed)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    return Transform.rotate(
                      angle: _controller.value * 6.3, // 2π
                      child: CustomPaint(
                        size: Size(containerSize, containerSize),
                        painter: RingPainter(),
                      ),
                    );
                  },
                ),

              // 🎤 Mic icon
              const Icon(Icons.mic, color: Colors.white, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 62, 62, 63),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _textController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => sendText(),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 62, 62, 63),
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
            icon: const Icon(Icons.send, color: Colors.white54),
            onPressed: sendText,
          ),
          )
        ],
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawArc(rect, 0, 3.5, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
