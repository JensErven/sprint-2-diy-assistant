import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diy_assistant/constants/constants.dart';
import 'package:flutter_diy_assistant/models/diy_project.dart';
import 'package:flutter_diy_assistant/services/assets_manager.dart';
import 'package:flutter_diy_assistant/widgets/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    Key? key,
    required this.msg,
    required this.chatIndex,
    this.shouldAnimate = false,
  }) : super(key: key);

  final String msg;
  final int chatIndex;
  final bool shouldAnimate;

  @override
  Widget build(BuildContext context) {
    final DiyProject? project = DiyProject.parseChatToDiyProject(msg);

    return Column(
      children: [
        if (project != null) _buildDiyProjectCard(project),
        // _buildMessageBubble(),
      ],
    );
  }

  Widget _buildDiyProjectCard(DiyProject project) {
    return Card(
      margin: EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(0.0),
              title: Text(
                project.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              subtitle: Text(
                project.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.timer),
                    SizedBox(width: 8),
                    Text(
                      '${project.craftingTimeInMinute}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 12),
                Row(
                  children: [
                    Icon(Icons.emoji_people),
                    SizedBox(width: 8),
                    Text(
                      '${project.ageGroup}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(
              'Materials:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Wrap(
              spacing: 12.0, // Horizontal spacing between tags
              runSpacing: -4.0, // Vertical spacing between tags
              children: List.generate(
                project.materials.length,
                (index) => Chip(
                  backgroundColor: Colors.grey,
                  label: Text(
                    project.materials[index],
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Instructions:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: project.instructions
                  .asMap()
                  .map((index, instruction) => MapEntry(
                        index,
                        ListTile(
                          leading: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.blue,
                            child: Text('${index + 1}'),
                          ),
                          title: Text(
                            instruction,
                          ),
                        ),
                      ))
                  .values
                  .toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveProject(project);
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 12.0), // Adjust the padding values as needed
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25.0), // Adjust the radius as needed
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.save, color: Colors.white),
                  SizedBox(width: 8.0),
                  Text("Save Project", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProject(DiyProject project) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> projects = prefs.getStringList('projects') ?? <String>[];
    projects.add(jsonEncode(project.toJson()));
    prefs.setStringList('projects', projects);
  }

  Widget _buildMessageBubble() {
    return Material(
      color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              chatIndex == 0 ? AssetManager.userImage : AssetManager.botImage,
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: chatIndex == 0
                  ? TextWidget(label: msg)
                  : shouldAnimate
                      ? DefaultTextStyle(
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                          child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            animatedTexts: [TyperAnimatedText(msg.trim())],
//                                   isRepeatingAnimation: false,
//                                   repeatForever: false,
//                                   displayFullTextOnTap: true,
//                                   totalRepeatCount: 1,
//                                   animatedTexts: [
//                                     TyperAnimatedText(
//                                       msg.trim(),
//                                     ),
//                                   ]),
                          ),
                        )
                      : Text(
                          msg.trim(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
            ),
            chatIndex == 0
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.thumb_up_alt_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.thumb_down_alt_outlined,
                        color: Colors.white,
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

// class ChatWidget extends StatelessWidget {
//   const ChatWidget(
//       {super.key,
//       required this.msg,
//       required this.chatIndex,
//       this.shouldAnimate = false});

//   final String msg;
//   final int chatIndex;
//   final bool shouldAnimate;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Material(
//           color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Image.asset(
//                   chatIndex == 0
//                       ? AssetManager.userImage
//                       : AssetManager.botImage,
//                   height: 30,
//                   width: 30,
//                 ),
//                 const SizedBox(
//                   width: 8,
//                 ),
//                 Expanded(
//                   child: chatIndex == 0
//                       ? TextWidget(
//                           label: msg,
//                         )
//                       : shouldAnimate
//                           ? DefaultTextStyle(
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 16),
//                               child: AnimatedTextKit(
//                                   isRepeatingAnimation: false,
//                                   repeatForever: false,
//                                   displayFullTextOnTap: true,
//                                   totalRepeatCount: 1,
//                                   animatedTexts: [
//                                     TyperAnimatedText(
//                                       msg.trim(),
//                                     ),
//                                   ]),
//                             )
//                           : Text(
//                               msg.trim(),
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 16),
//                             ),
//                 ),
//                 chatIndex == 0
//                     ? const SizedBox.shrink()
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         mainAxisSize: MainAxisSize.min,
//                         children: const [
//                           Icon(
//                             Icons.thumb_up_alt_outlined,
//                             color: Colors.white,
//                           ),
//                           SizedBox(
//                             width: 5,
//                           ),
//                           Icon(
//                             Icons.thumb_down_alt_outlined,
//                             color: Colors.white,
//                           )
//                         ],
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
