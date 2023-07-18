import 'package:flutter/material.dart';
import 'new_group_screen.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Color(0xFF651FFF),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewGroupScreen()),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF651FFF),
                child: Icon(
                  Icons.group,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.0),
              Text(
                'New Groups',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

