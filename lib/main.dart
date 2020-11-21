
import 'package:flutter/material.dart';
import 'package:nihongogoi2/KanjiScreen.dart';
import 'package:nihongogoi2/TestScreen.dart';
import 'package:nihongogoi2/VocabularyScreen.dart';
import 'package:nihongogoi2/Nihongogoi2Database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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

class HomePage extends StatelessWidget {
  Nihongogoi2Database database = Nihongogoi2Database();

  BuildContext _context;
  @override
  Widget build(BuildContext context) {
    database.open();
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("日本語　ごい　２"),
      ),
      body: ListView(
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
    );
  }

  void _openTestScreen(){
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => TestScreen(database.getAllKanjis(), database.getAllVocabulary())),
    );
  }

  void _openKanjiScreen(){
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => KanjiScreen(database.getAllKanjis())),
    );

  }

  void _openVocabularyScreen(){
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => VocabularyScreen(database.getAllVocabulary())),
    );
  }

  void _openWeekdayscreen(){
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => KanjiScreen(database.getWeekDays())),
    );
  }

  void _openMonthcreen(){
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => VocabularyScreen(database.getMonth())),
    );
  }

}
