import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.id,
    required this.instituteCode,
    required this.password,
  });

  final String id;
  final String password;
  final String instituteCode;

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Bejelentkezés",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: "Azonosító",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: "Iskola",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    autocorrect: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Jelszó",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: const Icon(Icons.discord),
      ),
    );
  }
}