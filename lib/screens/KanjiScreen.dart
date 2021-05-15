

import 'package:flutter/material.dart';
import 'package:nihongogoin5/persistency/Nihongogoi2Database.dart';

class KanjiScreen extends StatefulWidget {
  KanjiScreen(_kanji){
    kanjisFuture = _kanji;
  }


  @override
  _KanjiScreenState createState() => _KanjiScreenState(kanjisFuture);

  Future<List<VocabularyEntry>> kanjisFuture;
}

class _KanjiScreenState extends State<KanjiScreen> {
  _KanjiScreenState(_kanji){
    kanjis = [];
    kanjisFuture = _kanji;
    kanjisFuture.then((value) {
      if (value != null) value.forEach((item) => kanjis.add(item));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Kanji Screen"),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: kanjis.length*2,
              itemBuilder: /*1*/ (context, i) {
                if (i.isOdd) return Divider(thickness: 2); /*2*/
                final index = i ~/ 2;
                return _buildRow(kanjis[index]);
              })
        )
    );
  }

  Widget _buildRow(VocabularyEntry entry) {
    return ListTile(
      title: Row(
        children: [
          Expanded(child:Text(entry.kanji)),
          Expanded(child:Text(entry.japanese)),
          Expanded(child:Text(entry.spanish)),
        ],
      )
    );
  }

  Future<List<VocabularyEntry>> kanjisFuture;
  List<VocabularyEntry> kanjis;
}
