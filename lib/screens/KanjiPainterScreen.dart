import 'package:painter/painter.dart';



import 'package:flutter/material.dart';
import '../persistency/Nihongogoi2Database.dart';

class KanjiPainterScreen extends StatefulWidget {
  List<VocabularyEntry> vocabulary_;

  KanjiPainterScreen(_vocabulary){
    vocabulary_ = _vocabulary;
  }

  @override
  _KanjiPainterScreenState createState() => _KanjiPainterScreenState();
}

class _KanjiPainterScreenState extends State<KanjiPainterScreen> {
  PainterController _controller;
  Painter kanjiCanvas;

  @override
  void initState() {
    super.initState();
    _controller = _newController();
    kanjiCanvas = new Painter(_controller);
    widget.vocabulary_.shuffle();
  }

  PainterController _newController() {
    _controller = new PainterController();
    _controller.thickness = 10.0;
    _controller.backgroundColor = Colors.transparent;
    return _controller;
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
            child:
              Stack(
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    child: Row(
                      children: [
                        Text(widget.vocabulary_[0].spanish,textScaleFactor: 2),
                        Text("<==>",textScaleFactor: 2),
                        Text(widget.vocabulary_[0].japanese,textScaleFactor: 2),
                      ],
                    ),
                  ),
                  Center(
                    child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text( widget.vocabulary_[0].kanji,
                          textScaleFactor: 20,
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'KanjiStrokeOrders_v4'
                          ),
                        ),
                    ),
                  ),
                  kanjiCanvas
                ],
              ),
        ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 80.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'save',
              onPressed: () {
                _controller.clear();
                setState(() {});
              },
              child: Text("Clean"),
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: FloatingActionButton(
              heroTag: 'close',
              onPressed: () {
                widget.vocabulary_.shuffle();
                _controller.clear();
                setState(() {});
              },
              child: Text("Next"),
            ),
          ),
        ],
      ),
    );
  }


}
