import 'dart:developer';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  stt.SpeechToText speech = stt.SpeechToText();
  List<String> commandQueue = []; // Maintains a queue of commands
  bool isSpeechAvailable = false;

  Future<void> startListening() async {
    await initializeSpeech();
    if (speech.isAvailable) {
      log("start listening");
      speech.listen(
        onResult: (result) {
          log("Recognized Words: ${result.recognizedWords}");
          if (result.finalResult) {
            commandQueue.add(result.recognizedWords);
            executeNextCommand();
          }
        },
      );
      log("start listening again test");
    } else {
      log("Speech recognition not available");
      isSpeechAvailable = false; // Set availability status
    }
  }

  Future<void> initializeSpeech() async {
    if (!speech.isAvailable) {
      final isInitialized = await speech.initialize();
      isSpeechAvailable = isInitialized;
    }
  }

  void executeNextCommand() {
    if (commandQueue.isNotEmpty) {
      String command = commandQueue.removeAt(0);
      // Process the recognized voice command here
      if (command == 'lights on') {
        log("lights are ON");
        // Execute the function to turn on the light
      } else if (command == 'lights off') {
        log("lights are OFF");
      } else if (command == 'start timer') {
        // Start a timer
      } else if (command == 'stop listening') {
        stopListening();
      }
      executeNextCommand(); // Continue with the next command
    }
  }

  void stopListening() {
    speech.stop();
    log("stopped listening");
  }
}
