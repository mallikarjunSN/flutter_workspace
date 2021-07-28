import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TtsService {
  double speechRate = 0.7;
  double pitch = 1.0;
  double volume = 0.85;

  FlutterTts _flutterTts;

  SharedPreferences _sharedPreferences;

  TtsService() {
    _initFlutterTts();
    setPitch(pitch);
    setSpeechRate(speechRate);
    setVolume(volume);
  }

  Future<Map<String, double>> getSpeechCharacteristics() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    speechRate = _sharedPreferences.getDouble("speechRate") ?? speechRate;
    pitch = _sharedPreferences.getDouble("pitch") ?? pitch;
    volume = _sharedPreferences.getDouble("volume") ?? volume;

    var res = {"speechRate": speechRate, "pitch": pitch, "volume": volume};
    return res;
  }

  Future<void> setPitch(double p) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setDouble("pitch", p);
    // print(_sharedPreferences.getDouble("pitch"));
    _flutterTts.setPitch(p);
  }

  Future<void> setSpeechRate(double r) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setDouble("speechRate", r);
    _flutterTts.setSpeechRate(r);
  }

  Future<void> setVolume(double v) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setDouble("volume", v);
    _flutterTts.setVolume(v);
  }

  Future<void> speak(String text) async {
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.speak(text);
  }

  Future<void> _initFlutterTts() async {
    _flutterTts = FlutterTts();

    _sharedPreferences = await SharedPreferences.getInstance();

    speechRate = _sharedPreferences.getDouble("speechRate") ?? 0.7;
    pitch = _sharedPreferences.getDouble("pitch") ?? 1.0;
    volume = _sharedPreferences.getDouble("volume") ?? 0.7;

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
