

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path_provider/path_provider.dart';

class VocabularyEntry {
  final String kanji;
  final String japanese;
  final String spanish;

  VocabularyEntry({this.kanji, this.japanese, this.spanish});
}

class Nihongogoi2Database{

  final int DATABASE_VERSION = 1;
  final String DATABASE_NAME = "nihongo_goi_2.db";

  Database database;

  void open() async{
    WidgetsFlutterBinding.ensureInitialized();

    final dbPath  = await getDatabasesPath();
    final path = join(dbPath, DATABASE_NAME);

    ByteData data = await rootBundle.load(join("assets", DATABASE_NAME));

    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);

    database = await openDatabase(path);
  }

  Future<List<String>> getTables() async{
    var tableNames = (await database
        .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: true);

    tableNames.remove('android_metadata');

    return tableNames;
  }

  Future<List<VocabularyEntry>> getTable(String _tableName) async{
    // Get a reference to the database.

    // Query the table for all The Dogs.
    final  List<Map<String, dynamic>> maps = await database.query(_tableName);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return VocabularyEntry(
        kanji: maps[i].containsKey('kanji')? maps[i]['kanji']:"",
        japanese: maps[i]['japanese'],
        spanish: maps[i]['spanish'],
      );
    });
  }

  Future<List<VocabularyEntry>> getAll() async{
    var tables = await getTables();

    List<VocabularyEntry> fullVocab = new List<VocabularyEntry>();

    for(var tableName in tables){
      var table = await getTable(tableName);
      fullVocab.addAll(table);
    }

    return fullVocab;
  }


  Future<List<VocabularyEntry>> getAllTables(List<String> _tables) async{
    List<VocabularyEntry> fullVocab = new List<VocabularyEntry>();
    for(var tableName in _tables){
      var table = await getTable(tableName);
      fullVocab.addAll(table);
    }
    return fullVocab;
  }
}