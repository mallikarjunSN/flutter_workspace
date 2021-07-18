class Progress {
  String word;
  double lastAccuracy;
  DateTime lastAttemptOn;
  Progress({this.word, this.lastAccuracy, this.lastAttemptOn});

  Progress.fromMap(Map<String, dynamic> data) {
    this.word = data["word"];
    this.lastAccuracy = data["lastAccuracy"];
    this.lastAttemptOn = DateTime.tryParse(data['lastAttemptOn']);
  }
}
