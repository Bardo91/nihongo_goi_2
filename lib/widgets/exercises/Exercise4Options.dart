

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nihongogoin5/persistency/Nihongogoi2Database.dart';


class Exercise4Options extends StatefulWidget {
  List<VocabularyEntry> _vocabulary;
  int _idAnswer;
  bool _isRight = false;

  Exercise4Options(vocabulary, idAnswer){
    _vocabulary = vocabulary;
    _idAnswer = idAnswer;
  }

  bool checkAnswer(){
    return _isRight;
  }

  @override
  _Exercise4OptionsState createState() => _Exercise4OptionsState();
}

class _Exercise4OptionsState extends State<Exercise4Options> {

  String _guess = "";
  String _answer = "";
  List<String> _options = [];
  String _selectedOption =  "";
  @override
  void initState() {
    // Get word
    var random = new Random();

    var answer = widget._vocabulary[widget._idAnswer];

    // Get 3 more random words.
    List<VocabularyEntry> options = [
      widget._vocabulary[random.nextInt(widget._vocabulary.length)],
      widget._vocabulary[random.nextInt(widget._vocabulary.length)],
      widget._vocabulary[random.nextInt(widget._vocabulary.length)]
    ];

    // Select mode of exercise
    int sourceType = random.nextInt(answer.kanji == ""? 2:3);

    int destType = random.nextInt(answer.kanji == ""? 2:3);
    while(destType == sourceType){
      destType = random.nextInt(answer.kanji == ""? 2:3);
    }

    _guess = getStringFromWord(answer, sourceType);
    _answer = getStringFromWord(answer, destType);
    _options = [
      getStringFromWord(answer, destType),
      getStringFromWord(options[0], destType),
      getStringFromWord(options[1], destType),
      getStringFromWord(options[2], destType)
    ];

    _shuffle(_options);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  BuildContext parentContext_;

  @override
  Widget build(BuildContext context) {
    parentContext_ = context;
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
          RadioListTile(
            title: Text(_options[0]),
            value: _options[0],
            groupValue: _selectedOption,
            onChanged:(value) => setState(() {_selectedOption = value; widget._isRight = _selectedOption == _answer;}),
          ),
          RadioListTile(
            title: Text(_options[1]),
            value: _options[1],
            groupValue: _selectedOption,
            onChanged:(value) => setState(() {_selectedOption = value; widget._isRight = _selectedOption == _answer;}),
          ),
          RadioListTile(
            title: Text(_options[2]),
            value: _options[2],
            groupValue: _selectedOption,
            onChanged:(value) => setState(() {_selectedOption = value; widget._isRight = _selectedOption == _answer;}),
          ),
          RadioListTile(
            title: Text(_options[3]),
            value: _options[3],
            groupValue: _selectedOption,
            onChanged:(value) => setState(() {_selectedOption = value;  widget._isRight = _selectedOption == _answer;}),
          ),
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

  List _shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {

      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }
}



