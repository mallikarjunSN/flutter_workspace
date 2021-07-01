import 'package:flutter/material.dart';

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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(widget.width / 2.5),
                    topRight: Radius.circular(widget.width / 2.5),
                    bottomRight: Radius.circular(widget.width / 2),
                    bottomLeft: Radius.circular(widget.width / 2),
                  ),
                ),
              ),
            ),
            AnimatedAlign(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 50),
              alignment:
                  (buttonDown ? Alignment.bottomCenter : Alignment.topCenter),
              child: Container(
                height: widget.height - 10,
                width: widget.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7,
                        offset: (buttonDown ? Offset(0, 0) : Offset(0, 5)),
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(widget.width / 2)),
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
