import 'package:calkuta/util/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatelessWidget {
  final String defaultUsername = 'admin';
  final String defaultPassword = 'default';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: MyColor.mytheme),
        ),
        backgroundColor: Colors.white,
        shadowColor: MyColor.mytheme,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Username'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: MyColor.mytheme),
              onPressed: () {
                // Implement login logic here
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
