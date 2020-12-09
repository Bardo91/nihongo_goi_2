

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'Nihongogoi2Database.dart';
import 'package:confetti/confetti.dart';

class TestScreen extends StatefulWidget {
  int numQuestions_;
  List<VocabularyEntry> vocabulary_;

  TestScreen(_vocabulary, _numQuestions){
    numQuestions_ = _numQuestions;
    vocabulary_ = _vocabulary;
  }

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<bool> scores_;
  int currentScore_ = 0;

  String currentWord = "Click next";
  String currentAnswer = "";
  String currentGuess = "";
  int statusAnswer = -1;

  List<String> options;
  static var _random = new Random();
  String selectedOption ;

  ConfettiController _controllerCenter = ConfettiController(duration: const Duration(seconds: 2));

  @override
  void initState() {
    scores_ = List<bool>(widget.numQuestions_);
    _newRandomWord();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerCenter.dispose();
  }

  BuildContext parentContext_;
  @override
  Widget build(BuildContext context) {
    parentContext_ = context;
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
            Wrap(
                children: List.generate(scores_.length, (i) =>
                    Container(
                      child: Icon(
                          i >= currentScore_? Icons.help_outline: (scores_[i]? Icons.check: Icons.clear_outlined),
                          color: ((i == currentScore_) && (statusAnswer == 0)) ? Colors.yellow:(i >= currentScore_? Colors.blue: (scores_[i]? Colors.green: Colors.red))
                      ),
                    )
                )
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
                  child: Text(statusAnswer==-1? "Start": statusAnswer == 0 ? "Check answer": "Next"),
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
      good();
      // print("well done!");
    } else{
      statusAnswer = 2;
      // print("not yet answer is: "+currentAnswer + " you gave " + currentGuess);
      currentWord = currentAnswer;
      bad();
    }
    setState(() {});

    if(currentScore_ == scores_.length){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        endDialog();
      });
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

  void _newRandomWord(){
   _controllerCenter.stop();
   if(statusAnswer!=0){
     statusAnswer = 0;
     if(widget.vocabulary_!= null && widget.vocabulary_.length!=0){
       int index = _random.nextInt(widget.vocabulary_.length);
       VocabularyEntry entry = widget.vocabulary_[index];
       currentWord = entry.japanese;
       currentGuess = "";
       currentAnswer = entry.spanish;

       options = [currentAnswer];
       for(int i = 0; i < 3;){
         int ri = _random.nextInt(widget.vocabulary_.length);
         if(!options.contains(widget.vocabulary_[ri].spanish)){
           VocabularyEntry re = widget.vocabulary_[ri];
           options.add(re.spanish);
           i++;
         }
       }
     }
     selectedOption = "";

     _shuffle(options);

     setState(() { });
   }
  }


  void good(){
    if(currentScore_ < scores_.length) {
      scores_[currentScore_] = true;
      currentScore_++;
      setState(() {});
    }
  }

  void bad(){
    if(currentScore_ < scores_.length){
      scores_[currentScore_] = false;
      currentScore_++;
      setState(() {});
    }
  }


  void endDialog() {
    double totalScore = 0;
    for(var val in scores_){
      if(val)
        totalScore+=1;
    }
    totalScore/=scores_.length;

    showDialog<void>(
        context: parentContext_,
        useRootNavigator: true,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Text(totalScore <0.5? "Oh....":(totalScore<1.0?"Great!":"Perfect!")),
            content: Row(),
            actions: <Widget>[
              FlatButton(
                child: Text("Finish"),
                onPressed: () {
                  Navigator.of(parentContext_, rootNavigator: true).pop();
                  Navigator.of(parentContext_, rootNavigator: true).pop();
                },
              )
            ],

          );
        });
  }
}



