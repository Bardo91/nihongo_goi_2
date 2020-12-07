
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nihongogoi2/KanjiScreen.dart';
import 'package:nihongogoi2/TestContentSelector.dart';
import 'package:nihongogoi2/TestScreen.dart';
import 'package:nihongogoi2/VocabularyScreen.dart';
import 'package:nihongogoi2/Nihongogoi2Database.dart';
import 'package:flame/flame.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: '日本語　２',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }

}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Nihongogoi2Database database = Nihongogoi2Database();
  bool playMusic = false;

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    database.open();
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(  "日本語　ごい　２",
          textAlign: TextAlign.center,),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child:  ListView(
            children: [
              ListTile(
                title: Text( "テスト - Test"),
                onTap: _openTestScreen,
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                title: Text( "かんじ - Kanji"),
                onTap: _openKanjiScreen,
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                title: Text( "Vocabulary"),
                onTap: _openVocabularyScreen,
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                title: Text( "ようび - Weekdays"),
                onTap: _openWeekdayscreen,
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                title: Text( "日　- Month days"),
                onTap: _openMonthcreen,
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                title: Text( "Contadores - WIP"),
                enabled: false,
              ),
              Divider(
                thickness: 2,
              ),
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          playMusic = !playMusic;

          if(playMusic){
            Flame.bgm.play('ost.mp3', volume: 0.25);
          }else{
            Flame.bgm.stop();
          }

          setState(() { });
        },
        child: Icon(playMusic? Icons.pause : Icons.play_arrow),
        backgroundColor: Colors.pink,
      ),

    );
  }

  void _openTestScreen(){
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => TestContentSelector(database.getTables(), _context, database)),
    );
  }

  void _openKanjiScreen(){
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => KanjiScreen(database.getTable('kanji'))),
    );

  }

  void _openVocabularyScreen(){
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => VocabularyScreen(database.getAll())),
    );
  }

  void _openWeekdayscreen(){
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => KanjiScreen(database.getTable('weekdays'))),
    );
  }

  void _openMonthcreen(){
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => VocabularyScreen(database.getTable('month_days'))),
    );
  }

}
