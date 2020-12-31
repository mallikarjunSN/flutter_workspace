import 'package:flutter/material.dart';

class TicTac extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TicTacState();
  }
}

class TicTacState extends State<TicTac> {
  List<Widget> blocks = new List<Widget>();

  // ClipRRect til = new

  BorderRadius ticBorder(int i) {
    if (i == 0 ? true : false) {
      return BorderRadius.only(topLeft: Radius.circular(10));
    } else if (i == 2 ? true : false) {
      return BorderRadius.only(topRight: Radius.circular(10));
    } else if (i == 6 ? true : false) {
      return BorderRadius.only(bottomLeft: Radius.circular(10));
    } else if (i == 8 ? true : false) {
      return BorderRadius.only(bottomRight: Radius.circular(10));
    }

    return BorderRadius.all(Radius.circular(0));
  }

  Widget createBlock() {
    for (int i = 0; i < 9; i++) {
      blocks.add(ClipRRect(
        borderRadius: ticBorder(i),
        child: Container(
          height: 100,
          width: 100,
          color: Color.fromARGB(255, 51, 51, 255),
          child: Text(
            (i * 2).toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ));
    }
    return Row(
      children: blocks,
    );
  }

  Orientation or;

  Widget getContent(Orientation o) {
    if (o == Orientation.portrait) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30, bottom: 30),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "TIC-TAC-TOE 🎲",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Center(
              child: ClipRRect(
            // borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan[600], width: 20),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 350,
                width: 350,
                // color: Color.fromARGB(255, 204, 51, 153),
                child: GridView.count(
                  crossAxisCount: 3,
                  // padding: EdgeInsets.all(10),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: List.generate(9, (index) {
                    return ClipRRect(
                      // borderRadius: ticBorder(index),
                      child: Container(
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            "O",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 80),
                          ),
                        ),
                      ),
                    );
                  }),
                )
                // elevation: 10,
                ),
          )),
        ],
      );
    }

    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30, bottom: 30),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "TIC-TAC-TOE 🎲",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Center(
            child: ClipRRect(
          // borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyan[600], width: 20),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              height: 350,
              width: 350,
              // color: Color.fromARGB(255, 204, 51, 153),
              child: GridView.count(
                crossAxisCount: 3,
                // padding: EdgeInsets.all(10),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: List.generate(9, (index) {
                  return ClipRRect(
                    // borderRadius: ticBorder(index),
                    child: Container(
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          "O",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 80),
                        ),
                      ),
                    ),
                  );
                }),
              )
              // elevation: 10,
              ),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    or = MediaQuery.of(context).orientation;

    print(or);

    return Scaffold(
        // appBar: AppBar(
        //   title: Align(alignment: Alignment.center,child: Text(""),),
        // ),
        body: SafeArea(
      child: getContent(or),
    ));
  }
}
