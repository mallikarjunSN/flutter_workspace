import 'package:flutter/material.dart';
import 'package:hello/custom_dialog.dart';
import 'package:hello/progress.dart';

class TicTac extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TicTacState();
  }
}

class TicTacState extends State<TicTac> {

  String message;
  // ClipRRect til = new

  
  List<String> words;

  @override
  Widget build(BuildContext context) {
    words = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.center,
            child: Text("message"),
          ),
        ),
        body: Center(
          child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: words.length,
              itemBuilder: (context, index) {
                return Container(
                  color:
                      (UserProgress.attempts.containsKey(words.elementAt(index))
                          ? Colors.green[(index + 2) % 10 * 100]
                          : Colors.blue[(index + 2) % 10 * 100]),
                  height: 100,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(words.elementAt(index)),
                      FloatingActionButton(
                        child: Icon(Icons.mic),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomDialog(),
                                  settings:
                                      RouteSettings(arguments: words[index])));
                        },
                        heroTag: null,
                      ),
                    ],
                  ),
                );
              }),
        ));
  }
}
