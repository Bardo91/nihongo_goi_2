

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path_provider/path_provider.dart';

class LessonEntry {
  final String title;
  final String html;

  LessonEntry({this.title, this.html});
}

class Nihongogoi2DatabaseLessons{

  final int DATABASE_VERSION = 1;
  final String DATABASE_NAME = "nihongo_goi_lessons.db";

  Database database;
  bool _isOpen = false;
  List<String> _lessons;
  Map<String, List<LessonEntry>> _lessonsEntries = new Map<String, List<LessonEntry>>();

  bool get isOpen{
    return _isOpen;
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

    _lessons = (await database
        .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: true);

    _lessons.remove('android_metadata');

    for(var tableName in _lessons){
      // Query the table for all The Dogs.
      final  List<Map<String, dynamic>> maps = await database.query(tableName);

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      var table = List.generate(maps.length, (i) {
        return LessonEntry(
          title: maps[i]['title'],
          html: maps[i]['content'],
        );
      });

      _lessonsEntries[tableName] = table;
    }

    _isOpen = true;

    return _isOpen;
  }

  List<String> get lessons {
    return _lessons;
  }

  List<LessonEntry> getLesson(String lesson){
    return _lessonsEntries[lesson];
  }

  Map<String, List<LessonEntry>> get getEntries {
    return _lessonsEntries;
  }
}