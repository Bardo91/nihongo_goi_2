

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

class nihongogoin5Database{

  final int DATABASE_VERSION = 1;
  final String DATABASE_NAME = "nihongo_goi_vocabulary.db";

  Database database;
  bool isOpen_ = false;
  List<String> tableNames_;
  Map<String, List<VocabularyEntry>> vocabularyTables_ = new Map<String, List<VocabularyEntry>>();

  bool isOpen(){
    return isOpen_;
  }

  Future<bool> open() async{
    WidgetsFlutterBinding.ensureInitialized();

    final dbPath  = await getDatabasesPath();
    final path = join(dbPath, DATABASE_NAME);

    ByteData data = await rootBundle.load(join("assets", DATABASE_NAME));

    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);

    database = await openDatabase(path);

    if(!database.isOpen){
      return false;
    }

    tableNames_ = (await database
        .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: true);

    tableNames_.remove('android_metadata');

    for(var tableName in tableNames_){
      // Query the table for all The Dogs.
      final  List<Map<String, dynamic>> maps = await database.query(tableName);

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      var table = List.generate(maps.length, (i) {
        return VocabularyEntry(
          kanji: maps[i].containsKey('kanji')? maps[i]['kanji']:"",
          japanese: maps[i]['japanese'],
          spanish: maps[i]['spanish'],
        );
      });

      vocabularyTables_[tableName] = table;
    }

    isOpen_ = true;

    return true;
  }

  List<String> getTables(){
    return tableNames_;
  }

  List<VocabularyEntry> getTable(String _tableName){
    return vocabularyTables_[_tableName];
  }

  List<VocabularyEntry> getAll(){
    var tables = getTables();
    List<VocabularyEntry> fullVocab = new List<VocabularyEntry>();
    for(var tableName in tables){
      var table = getTable(tableName);
      fullVocab.addAll(table);
    }
    return fullVocab;
  }


  List<VocabularyEntry> getAllTables(List<String> _tables){
    List<VocabularyEntry> fullVocab = new List<VocabularyEntry>();
    for(var tableName in _tables){
      var table = getTable(tableName);
      fullVocab.addAll(table);
    }
    return fullVocab;
  }
}