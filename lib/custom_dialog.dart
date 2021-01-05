import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  String word = "";

  // stt.SpeechToText

  stt.SpeechToText _speech;

  bool _isListening = false;

  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(_text);
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Open dialog"),
          onPressed: () {
            showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(
                        "Custom dialog",
                        textAlign: TextAlign.center,
                      ),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            // height: 200,
                            decoration: Decoration.lerp(null, null, 1.5),
                            child: AvatarGlow(
                              animate: true,
                              glowColor: Colors.blue,
                              endRadius: 75,
                              duration: const Duration(milliseconds: 500),
                              repeat: true,
                              child: FloatingActionButton(
                                  elevation: 20,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    FontAwesomeIcons.microphone,
                                    color: Colors.blue,
                                    size: 25,
                                  ),
                                  onPressed: _listen),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            _text,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      actions: [
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceBetween,
                          buttonMinWidth:
                              MediaQuery.of(context).size.width * 0.33,
                          children: [
                            RaisedButton(
                              child: Text("Retry"),
                              onPressed: () {},
                            ),
                            RaisedButton(
                              child: Text("Submit"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            // RaisedButton(
                            //   child: Text("Submit"),
                            //   onPressed: () {},
                            // ),
                          ],
                        )
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
