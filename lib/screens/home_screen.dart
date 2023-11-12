import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_diy_assistant/constants/constants.dart';
import 'package:flutter_diy_assistant/models/diy_project.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:speech_to_text/speech_to_text.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DIY Projects'),
      ),
      body: ListView.builder(
        itemCount: dummyProjects.length,
        itemBuilder: (context, index) {
          DiyProject project = dummyProjects[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the details page when a project card is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailsScreen(project: project),
                ),
              );
            },
            child: ProjectCard(project: project),
          );
        },
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final DiyProject project;

  const ProjectCard({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(24.0), // Rounded corners for the card
      ),
      child: Row(
        children: [
          // Rounded corners for the image
          Padding(
              padding: const EdgeInsets.all(6.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  project.imageUrl,
                  fit: BoxFit.cover,
                  width: 110,
                  height: 110,
                ),
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.timer),
                          const SizedBox(width: 4),
                          Text('${project.craftingTimeInMinute} min'),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Icon(Icons.emoji_people),
                          const SizedBox(width: 4),
                          Text('${project.ageGroup}'),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectDetailsScreen extends StatefulWidget {
  final DiyProject project;

  const ProjectDetailsScreen({Key? key, required this.project})
      : super(key: key);

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final SpeechToText _speechToText = SpeechToText();
  FlutterTts flutterTts = FlutterTts();

  int _stepIndex = 0; // New state variable to keep track of the step index

  // Set a duration of inactivity before restarting listening
  final Duration inactivityThreshold = Duration(seconds: 10);
  Timer? inactivityTimer;

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;
  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    if (!_speechToText.isListening && _speechEnabled) {
      await _speechToText.listen(
        onResult: (result) {
          _onSpeechResult(result);
        },
      );
      setState(() {
        _confidenceLevel = 0;
      });
    }
  }

  void _stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
      setState(() {});
    }
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
      _confidenceLevel = result.confidence;
    });
    _startListening();
    flutterTts.stop();

    if (_wordsSpoken.toLowerCase().contains("stop helping")) {
      log('stopped listening');
      _stopListening();
    } else {
      _processCommands();

      // Clear the previous timer
      inactivityTimer?.cancel();

      // Restart listening after a brief period of inactivity
      inactivityTimer = Timer(inactivityThreshold, () {
        _stopListening();
        _startListening();
      });
    }
  }

  void _processCommands() {
    if (_containsAny(_wordsSpoken, [
      "materials",
      "repeat materials",
      "say materials",
      "all materials",
      "read materials"
    ])) {
      log('Repeating materials:');
      _speakMaterials(widget.project.materials);
    } else if (_containsAny(_wordsSpoken, [
      "instructions",
      "repeat instructions",
      "read instructions",
      "read steps",
      "repeat steps",
      "steps"
    ])) {
      log('Instructions');
      _speakInstructions(widget.project.instructions);
    } else if (_wordsSpoken.toLowerCase().contains("next step")) {
      _readNextStep();
    } else if (_wordsSpoken.toLowerCase().contains("previous step")) {
      _readPreviousStep();
    } else if (_containsAny(_wordsSpoken, ["finished", "done"])) {
      _finishProject();
    } else if (_wordsSpoken.toLowerCase().contains("stop")) {
      flutterTts.stop();
    }
  }

  void _readNextStep() {
    if (_stepIndex < widget.project.instructions.length - 1) {
      _stepIndex++;
      _speakInstruction(widget.project.instructions, _stepIndex);
    } else {
      textToSpeech("You have reached the last step.");
    }
  }

  void _readPreviousStep() {
    if (_stepIndex > 0) {
      _stepIndex--;
      _speakInstruction(widget.project.instructions, _stepIndex);
    } else {
      textToSpeech("You are at the beginning.");
    }
  }

  bool _containsAny(String text, List<String> commands) {
    for (var command in commands) {
      if (text.toLowerCase().contains(command)) {
        return true;
      }
    }
    return false;
  }

  void _finishProject() {
    textToSpeech(
        "Congratulations on completing this project! I hope to assist you with more projects in the future. It was a pleasure!");
    _stopListening();
  }

  void _speakMaterials(List<String> materials) {
    if (materials.isNotEmpty) {
      _speakMaterial(materials, 0);
    }
  }

  void _speakMaterial(List<String> materials, int index) {
    if (index < materials.length) {
      flutterTts.setCompletionHandler(() {
        _speakMaterial(materials, index + 1);
      });
      flutterTts.speak(materials[index]);
    }
  }

  void _speakInstructions(List<String> instructions) {
    if (instructions.isNotEmpty) {
      _speakInstruction(instructions, 0);
    }
  }

  void _speakInstruction(List<String> instructions, int index) {
    if (index < instructions.length) {
      flutterTts.setCompletionHandler(() {
        _speakInstruction(instructions, index + 1);
      });
      flutterTts.speak("Step ${index + 1} ${instructions[index]}");
    }
  }

  void textToSpeech(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.title),
      ),
      body: DefaultTabController(
        length: 2,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.project.imageUrl,
                width: double.infinity, // Full width
                height: 250, // Set a fixed height for better appearance
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                widget.project.description,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Recognized speech: ${_wordsSpoken}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Row(
                children: [
                  Icon(Icons.timer),
                  const SizedBox(width: 4),
                  Text('${widget.project.craftingTimeInMinute} min'),
                  const SizedBox(width: 16),
                  Icon(Icons.emoji_people),
                  const SizedBox(width: 4),
                  Text('${widget.project.ageGroup}'),
                ],
              ),
              const SizedBox(height: 16),
              TabBar(
                tabs: [
                  Tab(
                      text:
                          "What You'll Need"), // You can add more tabs as needed
                  Tab(text: 'Instructions'),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 300, // Set a fixed height for better appearance
                child: TabBarView(
                  children: [
                    buildMaterialsTab(),
                    buildInstructionsTab(),
                    // You can add more TabBarViews as needed
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Tooltip(
        padding: EdgeInsets.all(8.0),
        message: 'Start Craft Assistant',
        child: FloatingActionButton.extended(
          onPressed: () {
            _speechToText.isListening ? _stopListening() : _startListening();
            setState(() {});
            // Handle the "Start Craft Assistant" button press
            // Add your desired functionality here
          },
          label: Text(!_speechToText.isListening
              ? 'Start Craft Assistant'
              : 'Stop Craft Assistant'),
          icon: Icon(!_speechToText.isListening
              ? Icons.play_circle_fill
              : Icons.stop_circle_rounded),
        ),
      ),
    );
  }

  Widget buildInstructionsTab() {
    return ListView.builder(
      itemCount: widget.project.instructions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.blue,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.project.instructions[index],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildMaterialsTab() {
    // Implement your materials tab content here
    return ListView.builder(
      itemCount: widget.project.materials.length,
      itemBuilder: (context, index) {
        bool isChecked =
            false; // You can set the initial checked state as needed

        return CheckboxListTile(
          title: Text(
            widget.project.materials[index],
            style: const TextStyle(fontSize: 16),
          ),
          value: isChecked,
          onChanged: (value) {
            // Handle checkbox state change if needed
            // You can use the value parameter to update the checked state
            // For example: setState(() { isChecked = value; });
          },
          controlAffinity: ListTileControlAffinity.leading,
        );
      },
    );
  }
}
