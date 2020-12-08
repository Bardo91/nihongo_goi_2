
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:nihongogoi2/TestContentSelector.dart';
import 'package:nihongogoi2/Nihongogoi2Database.dart';
import 'package:flame/flame.dart';
import 'package:nihongogoi2/VocabularyTopicSelector.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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

class _HomePageState extends State<HomePage>  with TickerProviderStateMixin  {
  Nihongogoi2Database database = Nihongogoi2Database();
  ProgressDialog dbProgressDialog;
  Future<bool> isDbOpen;
  bool playMusic = false;

  GifController controller;

  @override
  void initState() {
    super.initState();

    isDbOpen = database.open();
    dbProgressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    dbProgressDialog.style(message: 'Loading Vocabulary');
    Future.delayed(Duration(seconds: 4)).then((onValue) {
      if (dbProgressDialog.isShowing())
        dbProgressDialog.hide();
    });

    controller = GifController(vsync: this,duration: Duration(milliseconds: 200),reverseDuration: Duration(milliseconds: 200));
    WidgetsBinding.instance.addPostFrameCallback((_){
      controller.repeat(min: 0,max: 2,period: Duration(milliseconds: 500));
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if(!database.isOpen())
        dbProgressDialog.show();
    });

    var random = new Random();

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
                onTap: () => _openTestScreen(context),
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                title: Text( "Vocabulario"),
                onTap: () => _openVocabularySelector(context),
              ),
              Divider(
                thickness: 2,
              ),
              GifImage(
                controller: controller,
                image: AssetImage("assets/gifs/cat_"+(random.nextInt(9)+1).toString()+".gif"),
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

  void  _openTestScreen(_context){
    Navigator.push(
        _context,
        MaterialPageRoute(builder: (context) => TestContentSelector(database),
        ));
  }


  void  _openVocabularySelector(_context){
    Navigator.push(
        _context,
        MaterialPageRoute(builder: (context) => VocabularyTopicSelector(database),
        ));
  }

}
