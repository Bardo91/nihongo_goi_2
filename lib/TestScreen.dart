

import 'dart:math';

import 'package:flutter/material.dart';

import 'Nihongogoi2Database.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  TestScreen(_kanjis, _vocabulary){
    kanjisFuture = _kanjis;
    vocabularyFuture = _vocabulary;
  }

  @override
  _TestScreenState createState() => _TestScreenState(kanjisFuture, vocabularyFuture);

  Future<List<VocabularyEntry>> kanjisFuture;
  Future<List<VocabularyEntry>> vocabularyFuture;
}

class _TestScreenState extends State<TestScreen> {
  ConfettiController _controllerCenter = ConfettiController(duration: const Duration(seconds: 2));
  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

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

  String currentWord = "Click next";
  String currentAnswer = "iam";
  String currentGuess = "";
  int statusAnswer = 0;
  static var _random = new Random();

  final TextEditingController tec = TextEditingController();

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
            //CENTER -- Blast
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _controllerCenter,
                blastDirectionality: BlastDirectionality
                    .explosive, // don't specify a direction, blast randomly
                shouldLoop:
                true, // start again as soon as the animation is finished
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ], // manually specify the colors to be used
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(currentWord, textScaleFactor: 1.5),
                  Spacer(),
                  Icon(
                      statusAnswer==0?Icons.border_color:statusAnswer==1?Icons.check:Icons.clear,
                      color: statusAnswer==0?Colors.blue:statusAnswer==1?Colors.green:Colors.red,
                      size: 50,),
                ],
              )
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Guess the word",
              ),
              onChanged: (text) => currentGuess=text,
              controller: tec,
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
    if(currentAnswer.toLowerCase() == currentGuess.toLowerCase()){
      statusAnswer = 1;
      _controllerCenter.play();
      print("well done!");
    } else{
      statusAnswer = 2;
      print("not yet answer is: "+currentAnswer + " you gave " + currentGuess);
      currentWord = currentAnswer;
    }
    setState(() {});
  }

  void _newRandomWord(){
   _controllerCenter.stop();
    statusAnswer = 0;
    if(_random.nextInt(2)==0){ // kanji
      if(kanjis != null && kanjis.length!=0){
        int index = _random.nextInt(kanjis.length);
        VocabularyEntry entry = kanjis[index];
        currentWord = entry.kanji;
        currentGuess = "";
        currentAnswer = entry.spanish;
      }
    }else{ // vocabulary
      if(vocabulary!= null && vocabulary.length!=0){
        int index = _random.nextInt(vocabulary.length);
        VocabularyEntry entry = vocabulary[index];
        currentWord = entry.hiragana;
        currentGuess = "";
        currentAnswer = entry.spanish;
      }

    }
    setState(() {
      tec.clear();
    });
  }

  Future<List<VocabularyEntry>> kanjisFuture;
  List<VocabularyEntry> kanjis=[];
  Future<List<VocabularyEntry>> vocabularyFuture;
  List<VocabularyEntry> vocabulary=[];

}



