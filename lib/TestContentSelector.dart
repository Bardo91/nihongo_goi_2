
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:nihongogoi2/Nihongogoi2Database.dart';
import 'package:path/path.dart';

import 'TestScreen.dart';


class TestContentSelector extends StatefulWidget {
  Future<List<String>> fOptions_;
  BuildContext context_;
  Nihongogoi2Database db_;

  TestContentSelector(Future<List<String>> _options, BuildContext _context, Nihongogoi2Database _db){
    fOptions_ = _options;
    context_ = _context;
    db_ = _db;
  }

  @override
  _TestContentSelectorState createState() => _TestContentSelectorState(fOptions_);
}

class _TestContentSelectorState extends State<TestContentSelector> {
  // multiple choice value
  List<String> tags = [];
  List<String> options_ = [];
  Future<List<String>> fOptions_;

  _TestContentSelectorState(_fOptions){
    fOptions_ = _fOptions;
    fOptions_.then((value) {
      if (value != null) value.forEach((item) => options_.add(item));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Content Selector"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
            ),
          ),
        padding: const EdgeInsets.all(32),
        child:ChipsChoice<String>.multiple(
          value: tags,
          onChanged: (val) => setState(() => tags = val),
          choiceItems: C2Choice.listFrom<String, String>(
            source: options_,
            value: (i, v) => v,
            label: (i, v) => v,
            tooltip: (i, v) => v,
          ),
          wrapped: true
        )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            widget.context_,
            MaterialPageRoute(builder: (context){
              return new TestScreen(widget.db_.getAllTables(tags), 20);
            }),
          );
        },
        label: Text('Start'),
        icon: Icon(Icons.play_arrow),
        backgroundColor: Colors.green,
      ),
    );
  }
}
