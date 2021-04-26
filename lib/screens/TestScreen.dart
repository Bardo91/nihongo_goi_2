

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nihongogoi2/widgets/exercises/Exercise4Options.dart';
import 'package:nihongogoi2/widgets/exercises/ExerciseYouWrite.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../persistency/Nihongogoi2Database.dart';
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
  List<int> _available;
  ConfettiController _controllerCenter = ConfettiController(duration: const Duration(seconds: 2));
  List<bool> _scores;
  int _currentQuestionId = 0;
  bool _hasAnswered = false;
  int _currentWordId = -1;
  var _currentExercise;

  @override
  void initState() {
    _available = new List<int>.generate(widget.vocabulary_.length, (i) => i + 1);
    _scores = new List<bool>.generate(widget.numQuestions_, (i) => false);
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

    Widget exercise;
    if(_hasAnswered) {
      exercise = Container(
        child: Text(_scores[_currentQuestionId-1]?"Great!":"Oh....."),
      );
    }
    else {
      exercise = _currentExercise;
    }

    var exeriseTile = new ListTile(
      title: exercise
    );

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
        child: ListView(
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
            StepProgressIndicator(
                totalSteps: widget.numQuestions_,
                customStep: (index, color, _) {
                  if(index >= _currentQuestionId){
                    return Container(
                        child:Icon(Icons.help_outline,
                            color: Colors.blue)
                    );
                  }else{
                    if(_scores[index]){
                      return Container(
                          child:Icon(Icons.check_outlined,
                              color: Colors.green)
                      );
                    } else{
                      return Container(
                          child:Icon(Icons.clear_outlined,
                              color: Colors.redAccent)
                      );
                    }
                  }
                }
            ),
            Divider(height: 40,
                indent: 20,
                endIndent: 20),
            exeriseTile,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                FlatButton(
                  color: Color.fromARGB(255, 210, 210, 210),
                  child: Text(_hasAnswered ? "Next": "Check answer"),
                  onPressed: (){
                    if(_hasAnswered){
                      _newRandomWord();
                    }else{
                      _checkAnswer();
                    }
                  },
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }

  bool _checkAnswer(){
    if( _currentExercise.checkAnswer()){
      _scores[_currentQuestionId] = true;
    } else{
      _scores[_currentQuestionId] = false;
    }
    _currentQuestionId++;
    _hasAnswered = true;
    setState(() {

    });

    if(_currentQuestionId == _scores.length){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        endDialog();
      });
    }
  }

  void _newRandomWord(){



    _hasAnswered = false;
     _controllerCenter.stop();
     var nextIndex = Random().nextInt(_available.length);
     _currentWordId = _available[nextIndex];
     _available.removeAt(nextIndex);
    setState(() {
      var typeExercise = Random().nextInt(2); // 0) 4 options
                                              // 1) Write it yourself
      if(typeExercise == 0)
        _currentExercise = Exercise4Options(widget.vocabulary_, _currentWordId);
      else if(typeExercise == 1){
        _currentExercise = ExerciseYouWrite(widget.vocabulary_, _currentWordId);
      }
    });
  }

  void endDialog() {
    double totalScore = 0;
    for(var val in _scores){
      if(val)
        totalScore+=1;
    }
    totalScore/=_scores.length;

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



