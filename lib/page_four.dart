import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:font';

class PageFour extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageFourState();
  }
}

class PageFourState extends State<PageFour> {
  Future showMyDialog(BuildContext context, String s, int code) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          switch (code) {
            case 0:
              return AlertDialog(
                title: Text("Really..!!!"),
                content: Text("Like mr " + s),
                actions: [
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Close"))
                ],
              );
              break;
          }
          return AlertDialog(
            title: Text("Really..!!!"),
            content: Text("Like mr " + s),
            actions: [Text("ok..!!")],
          );
        });
  }

  List<String> list = ["One", "Two", "Three", "Four", "Five", "Six", "seven"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Align(
            child: Wrap(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Fourth Page"),
                ),
                Align(
                    alignment: Alignment.centerRight, child: Icon(Icons.search))
              ],
            ),
          ),
        ),
        body: Builder(builder: (context) {
          return Container(
              color: Color.fromARGB(100, 0, 0, 255),
              child: ListView(
                padding: EdgeInsets.only(left: 5, right: 5),
                children: [
                  createLists(context),
                  Center(
                    child: RaisedButton(
                      onPressed: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Cool"),
                          duration: Duration(milliseconds: 1000),
                        ));
                      },
                      child: Text("Click me"),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter some text';
                      }
                      return null;
                    },
                  )
                ],
              ));
        }));
  }

  Widget createLists(BuildContext context) {
    List<Widget> wList = new List<Widget>();
    for (var l in list) {
      wList.add(
        Card(
            shadowColor: Colors.grey,
            child: Wrap(
              children: [
                Container(
                  // color: Colors.amberAccent,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Container(
                                // color: Colors.grey,
                                child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              // child: Icon(Icons.supervised_user_circle),
                              child: Image.asset(
                                "assets/user.png",
                              ),
                            )),
                          ),
                          Flexible(
                              flex: 6,
                              child: Container(
                                  height: 100,
                                  alignment: Alignment.topCenter,
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  color: Colors.blue[400],
                                  child: Center(
                                    child: Text(
                                      l,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )))
                        ],
                      )
                    ],
                  ),
                ),
                ButtonBar(
                  // border
                  // buttonPadding: ,
                  alignment: MainAxisAlignment.center,
                  buttonMinWidth: MediaQuery.of(context).size.width / 3.5,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        showMyDialog(context, l, 0);
                      },
                      child: Icon(
                        FontAwesomeIcons.solidHeart,
                        color: Colors.red,
                        size: 35,
                      ),
                    ),
                    RaisedButton(
                      onPressed: () => {},
                      child: Icon(
                        FontAwesomeIcons.comment,
                        color: Colors.blue,
                        size: 35,
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Really Cool man..!!")));
                      },
                      child: Icon(
                        FontAwesomeIcons.share,
                        size: 30.0,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ],
            )),
      );
    }

    return Wrap(
      spacing: 10.00,
      runSpacing: 5.0,
      runAlignment: WrapAlignment.center,
      children: wList,
    );
  }
}
