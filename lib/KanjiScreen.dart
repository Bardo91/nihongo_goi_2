

import 'package:flutter/material.dart';

class KanjiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kanji Screen"),
      ),
      body: ListView(
        children: [
          Text("田　- た　- campo de arroz"),
          Text("鳥　- とり　- pajaro"),
        ],
      ),
    );
  }
}