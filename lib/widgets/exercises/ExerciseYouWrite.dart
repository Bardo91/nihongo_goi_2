

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nihongogoi2/persistency/Nihongogoi2Database.dart';


class ExerciseYouWrite extends StatefulWidget {
  List<VocabularyEntry> _vocabulary;
  int _idAnswer;
  bool _isRight = false;

  ExerciseYouWrite(vocabulary, idAnswer){
    _vocabulary = vocabulary;
    _idAnswer = idAnswer;
  }

  bool checkAnswer(){
    return _isRight;
  }

  @override
  _ExerciseYouWriteState createState() => _ExerciseYouWriteState();
}

class _ExerciseYouWriteState extends State<ExerciseYouWrite> {

  String _guess = "";
  String _answer = "";

  @override
  void initState() {
    // Get word
    var random = new Random();
    var answer = widget._vocabulary[widget._idAnswer];

    // Select mode of exercise
    int sourceType = 0;

    int destType = random.nextInt(answer.kanji == ""? 1:2)+1;

    _guess = getStringFromWord(answer, sourceType);
    _answer = getStringFromWord(answer, destType);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: [
          Container(
            child: Text(_guess,
              textScaleFactor: 2,),
          ),
          Divider(height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type your answer'
            ),
            onChanged: (value) => widget._isRight = _answer == value,
          )
        ],
      ),
    );
  }

  String getStringFromWord(VocabularyEntry word, int type){
    switch(type){
      case 0:
        return word.spanish;
        break;
      case 1:
        return word.japanese;
        break;
      case 2:
        if(word.kanji == "")
          return word.japanese;
        else
          return word.kanji;
        break;
      default:
        return "error";
        break;
    }
  }

}



