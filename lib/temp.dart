import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello/page_four.dart';
import 'package:hello/tic_tac.dart';

class Temp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TempState();
  }
}

class TempState extends State<Temp> {
  final pController = PageController(initialPage: 1);
  // final sliv = Sliver
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PageView(
          controller: pController,
          children: [
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  floating: true,
                  title: Align(
                    child: Text(
                      "SliverAppBar Here",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30.0),
                    ),
                  ),
                  expandedHeight: 200.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: FittedBox(
                        fit: BoxFit.fill,
                        child: Image.asset("assets/god_ganesha.jpg")),
                  ),
                  actions: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.backspace))
                  ],
                ),
                SliverList(delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  if (index > 10) return null;
                  return Container(
                    height: 100,
                    width: double.infinity,
                    child: Center(child: Text(index.toString())),
                    color: Colors.cyan[((index + 1) * 100) % 1000 + 100],
                  );
                }))
              ],
            ),
            Center(child: PageFour()),
            Center(child: TicTac()),
            Center(child: Text("page 4")),
            Center(child: Text("page 5")),
          ],
        ),
      ),
    );
  }
}

// class CustomContainer extends Container {
//   String text = "hello"; // = "hello";
//   CustomContainer(Widget child, String text) : super(child: child) {
//     this.text = text;
//   }
// }
