import 'package:flutter/material.dart';
import 'themes.dart';

class ThemeScreen extends StatefulWidget {
  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  ThemeData? _currentTheme;

  @override
  void initState() {
    super.initState();
    _currentTheme = ThemeMode.system == ThemeMode.light ? lightTheme : darkTheme;
  }

  void _setTheme(ThemeData? theme) {
    if (theme != null) {
      setState(() {
        _currentTheme = theme;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _currentTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Theme Switcher'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Light Theme'),
              leading: Radio<ThemeData>(
                value: lightTheme,
                groupValue: _currentTheme,
                onChanged: _setTheme,
              ),
            ),
            Divider(), 
            ListTile(
              title: Text('Dark Theme'),
              leading: Radio<ThemeData>(
                value: darkTheme,
                groupValue: _currentTheme,
                onChanged: _setTheme,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
