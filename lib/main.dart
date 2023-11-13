import 'package:flutter/material.dart';
import 'package:flutter_diy_assistant/constants/constants.dart';
import 'package:flutter_diy_assistant/providers/chat_provider.dart';
import 'package:flutter_diy_assistant/providers/models_provider.dart';
import 'package:flutter_diy_assistant/screens/chat_screen.dart';
import 'package:flutter_diy_assistant/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter ChatBOT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(
            color: cardColor,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              // Example: Change the default font to Roboto
              fontFamily: 'Roboto', // Update with the desired font family
              fontSize: 28, // Adjust as needed
              color: Colors.white, // Set the default text color
              // Additional text styling properties
            ),
          ),
        ),
        home: const AppMainScreen(),
      ),
    );
  }
}

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  _AppMainScreenState createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int _currentIndex = 0; // Index to track the selected tab

  final List<Widget> _screens = [const Homescreen(), const ChatScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Handle tab selection
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icon for the Homescreen
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create), // Icon for the ChatScreen
            label: 'Generate',
          )
        ],
      ),
    );
  }
}
