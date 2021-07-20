import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hello/custom_widgets/cool_color.dart';
import 'package:hello/services/tts_service.dart';

class TtsSettings extends StatefulWidget {
  const TtsSettings({Key key}) : super(key: key);

  @override
  _TtsSettingsState createState() => _TtsSettingsState();
}

class _TtsSettingsState extends State<TtsSettings> {
  double speechRate;

  double pitch;
  double volume;

  TtsService _ttsService = TtsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text-to-Speech Settings"),
        centerTitle: true,
        backgroundColor: CoolColor.primaryColor,
      ),
      body: Center(
        child: FutureBuilder<Map<String, double>>(
          future: _ttsService.getSpeechCharacteristics(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              speechRate = snapshot.data["speechRate"];
              pitch = snapshot.data["pitch"];
              volume = snapshot.data["volume"];
              return Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Speech-rate (Speed)",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                                _ttsService.setSpeechRate(speechRate);
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                              _ttsService.setPitch(pitch);
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                              _ttsService.setVolume(volume);
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
              );
            } else
              return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
