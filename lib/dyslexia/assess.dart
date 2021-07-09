import 'package:flutter/material.dart';
import 'package:hello/custom_widgets/cool_color.dart';

class Assess extends StatefulWidget {
  Assess({key}) : super(key: key);

  @override
  _AssessState createState() => _AssessState();
}

class Word extends StatefulWidget {
  ///class that represents the Practice Word
  ///
  const Word({Key key, this.word}) : super(key: key);

  final word;

  @override
  _WordState createState() => _WordState();
}

class _WordState extends State<Word> with SingleTickerProviderStateMixin {
  AnimationController _ac;
  Animation<double> _textAnim;

  @override
  void initState() {
    super.initState();

    _ac = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 2000),
        reverseDuration: Duration(milliseconds: 2000));

    _textAnim = Tween(begin: 0.0, end: 1.0).animate(_ac);

    // _ac.forward();
    _ac.reverse();
    _ac.repeat();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  List<String> texts = ["Be", "Positive"];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.15,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: texts
            .map(
              (val) => Text(
                val,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(1)),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _AssessState extends State<Assess> {
  final words = ["Hello", "World", "is", "Always", "Cool"];

  int currentIndex = 0;

  Widget getCurrentWord() {
    return Word(
      word: words[currentIndex],
    );
  }

  bool next = true;

  // var _currentWord = Word(
  //   word: "dkfjd",
  // );

  int index = 0;

  double endValue = 50;

  Future<void> perform() async {
    setState(() {
      index = (index + 1) % words.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // AnimatedSwitcher(
            //   duration: Duration(milliseconds: 250),
            //   child: _currentWord,
            //   reverseDuration: Duration(milliseconds: 500),
            //   transitionBuilder: (child, animation) {
            //     return SlideTransition(
            //       position: Tween<Offset>(
            //               begin: Offset((next ? 1 : -1), 0), end: Offset(0, 0))
            //           .animate(animation),
            //       child: child,
            //     );
            //   },
            // ),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: words
                  .map(
                    (val) => TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 1000),
                      tween: Tween(begin: 1, end: 1.5),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: (index == words.indexOf(val) ? value : 1.0),
                          child: Text(
                            val,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: (index == words.indexOf(val)
                                    ? Colors.amber
                                    : Colors.black)),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
            Center(
                child: AnimeButton(
              backgroundColor: CoolColor().getColor(0x1abc9c),
              onPressed: perform,
              child: Icon(
                Icons.settings,
                size: 50,
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class AnimeButton extends StatefulWidget {
  AnimeButton(
      {key,
      @required this.onPressed,
      @required this.child,
      this.height = 60,
      this.width = 100,
      this.backgroundColor = Colors.blue})
      : super(key: key);

  final double height;
  final double width;

  final Widget child;

  final VoidCallback onPressed;

  final Color backgroundColor;

  @override
  _AnimeButtonState createState() => _AnimeButtonState();
}

class _AnimeButtonState extends State<AnimeButton> {
  bool buttonDown = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.transparent),
      child: GestureDetector(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: widget.height - 10,
                width: widget.width + 2,
                decoration: BoxDecoration(
                  color: (widget.backgroundColor),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            AnimatedAlign(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 75),
              alignment:
                  (buttonDown ? Alignment.bottomCenter : Alignment.topCenter),
              child: Container(
                height: widget.height - 8,
                width: widget.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7,
                        offset: Offset(0, 5),
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    )),
                child: Center(child: widget.child),
              ),
            ),
          ],
        ),
        onTapDown: (details) {
          setState(() {
            buttonDown = true;
          });
        },
        onTap: widget.onPressed,
        onTapUp: (details) {
          setState(() {
            buttonDown = false;
          });
        },
      ),
    );
  }
}
