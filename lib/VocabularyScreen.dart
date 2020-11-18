

import 'package:flutter/material.dart';

class VocabularyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vocabulary Screen"),
      ),
      body: ListView(
        children: [
          Text("た　- campo de arroz"),
          Text("とり　- pajaro"),
        ],
      ),
    );
  }

}