import 'package:flutter/material.dart';
import 'second.dart';
import 'third.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        backgroundColor: isDarkMode ? Colors.deepPurple : Colors.teal,
        actions: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 500),
            crossFadeState: isDarkMode ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: _buildIconButton(Icons.light_mode),
            secondChild: _buildIconButton(Icons.dark_mode),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              isDarkMode ? Colors.blue : Colors.teal,
              isDarkMode ? Colors.black : Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildWelcomeText(),
              const SizedBox(height: 20.0),
              _buildText('Explore the Latest News', 20.0, Colors.black),
              const SizedBox(height: 30.0),
              Row(
                // Place the buttons in a Row widget
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildElevatedButton('Check News', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SecondPage(),
                      ),
                    );
                  }),
                  const SizedBox(width: 20.0), // Add spacing between buttons
                  _buildElevatedButton('About Team', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ThirdPage(),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        setState(() {
          isDarkMode = !isDarkMode;
        });
      },
    );
  }

  Widget _buildWelcomeText() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: value,
            child: Text(
              'Welcome to Our App',
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.teal : Colors.deepPurple,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildText(String text, double fontSize, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }

  Widget _buildElevatedButton(String text, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: isDarkMode ? Colors.blue : Colors.teal,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
