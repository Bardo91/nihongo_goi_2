import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nihongogoi2/Nihongogoi2DatabaseLessons.dart';

class EntrySelector extends StatefulWidget {
  List<LessonEntry> _entries = List<LessonEntry>();

  EntrySelector(entries){
    _entries = entries;
  }

  @override
  _EntrySelectorState createState() => _EntrySelectorState();
}

class _EntrySelectorState extends State<EntrySelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Selecciona el tema"),
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
                itemCount: widget._entries.length * 2,
                itemBuilder: /*1*/ (context, i) {
                  if (i.isOdd) return Divider(thickness: 2);
                  /*2*/
                  final index = i ~/ 2;
                  return ListTile(
                    title: Text(widget._entries[index].title),
                    onTap: () =>
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                              Scaffold(
                              appBar: AppBar(
                              title: Text(widget._entries[index].title),
                              ),
                              body:  Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/background.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child:SingleChildScrollView(
                                    child: Html(
                                        data: widget._entries[index].html
                                    ),
                                  )
                              )
                              )
                            )),
                  );
                })
        )
    );
  }
}
