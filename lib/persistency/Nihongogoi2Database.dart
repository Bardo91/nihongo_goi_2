
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'dart:io';
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

    //final dbPath  = await getDatabasesPath();
    //final path = join(dbPath, DATABASE_NAME);
    //
    //ByteData data = await rootBundle.load(join("assets", DATABASE_NAME));
    //
    //List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    //await File(path).writeAsBytes(bytes, flush: true);
    //
    //database = await openDatabase(path);

    Directory applicationDirectory = await getApplicationDocumentsDirectory();

    String dbPathEnglish =  join(applicationDirectory.path, "nihongo_goi_vocabulary.db");
    String url = "https://github.com/Bardo91/nihongo_goi_n5/raw/master/assets/nihongo_goi_vocabulary.db";

    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();

    // thow an error if there was error getting the file
    // so it prevents from wrting the wrong content into the db file
    if (response.statusCode != 200) throw "Error getting db file";

    var bytes = await consolidateHttpClientResponseBytes(response);

    File file = new File(dbPathEnglish);
    await file.writeAsBytes(bytes);

    database = await openDatabase(dbPathEnglish);

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