
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:nihongogoi2/KanjiPainterScreen.dart';
import 'package:nihongogoi2/TestContentSelector.dart';
import 'package:nihongogoi2/Nihongogoi2Database.dart';
import 'package:flame/flame.dart';
import 'package:nihongogoi2/VocabularyTopicSelector.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids
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
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TestContentSelector(database)))
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                title: Text( "Vocabulario"),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VocabularyTopicSelector(database)))
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                title: Text( "Kanji Painter"),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => KanjiPainterScreen(database.getTable("kanji"))))
              ),
              Divider(
                thickness: 2,
              ),
              GifImage(
                controller: controller,
                image: AssetImage("assets/gifs/cat_"+(random.nextInt(9)+1).toString()+".gif"),
              )
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

  
  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }

  String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    return null;
  }

  String getRewardBasedVideoAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    }
    return null;
  }



}
