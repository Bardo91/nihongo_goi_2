
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:nihongogoi2/Nihongogoi2Database.dart';
import 'package:path/path.dart';

import 'TestScreen.dart';


class TestContentSelector extends StatefulWidget {
  Nihongogoi2Database db_;

  TestContentSelector(_db){
    db_ = _db;
  }

  @override
  _TestContentSelectorState createState() => _TestContentSelectorState();
}

class _TestContentSelectorState extends State<TestContentSelector> {
  // multiple choice value
  List<String> tags = [];


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
        child: ListView(
          children: [
            ChipsChoice<String>.multiple(
                value: tags,
                onChanged: (val) => setState(() => tags = val),
                choiceItems: C2Choice.listFrom<String, String>(
                  source: widget.db_.getTables(),
                  value: (i, v) => v,
                  label: (i, v) => v,
                  tooltip: (i, v) => v,
                ),
                wrapped: true
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if(tags.length != 0){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context){
                return new TestScreen(widget.db_.getAllTables(tags), 5);
              }),
            );
          }
        },
        label: Text('Start'),
        icon: Icon(Icons.play_arrow),
        backgroundColor: Colors.green,
      ),
    );
  }
}
