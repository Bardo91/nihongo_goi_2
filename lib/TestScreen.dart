

import 'package:flutter/material.dart';

import 'Nihongogoi2Database.dart';

class TestScreen extends StatefulWidget {
  TestScreen(_kanjis, _vocabulary){
    kanjisFuture = _kanjis;
    vocabularyFuture = _vocabulary;
  }

  @override
  _TestScreenState createState() => _TestScreenState(kanjisFuture, vocabularyFuture);

  Future<List<KanjiEntry>> kanjisFuture;
  Future<List<VocabularyEntry>> vocabularyFuture;
}

class _TestScreenState extends State<TestScreen> {
  _TestScreenState(_kanjis, _vocabulary){
    kanjisFuture = _kanjis;
    vocabularyFuture = _vocabulary;

    kanjisFuture.then((value) {
      if (value != null) value.forEach((item) => kanjis.add(item));
      setState(() {});
    });

    vocabularyFuture.then((value) {
      if (value != null) value.forEach((item) => vocabulary.add(item));
      setState(() {});
    });
  }

  String currentWord = "Loading Word";
  String currentAnswer = "iam";
  String currentGuess = "";
  int statusAnswer = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Screen"),
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(currentWord, textScaleFactor: 2),
                  Spacer(),
                  Icon(
                      statusAnswer==0?Icons.border_color:statusAnswer==1?Icons.check:Icons.clear,
                      color: statusAnswer==0?Colors.blue:statusAnswer==1?Colors.green:Colors.red),
                ],
              )
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Guess the word",
              ),
              onChanged: (text) => currentGuess=text,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  color: Color.fromARGB(255, 210, 210, 210),
                  child: Text("Check answer"),
                  onPressed: _checkAnswer,
                ),
                Spacer(),
                FlatButton(
                  color: Color.fromARGB(255, 210, 210, 210),
                  child: Text("Next"),
                  onPressed: _newRandomWord,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _checkAnswer(){
    if(currentAnswer == currentGuess){
      print("well done!");
    }else{
      print("not yet answer is: "+currentAnswer + " you gave " + currentGuess);
    }
  }

  void _newRandomWord(){

    setState(() {});
  }

  Future<List<KanjiEntry>> kanjisFuture;
  List<KanjiEntry> kanjis;
  Future<List<VocabularyEntry>> vocabularyFuture;
  List<VocabularyEntry> vocabulary;

}



