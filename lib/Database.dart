
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class KanjiEntry {
  final String kanji;
  final String hiragana;
  final String spanish;

  KanjiEntry({this.kanji, this.hiragana, this.spanish});
}

class VocabularyEntry {
  final String hiragana;
  final String spanish;

  VocabularyEntry({this.hiragana, this.spanish});
}


class Nihongogoi2Database{
  Future<Database> databaseKanji_;
  Future<Database> databaseVocabulary_;

  Nihongogoi2Database(){
    WidgetsFlutterBinding.ensureInitialized();
      // Open the database and store the reference.

    databaseKanji_ = openDatabase('my_db.db');
  }

  Future<List<KanjiEntry>> getAllKanjis() async {
    // Get a reference to the database.
    final Database db = await databaseKanji_;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return KanjiEntry(
        kanji: maps[i]['kanji'],
        hiragana: maps[i]['hiragana'],
        spanish: maps[i]['spanish'],
      );
    });
  }

  Future<List<VocabularyEntry>> getAllVocabulary() async {
    // Get a reference to the database.
    final Database db = await databaseKanji_;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return VocabularyEntry(
        hiragana: maps[i]['hiragana'],
        spanish: maps[i]['spanish'],
      );
    });
  }

}