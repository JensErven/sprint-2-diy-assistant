import 'dart:convert';
import 'dart:developer';

class DiyProject {
  String title;
  String description;
  List<String> materials;
  List<String> instructions;
  String imageUrl;
  String craftingTimeInMinute;
  String ageGroup;

  DiyProject({
    required this.title,
    required this.description,
    required this.materials,
    required this.instructions,
    required this.imageUrl,
    required this.craftingTimeInMinute,
    required this.ageGroup,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'materials': materials,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'craftingTimeInMinute': craftingTimeInMinute,
      'ageGroup': ageGroup,
    };
  }

  factory DiyProject.fromJsonMap(Map<String, dynamic> json) {
    return DiyProject(
      title: json['title'],
      description: json['description'],
      materials: List<String>.from(json['materials']),
      instructions: List<String>.from(json['instructions']),
      imageUrl: json['imageUrl'],
      craftingTimeInMinute: json['craftingTimeInMinute'],
      ageGroup: json['ageGroup'],
    );
  }

  static DiyProject? parseChatToDiyProject(String message) {
    try {
      // Process the provided message directly
      final Map<String, dynamic> parsedJson = _parseMessage(message);

      // Use the parsed data to set the DiyProject properties
      return DiyProject(
        title: parsedJson['Title'],
        description: parsedJson['Description'],
        materials: List<String>.from(parsedJson['Materials']),
        instructions: List<String>.from(parsedJson['Instructions']),
        imageUrl: '', // Set an image URL if available
        craftingTimeInMinute: parsedJson['TimeToMake'],
        ageGroup: parsedJson['AgeGroup'],
      );
    } catch (e) {
      print('Error parsing DIY project: $e');
      return null; // Return null if there's an error in parsing
    }
  }

  // Function to process the message into a map
  static Map<String, dynamic> _parseMessage(String message) {
    final Map<String, dynamic> parsedJson = {};

    // Split the message by new line and process each line
    message.split('\n').forEach((line) {
      final keyValue = line.split(':');
      if (keyValue.length == 2) {
        final key = keyValue[0].trim();
        var value = keyValue[1].trim();

        if (key == 'Materials') {
          value = value.replaceAll(']', '').replaceAll('[', ''); //
          parsedJson[key] = value
              .split('",')
              .where((element) => element.trim().isNotEmpty)
              .toList();
        } else if (key == 'Instructions') {
          value = value
              .replaceAll(']', '')
              .replaceAll('[', ''); // Remove any quotes
          parsedJson[key] = value
              .split('",')
              .where((element) => element.trim().isNotEmpty)
              .toList();
        } else {
          parsedJson[key] = value
              .replaceAll('",', '')
              .replaceAll('"', ''); // Remove quotes from title and description
        }
      }
    });

    return parsedJson;
  }

  static fromJson(projectJson) {}
}
