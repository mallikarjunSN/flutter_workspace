import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/custom_widgets/cool_color.dart';
import 'package:hello/dyslexia/word_list.dart';
import 'package:hello/services/db_service.dart';

class ExercisesHome extends StatefulWidget {
  const ExercisesHome({key}) : super(key: key);

  @override
  _ExercisesHomeState createState() => _ExercisesHomeState();
}

class MyClipper extends CustomClipper<Path> {
  MyClipper({this.ratio, this.off});

  final ratio;

  final off;
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * ratio);

    path.quadraticBezierTo(size.width / 2, (size.height * ratio + 50) + off,
        size.width, size.height * ratio);

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class _ExercisesHomeState extends State<ExercisesHome>
    with SingleTickerProviderStateMixin {
  final title = "Exercises\nHome";

  AnimationController _animationController;

  Animation<double> _topBarAnimation;
  Animation<int> _titleAnimation;

  Animation<double> _block1Anim;
  Animation<double> _block2Anim;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));

    _topBarAnimation = Tween(begin: 0.0, end: 50.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.25, curve: Curves.bounceOut)));

    _titleAnimation = IntTween(begin: 0, end: title.length).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.1, 0.4, curve: Curves.linear)));

    _block1Anim = Tween(begin: 500.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.4, 0.75, curve: Curves.elasticOut)));

    _block2Anim = Tween(begin: 500.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.75, 1.0, curve: Curves.elasticOut)));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double height;
  double width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          height: height,
          width: width,
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: MyClipper(
                    ratio: _topBarAnimation.value / 100,
                    off: _topBarAnimation.value,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: height * 0.25,
                    padding: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: CoolColor().getColor(0x00b294),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        title.substring(0, _titleAnimation.value),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                  blurRadius: 3,
                                  offset: Offset(-3, 3),
                                  color: Colors.black.withOpacity(0.25)),
                            ],
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: height * .2,
                right: 0,
                left: 0,
                child: Block(
                  type: "reading",
                  blockAnimation: _block1Anim,
                ),
              ),
              Positioned(
                bottom: height * 0.37,
                right: 0,
                left: 0,
                child: Divider(
                  color: Colors.black,
                  thickness: 1.0,
                ),
              ),
              Positioned(
                bottom: height * 0.04,
                left: 0,
                right: 0,
                child: Block(
                  type: "typing",
                  blockAnimation: _block2Anim,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class Block extends StatefulWidget {
  Block({key, @required this.type, @required this.blockAnimation})
      : super(key: key);

  final String type;

  final Animation blockAnimation;

  @override
  _BlockState createState() => _BlockState();
}

class _BlockState extends State<Block> {
  @override
  void initState() {
    super.initState();
  }

  String capitalize(String str) {
    return str[0].toUpperCase() + str.substring(1);
  }

  double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Transform.translate(
      offset: Offset(0, widget.blockAnimation.value),
      child: Container(
        width: width * 0.95,
        height: height * 0.3,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          // border: Border.all(
          //   style: BorderStyle.solid,
          // ),
          gradient: LinearGradient(colors: [
            CoolColor().getColor(0x5fc3e4).withOpacity(0.5),
            CoolColor().getColor(0xeff487).withOpacity(.5),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(15),
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                capitalize(widget.type),
                style: TextStyle(
                    fontSize: 35,
                    color: CoolColor.primaryColor,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                          blurRadius: 3,
                          offset: Offset(-3, 3),
                          color: Colors.black.withOpacity(0.15))
                    ]),
              ),
              SizedBox(
                width: 15,
              ),
              SizedBox(
                height: width * 0.175,
                width: width * 0.175,
                child: Image.asset(
                  widget.type == "reading"
                      ? "assets/reading.png"
                      : "assets/typing.png",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LevelIcon(
                level: "easy",
                type: widget.type,
              ),
              LevelIcon(
                level: "medium",
                type: widget.type,
              ),
              LevelIcon(
                level: "hard",
                type: widget.type,
              ),
            ],
          )
        ]),
      ),
    );
  }
}

class LevelIcon extends StatefulWidget {
  const LevelIcon({
    key,
    @required this.level,
    @required this.type,
    // @required this.totalWords,
    // @required this.completedWords,
  }) : super(key: key);

  final String type;
  final String level;

  // final int totalWords;
  // final int completedWords;

  @override
  _LevelIconState createState() => _LevelIconState();
}

class _LevelIconState extends State<LevelIcon> {
  void navigate(context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => WordList(),
        // transitionDuration: Duration(milliseconds: 1000),
        settings: RouteSettings(
            arguments: {"level": widget.level, "type": widget.type}),
      ),
    );
  }

  final Map<String, String> levelImages = {
    "reading_easy": "assets/icons/easy.png",
    "reading_medium": "assets/icons/medium.png",
    "reading_hard": "assets/icons/hard.png",
    "typing_easy": "assets/icons/1star.png",
    "typing_medium": "assets/icons/2star.png",
    "typing_hard": "assets/icons/3star.png",
  };

  String table;

  double width, height;

  final _colors = CoolColor().getRandomColors(2);

  String capitalize(String str) {
    return str[0].toUpperCase() + str.substring(1);
  }

  Future<List<int>> getExerxiseStatus() {}

  @override
  Widget build(BuildContext context) {
    table = (widget.type.toLowerCase() == "reading"
        ? "readingWords"
        : "readingWords");
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        navigate(context);
      },
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: width * 0.3, maxWidth: width * 0.27),
        child: Container(
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 3,
                offset: Offset(-3, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                flex: 60,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    gradient: RadialGradient(
                      colors: _colors,
                      center: Alignment.center,
                      radius: 0.7,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: Hero(
                          tag: "${widget.type}_${widget.level}",
                          child: Image.asset(
                            levelImages["${widget.type}_${widget.level}"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: Container(
                            color: Colors.black.withOpacity(0),
                            child: Icon(
                              FontAwesomeIcons.lock,
                              size: width * 0.12,
                              color: Colors.white.withOpacity(0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 10,
                ),
              ),
              Expanded(
                flex: 20,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 4),
                  child: Text(
                    capitalize(widget.level),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                flex: 15,
                child: StreamBuilder(
                  stream:
                      DatabaseService().getCountAsStream(table, widget.level),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      List<Map<String, dynamic>> data = snapshot.data;
                      int completed = data[0]["C"];
                      int total = data[1]["C"];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "$completed / $total",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          SizedBox(
                            width: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                semanticsValue: "Progress indicator",
                                value: completed.toDouble() / total,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue[900]),
                                minHeight: 8,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text("Loading...");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
