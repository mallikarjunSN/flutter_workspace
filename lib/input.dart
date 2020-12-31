import 'package:flutter/material.dart';

class InputBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InputBarState();
  }
}

class InputBarState extends State<InputBar> {
  List<Text> messages = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
        children: <Widget>[
          Column(children: messages),
          Container(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                // First child is enter comment text input
                Expanded(
                  child: TextFormField(
                    autocorrect: false,
                    decoration: new InputDecoration(
                      labelText: "Some Text",
                      labelStyle:
                          TextStyle(fontSize: 20.0, color: Colors.white),
                      fillColor: Colors.blue,
                      border: OutlineInputBorder(
                          // borderRadius:
                          //     BorderRadius.all(Radius.zero(5.0)),
                          borderSide: BorderSide(color: Colors.purpleAccent)),
                    ),
                  ),
                ),
                // Second child is button
                IconButton(
                  icon: Icon(Icons.send),
                  iconSize: 20.0,
                  onPressed: () {
                    setState(() {
                      messages.add(Text(""));
                    });
                  },
                )
              ])),
        ],
      ),
    );
  }
}
