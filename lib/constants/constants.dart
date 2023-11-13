import 'package:flutter/material.dart';
import 'package:flutter_diy_assistant/models/diy_project.dart';

import '../widgets/text_widget.dart';

Color scaffoldBackgroundColor = const Color(0xFF343541);
Color cardColor = const Color(0xFF444654);

final chatMessages = [
  {"msg": "Hello who are you?", "chatIndex": 0},
  {
    "msg": "Hello, I'm chat gpt, a large language model developed by OpenAi",
    "chatIndex": 1
  },
  {"msg": "Hello who are you?", "chatIndex": 0},
  {"msg": "Hello who are you?", "chatIndex": 1},
  {"msg": "Hello who are you?", "chatIndex": 0}
];

List<DiyProject> dummyProjects = [
  DiyProject(
      title: 'Make a Recycled Guitar',
      description:
          'Upcycle an empty shoebox and watch your little one explore making music with her very own homemade diy guitar! This classic guitar toy craft is a fun, hands-on way to get your child moving and grooving, while helping her understand how sound is produced. Learn how to make instruments with recycled materials here! ',
      materials: ['Shoebox', '3 rubber bands', '2 pencils', 'Sciccors'],
      instructions: [
        'Cut a circle out of the top of the shoebox.',
        'Stretch the rubber bands and place them around the box lengthwise, positioned over the hole.',
        'Insert the pencils horizontally under the rubber bands, one on each side of the circle.',
        'Pluck the rubber bands to make music.',
      ],
      imageUrl:
          "https://parents.azureedge.net/sites/default/files/public/styles/large/public/2022-07/parenting0001_012.jpg?itok=hsio6iOG",
      ageGroup: "all",
      craftingTimeInMinute: "40"),

  // Add more dummy projects as needed
  DiyProject(
      title: 'Pompom Ice Pops',
      description:
          'Check out these craft instructions and help your child make a fun and colorful pretend pom-pom ice treat.',
      materials: [
        'Cardstock',
        'Craft sticks',
        'Pom-poms',
        'Double-sided tape',
        '200mg of salt'
      ],
      instructions: [
        'Help your child cut an ice-pop shape out of cardstock.',
        'Tape the cardstock to a craft stick. Add tape.',
        'Press pom-poms onto the tape.'
      ],
      imageUrl:
          "https://parents.azureedge.net/sites/default/files/public/styles/3_2_large_420x280_/public/2022-04/parenting0093_001.jpg.webp?itok=-CVtnAjU",
      ageGroup: "all",
      craftingTimeInMinute: "30"),
  DiyProject(
      title: 'Easy-to-Make Prints with Blocks and Paint',
      description:
          'These easy-to-make block painting prints produce a beautiful finished product and are a lot of fun to do. Kids will enjoy making the picture on the foam, painting the foam, and then transferring the paint to the paper. They won’t know exactly what the finished product will look like until they’re done—but that’s part of the fun with this ccraft.',
      materials: [
        'Flat pieces of foam',
        'Pencil',
        'Acrylic paint',
        'Paintbrush (not a foam brush)',
        'Paper'
      ],
      instructions: [
        'Make sure your piece of foam is flat. Cut off any curved sides if you used a meat tray.',
        'Draw lightly the picture you want to appear. Remember that whatever you draw will come out in reverse.',
        'Go over the drawing to create grooves in the foam. Be careful not to press too hard.',
        'Brush a thin coat of paint on the foam.',
        'While the paint is moist, lay the paper over the painted tray, making sure not to move the paper once it’s down. Rub firmly and evenly on all parts of the paper.',
        'Peel the paper from the foam, and you have your print!'
      ],
      imageUrl:
          "https://parents.azureedge.net/sites/default/files/public/styles/3_2_large_420x280_/public/2022-05/parenting0107_001.jpg.webp?itok=Z8Kp1DN4",
      ageGroup: "all",
      craftingTimeInMinute: "30"),

  // Add more dummy projects as needed
];

// List<String> models = [
//   'Model1',
//   'Model2',
//   'Model3',
//   'Model4',
//   'Model5',
//   'Model6',
// ];

// List<DropdownMenuItem<String>>? get getModelsItem {
//   List<DropdownMenuItem<String>>? modelsItems =
//       List<DropdownMenuItem<String>>.generate(
//           models.length,
//           (index) => DropdownMenuItem(
//               value: models[index],
//               child: TextWidget(
//                 label: models[index],
//                 fontSize: 15,
//               )));
//   return modelsItems;
// }
