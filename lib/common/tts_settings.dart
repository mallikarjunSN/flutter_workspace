import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/custom_widgets/cool_color.dart';

class TtsSettings extends StatefulWidget {
  const TtsSettings({Key key}) : super(key: key);

  @override
  _TtsSettingsState createState() => _TtsSettingsState();
}

class _TtsSettingsState extends State<TtsSettings> {
  double speechRate = 0.8;

  double pitch = 1.0;
  double volume = 0.75;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text-to-Speech Settings"),
        centerTitle: true,
        backgroundColor: CoolColor.primaryColor,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Speech-rate (Speed)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "0.0",
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: Slider(
                      activeColor: Colors.cyan,
                      inactiveColor: Colors.cyan.withOpacity(0.2),
                      min: 0.0,
                      max: 1.0,
                      divisions: 30,
                      label: speechRate.toStringAsFixed(2),
                      autofocus: true,
                      focusNode: FocusNode(),
                      value: speechRate,
                      onChanged: (newValue) {
                        setState(() {
                          speechRate = newValue;
                        });
                      },
                    ),
                  ),
                  Text(
                    "1.0",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              Divider(
                color: Colors.black.withOpacity(0.7),
              ),
              Text(
                "Pitch",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "0.5",
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: Slider(
                      activeColor: Colors.cyan,
                      inactiveColor: Colors.cyan.withOpacity(0.2),
                      min: 0.5,
                      max: 2.0,
                      divisions: 30,
                      label: pitch.toStringAsFixed(2),
                      autofocus: true,
                      focusNode: FocusNode(),
                      value: pitch,
                      onChanged: (newValue) {
                        setState(() {
                          pitch = newValue;
                        });
                      },
                    ),
                  ),
                  Text(
                    "2.0",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Divider(
                color: Colors.black.withOpacity(0.7),
              ),
              Text(
                "Volume",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "0.0",
                    style: TextStyle(fontSize: 16),
                  ),
                  Icon(Icons.volume_mute),
                  Expanded(
                    child: Slider(
                      activeColor: Colors.cyan,
                      inactiveColor: Colors.cyan.withOpacity(0.2),
                      min: 0.0,
                      max: 1.0,
                      divisions: 20,
                      label: volume.toStringAsFixed(2),
                      autofocus: true,
                      focusNode: FocusNode(),
                      value: volume,
                      onChanged: (newValue) {
                        setState(() {
                          volume = newValue;
                        });
                      },
                    ),
                  ),
                  Icon(Icons.volume_up),
                  Text(
                    "1.0",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              Divider(
                color: Colors.black.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
