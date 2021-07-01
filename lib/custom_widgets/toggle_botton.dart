import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  ToggleButton({key, @required this.status, @required this.onPressed})
      : super(key: key);

  final bool status;

  final VoidCallback onPressed;

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        height: 36,
        width: 60,
        alignment:
            (widget.status ? Alignment.centerRight : Alignment.centerLeft),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.circular(18)),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: (widget.status ? Colors.green : Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: (widget.status
                    ? Alignment.centerLeft
                    : Alignment.centerRight),
                child: Padding(
                  padding: EdgeInsets.only(left: 4, right: 4),
                  child: Text(
                    (widget.status ? "ON" : "OFF"),
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              AnimatedAlign(
                duration: Duration(milliseconds: 250),
                curve: Curves.ease,
                alignment: (!widget.status
                    ? Alignment.centerLeft
                    : Alignment.centerRight),
                child: Container(
                  height: 32,
                  width: 32,
                  margin: EdgeInsets.only(top: 1, bottom: 1),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.white,
                          // border: Border.all(color: Colors.grey),
                          boxShadow: [
                        BoxShadow(
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.5),
                            offset:
                                (widget.status ? Offset(-3, 3) : Offset(3, 3))),
                      ]),
                  child: Icon(
                    Icons.power_settings_new,
                    size: 20,
                    color: (widget.status ? Colors.red : Colors.grey),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      onTap: widget.onPressed,
    );
  }
}
