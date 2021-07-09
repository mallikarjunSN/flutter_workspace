import 'package:flutter/material.dart';

class Progress extends StatefulWidget {
  final Widget child;

  Progress({Key key, this.child}) : super(key: key);

  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
