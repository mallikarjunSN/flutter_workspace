import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  double rate = 0.7;
  double pitch = 1.0;
  double volume = 0.7;

  FlutterTts _flutterTts;

  TtsService() {
    _initFlutterTts();
    setPitch(pitch);
    setSpeechRate(rate);
    setVolume(volume);
  }

  void setPitch(double p) {
    _flutterTts.setPitch(p);
  }

  void setSpeechRate(double r) {
    _flutterTts.setSpeechRate(r);
  }

  void setVolume(double v) {
    _flutterTts.setVolume(v);
  }

  Future<void> speak(String text) async {
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.speak(text);
  }

  void _initFlutterTts() {
    _flutterTts = FlutterTts();

    _flutterTts.setStartHandler(() {
      // print("speaking");
    });

    _flutterTts.setCompletionHandler(() {
      // print("Completed");
    });

    _flutterTts.setCancelHandler(() {
      // print("cancelled");
    });

    _flutterTts.setPauseHandler(() {
      // print("Paused");
    });

    _flutterTts.setContinueHandler(() {
      print("continued");
    });
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
