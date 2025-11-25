import 'package:flutter/material.dart';

class Timetable extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Órarend")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Skibidi"),
                Text("Sigma")
              ],
            ),
          )
        ],
      )
    );
  }
}