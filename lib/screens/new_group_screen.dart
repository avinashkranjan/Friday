import 'package:flutter/material.dart';

class NewGroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Groups'),
        backgroundColor: Color(0xFF651FFF),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search by ID',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            // Add more widgets for the new group screen as needed
          ],
        ),
      ),
    );
  }
}