

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path_provider/path_provider.dart';

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

  final int DATABASE_VERSION = 1;
  final String DATABASE_NAME = "nihongo_goi_2.db";

  Database database;

  void open() async{
    WidgetsFlutterBinding.ensureInitialized();

    final dbPath  = await getDatabasesPath();
    final path = join(dbPath, DATABASE_NAME);

    /*final exist = await databaseExists(path);

    if(!exist){
      try{
        await Directory(dirname(path)).create(recursive: true);
      }catch(_){}*/
      ByteData data = await rootBundle.load(join("assets", DATABASE_NAME));

      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    //}

    database = await openDatabase(path);
  }

  Future<List<KanjiEntry>> getAllKanjis() async{
    // Get a reference to the database.

    // Query the table for all The Dogs.
    final  List<Map<String, dynamic>> maps = await database.query('kanji');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return KanjiEntry(
        kanji: maps[i]['kanji'],
        hiragana: maps[i]['hiragana'],
        spanish: maps[i]['spanish'],
      );
    });
  }

  Future<List<VocabularyEntry>> getAllVocabulary() async{
    // Get a reference to the database.

    // Query the table for all The Dogs.
    final  List<Map<String, dynamic>> maps = await database.query('vocabulary');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return VocabularyEntry(
        hiragana: maps[i]['hiragana'],
        spanish: maps[i]['spanish'],
      );
    });
  }

}