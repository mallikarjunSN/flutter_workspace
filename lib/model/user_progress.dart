class UserProgress {
  static int currentStage = 1;
  static int currentLevel = 1;
  static int totalWordsAttempted = 0;
  static double accuracy = 0.0;

  static Map<String, Attempt> attempts = {};

  static void update() {
    currentStage = ((attempts.length) ~/ 25) + 1;
    totalWordsAttempted = attempts.length;
    currentLevel = ((attempts.length ~/ 5) % 25) + 1;
    double accu = 0;

    attempts.forEach((key, value) {
      accu += value.accuracy;
    });
    accu /= attempts.length;
    accuracy = accu;
  }
}

class Attempt {
  Attempt(this.original, this.attempted, this.accuracy);

  String original;
  String attempted;
  double accuracy;
}
