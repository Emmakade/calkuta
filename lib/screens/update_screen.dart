import 'package:calkuta/util/my_color.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Password',
          style: TextStyle(color: MyColor.mytheme),
        ),
        backgroundColor: Colors.white,
        shadowColor: MyColor.mytheme,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: MyColor.mytheme),
              onPressed: () {
                // Implement password update logic here
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
