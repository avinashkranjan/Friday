import 'package:flutter/material.dart';
import 'package:friday/screens/theme_screen.dart';
import 'help_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('User'),
            onTap: () {
              // Navigate to user settings screen
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              // Navigate to notification settings screen
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_display_sharp),
            title: Text('Theme'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThemeScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            onTap: () {
              // Navigate to language settings screen
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('FAQs'),
            onTap: () {
              // Navigate to FAQs screen
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
