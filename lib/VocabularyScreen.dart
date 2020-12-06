

import 'package:flutter/material.dart';
import 'package:nihongogoi2/Nihongogoi2Database.dart';

class VocabularyScreen extends StatefulWidget {
  VocabularyScreen(_vocabulary){
    vocabularyFuture = _vocabulary;
  }

  @override
  _VocabularyScreenState createState() => _VocabularyScreenState(vocabularyFuture);

  Future<List<VocabularyEntry>> vocabularyFuture;
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  _VocabularyScreenState(_vocabulary){
    vocabulary = [];
    vocabularyFuture = _vocabulary;
    vocabularyFuture.then((value) {
      if (value != null) value.forEach((item) => vocabulary.add(item));
      setState(() {});
    });
  }

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
            itemCount: vocabulary.length*2,
            itemBuilder: /*1*/ (context, i) {
              if (i.isOdd) return Divider(thickness: 2); /*2*/
              final index = i ~/ 2;
              return _buildRow(vocabulary[index]);
            })
        )
    );
  }

  Widget _buildRow(VocabularyEntry entry) {
    return ListTile(
        title: Row(
          children: [
            Expanded(child:Text(entry.japanese)),
            Expanded(child:Text(entry.spanish)),
          ],
        )
    );
  }

  Future<List<VocabularyEntry>> vocabularyFuture;
  List<VocabularyEntry> vocabulary;
}
