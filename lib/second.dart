import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.blue,
      brightness: Brightness.light,
      textTheme: TextTheme(
        bodyText1: const TextStyle(
          color: Colors.black,
        ),
        bodyText2: TextStyle(
          color: Colors.grey[700],
        ),
      ),
    ),
    home: const SecondPage(),
  ));
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> newsList = [];
  bool isDarkMode = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    fetchNews();
  }

  Future<void> fetchNews() async {
    const apiKey = 'd654e63397870dae6bdc503f71d67009';
    final Uri uri = Uri.parse('https://gnews.io/api/v4/top-headlines?lang=en&token=$apiKey');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        newsList = List<Map<String, dynamic>>.from(data['articles']);
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Today'),
        backgroundColor: isDarkMode ? Colors.deepPurple : Colors.teal,
        actions: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 500),
            crossFadeState: isDarkMode ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: IconButton(
              icon: const Icon(Icons.light_mode),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
            secondChild: IconButton(
              icon: const Icon(Icons.dark_mode),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchNews();
        },
        child: Container(
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
          child: ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final article = newsList[index];
              _animationController.reset();
              _animationController.forward();
              return FadeTransition(
                opacity: _animationController.drive(Tween(begin: 0.0, end: 1.0)),
                child: CustomListItem(article: article),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class CustomListItem extends StatelessWidget {
  final Map<String, dynamic> article;

  const CustomListItem({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white, // Background color
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(26, 26, 26, 0.1),
              offset: Offset(0, 2),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Card(
          elevation: 0.0,
          child: ListTile(
            title: Text(
              article['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            subtitle: Text(
              article['description'] ?? '',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () async {
              if (await canLaunch(article['url'])) {
                await launch(article['url']);
              } else {
                throw 'Could not launch ${article['url']}';
              }
            },
          ),
        ),
      ),
    );
  }
}
