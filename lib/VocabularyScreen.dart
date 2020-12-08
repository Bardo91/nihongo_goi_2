

import 'package:flutter/material.dart';
import 'package:nihongogoi2/Nihongogoi2Database.dart';

class VocabularyScreen extends StatefulWidget {
  List<VocabularyEntry> vocabulary_;

  VocabularyScreen(_vocabulary){
    vocabulary_ = _vocabulary;
  }

  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Vocabulary Screen"),
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
                ),
        ),
        child: ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: widget.vocabulary_.length*2,
            itemBuilder: /*1*/ (context, i) {
              if (i.isOdd) return Divider(thickness: 2); /*2*/
              final index = i ~/ 2;
              return _buildRow(widget.vocabulary_[index]);
            })
        )
    );
  }

  Widget _buildRow(VocabularyEntry entry) {
    return ListTile(
        title: Row(
          children: [
            Expanded(child:Text(entry.spanish)),
            Expanded(child:Text(entry.japanese)),
            entry.kanji != "" ? Expanded(child:Text(entry.kanji)):Container()
          ],
        )
    );
  }

}
