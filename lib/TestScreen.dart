

import 'dart:math';

import 'package:flutter/material.dart';

import 'Nihongogoi2Database.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  TestScreen(_vocabulary){
    vocabularyFuture = _vocabulary;
  }

  @override
  _TestScreenState createState() => _TestScreenState(vocabularyFuture);

  Future<List<VocabularyEntry>> vocabularyFuture;
}

class _TestScreenState extends State<TestScreen> {
  ConfettiController _controllerCenter = ConfettiController(duration: const Duration(seconds: 2));
  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  _TestScreenState(_vocabulary){
    vocabularyFuture = _vocabulary;
    vocabularyFuture.then((value) {
      if (value != null) value.forEach((item) => vocabulary.add(item));
      setState(() {});
    });
  }

  String currentWord = "Click next";
  String currentAnswer = "";
  String currentGuess = "";
  int statusAnswer = 1;
  List<String> options;
  static var _random = new Random();
  String selectedOption ;

  final TextEditingController tec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Screen"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
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
            /*TextFormField(
              decoration: InputDecoration(
                hintText: "Guess the word",
              ),
              onChanged: (text) => currentGuess=text,
              controller: tec,
            ),*/
            Column(
              children: [
                RadioListTile(
                  title: Text(options != null? options[0]: "-----"),
                  value: options != null? options[0]: "-----",
                  groupValue: selectedOption,
                  onChanged: (value) { setState(() {currentGuess = value; selectedOption = value; }); },
                ),
                RadioListTile(
                  title: Text(options != null? options[1]: "-----"),
                  value: options != null? options[1]: "-----",
                  groupValue: selectedOption,
                  onChanged: (value) { setState(() {currentGuess = value; selectedOption = value; }); },
                ),
                RadioListTile(
                  title: Text(options != null? options[2]: "-----"),
                  value: options != null? options[2]: "-----",
                  groupValue: selectedOption,
                  onChanged: (value) { setState(() {currentGuess = value; selectedOption = value; }); },
                ),
                RadioListTile(
                  title: Text(options != null? options[3]: "-----"),
                  value: options != null? options[3]: "-----",
                  groupValue: selectedOption,
                  onChanged: (value) { setState(() {currentGuess = value; selectedOption = value; }); },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                FlatButton(
                  color: Color.fromARGB(255, 210, 210, 210),
                  child: Text(statusAnswer == 0 ? "Check answer": "Next"),
                  onPressed: (){
                    if(statusAnswer == 0){
                      _checkAnswer();
                    }else{
                      _newRandomWord();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _checkAnswer(){
    if( currentAnswer.toLowerCase() == currentGuess.toLowerCase()){
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

  void _newRandomWord(){
   _controllerCenter.stop();
   if(statusAnswer!=0){
     statusAnswer = 0;
     if(_random.nextInt(2)==0){ // kanji
       if(kanjis != null && kanjis.length!=0){
         int index = _random.nextInt(kanjis.length);
         VocabularyEntry entry = kanjis[index];
         currentWord = entry.kanji;
         currentGuess = "";
         currentAnswer = entry.spanish;

         options = [currentAnswer];
         for(int i = 0; i < 3;i++){
           int ri = _random.nextInt(kanjis.length);
           if(ri != index){
             VocabularyEntry re = kanjis[ri];
             options.add(re.spanish);
           }else{
             i--;
           }
         }
       }
     }else{ // vocabulary
       if(vocabulary!= null && vocabulary.length!=0){
         int index = _random.nextInt(vocabulary.length);
         VocabularyEntry entry = vocabulary[index];
         currentWord = entry.japanese;
         currentGuess = "";
         currentAnswer = entry.spanish;

         options = [currentAnswer];
         for(int i = 0; i < 3;i++){
           int ri = _random.nextInt(vocabulary.length);
           if(ri != index){
             VocabularyEntry re = vocabulary[ri];
             options.add(re.spanish);
           }else{
             i--;
           }
         }
       }
     }

     _shuffle(options);


     tec.clear();

     setState(() { });
   }
  }

  Future<List<VocabularyEntry>> kanjisFuture;
  List<VocabularyEntry> kanjis=[];
  Future<List<VocabularyEntry>> vocabularyFuture;
  List<VocabularyEntry> vocabulary=[];

}



