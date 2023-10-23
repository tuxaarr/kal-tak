import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Team'),
        backgroundColor: isDarkMode ? Colors.deepPurple : Colors.teal, // Updated AppBar color
        actions: [
          _buildThemeSwitcher(),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              isDarkMode ? Colors.blue : Colors.teal, // Updated background gradient
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
              _buildCreatorInfo('Shivraj Kampani', '21BCE1595', 'Computer Science Engineering', '3rd', 'https://github.com/Shivkamp'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSwitcher() {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 500),
      crossFadeState: isDarkMode ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: _buildIconButton(Icons.light_mode),
      secondChild: _buildIconButton(Icons.dark_mode),
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
              'Team Members',
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.deepOrange : Colors.deepPurple,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreatorInfo(String name, String regNum, String course, String year, String githubLink) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _launchURL(githubLink);
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            elevation: 5.0,
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: isDarkMode ? Colors.teal : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    regNum,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: isDarkMode ? Colors.blue : Colors.black,
                    ),
                  ),
                  Text(
                    "$course - $year Year",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: isDarkMode ? Colors.blue : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
