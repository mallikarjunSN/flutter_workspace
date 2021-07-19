import 'package:flutter/material.dart';

class PrgSpin extends StatefulWidget {
  const PrgSpin({@required this.progress, key}) : super(key: key);

  final double progress;

  @override
  _PrgSpinState createState() => _PrgSpinState();
}

class _PrgSpinState extends State<PrgSpin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45), color: Colors.white),
          ),
          Container(
            height: 90,
            width: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.amber,
            ),
            child: TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 3000),
              tween: Tween(begin: 0, end: widget.progress),
              curve: Curves.bounceOut,
              builder: (context, value, child) {
                return Text(
                  "${(value * 100.0).toStringAsFixed(1)} %",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                );
              },
            ),
          ),
          Container(
            height: 110,
            width: 110,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(55)),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: widget.progress),
              duration: Duration(milliseconds: 3000),
              curve: Curves.bounceOut,
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 10,
                  valueColor:
                      AlwaysStoppedAnimation(Colors.red.withOpacity(0.5)),
                );
              },
            ),
          )
        ],
      ),

      // "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/1fafbbc6-41b8-4b54-97b6-9edcf6725560/d7t4mdm-a38e3582-7d57-417a-841f-28fd430ef47f.png/v1/fill/w_800,h_800,strp/bright_full_moon_png_by_clairesolo_d7t4mdm-fullview.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9ODAwIiwicGF0aCI6IlwvZlwvMWZhZmJiYzYtNDFiOC00YjU0LTk3YjYtOWVkY2Y2NzI1NTYwXC9kN3Q0bWRtLWEzOGUzNTgyLTdkNTctNDE3YS04NDFmLTI4ZmQ0MzBlZjQ3Zi5wbmciLCJ3aWR0aCI6Ijw9ODAwIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.fb7BjB3-5pSJPN1_V-A2ICDgKJyW1CQ8r3kCQVGTaWE"),
    );
  }
}
