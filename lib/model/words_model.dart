class ReadingWord {
  String word;
  String level;
  String syllables;
  String syllablesPron;
  double lastAccuracy;
  DateTime lastAttemptOn;

  ReadingWord({
    this.word,
    this.level,
    this.syllables,
    this.syllablesPron,
    this.lastAccuracy,
    this.lastAttemptOn,
  });

  ReadingWord.fromJsom(Map<String, dynamic> data) {
    this.word = data["word"];
    this.level = data["level"];
    this.syllables = data["syllables"];
    this.syllablesPron = data["syllablesPron"];
    this.lastAccuracy = data["lastAccuracy"];
    this.lastAttemptOn = (data["lastAttemptOn"] != null
        ? DateTime.tryParse(data["lastAttemptOn"])
        : null);
  }

  Map<String, dynamic> toJson() {
    return {
      "word": this.word,
      "syllables": this.syllables,
      "syllablesPron": this.syllablesPron,
      "lastAccuracy": this.lastAccuracy,
      "lastAttemptOn": this.lastAttemptOn,
    };
  }
}

class TypingWord {
  String word;
  String level;
  double lastAccuracy;
  DateTime lastAttemptOn;

  TypingWord({
    this.word,
    this.level,
    this.lastAccuracy,
    this.lastAttemptOn,
  });

  TypingWord.fromJsom(Map<String, dynamic> data) {
    this.word = data["word"];
    this.level = data["level"];
    this.lastAccuracy = data["lastAccuracy"];
    this.lastAttemptOn = (data["lastAttemptOn"] == null
        ? null
        : DateTime.tryParse(data["lastAttemptOn"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "word": this.word,
      "level": this.level,
      "lastAccuracy": this.lastAccuracy,
      "lastAttemptOn": this.lastAttemptOn,
    };
  }
}

class Rwords {
  static List<List<String>> beginner = [
    ["the", "bus", "best", "in", "out"],
    ["be", "but", "was", "what", "with"],
    ["box", "nose", "hand", "pen", "book"],
    ["help", "leg", "bottle", "chair", "queen"],
    ["mango", "apple", "banana", "orange", "grapes "]
  ];
  static List<List<String>> intermediate = [
    ["cat", "cap", "map", "van", "ran"],
    ["gey", "gel", "gorilla", "gas", "yogurt"],
    ["quickly", "among", "equation", "questions", "machines"],
    ["option", "caption", "production", "elevation", "pollution"],
    ["biking", "giving", "dodging", "grievous", "excitable "]
  ];
  static List<List<String>> advanced = [
    ["unfortunately", "fetch", "clutch", "rich", "blotch"],
    ["lawn mower", "resurgence", "ploughman", "elucidate", "fervently"],
    [
      "a dog is a man's best friend",
      "a bird in the hand is worth two in the bush",
      "a chain is only as strong as its weakest link",
      "a fool and his money are soon parted",
      "a friend in need is a friend in deed"
    ],
    [
      "a countenance more in sorrow than in anger",
      "burn the candle at both ends",
      "too big for your boots too big for your breeches",
      "behind every great man is a great woman",
      "children should be seen and not heard"
    ],
    ["jold", "hile", "sheem", "polonel", "pove "]
  ];
}

class TWords {
  static List<List<String>> beginner = [
    ["aims", "time", "with", "word", "age"],
    ["became", "because", "become", "great", "another"],
    ["farmer", "built", "longest", "could", "person"],
    ["accept", "central", "energy", "meaning", "upheld"],
    ["distress", "fainted", "respect", "whereas", "success"]
  ];

  static List<List<String>> intermediate = [
    ["publish", "project", "account", "transform", "connect"],
    ["adventure", "absolute", "enough", "modern", "embrace"],
    ["annual", "necessary", "million", "original", "armour"],
    ["references", "distinct", "describe", "velocity", "machine"],
    ["alphabetical", "combination", "descended", "description", "conversation"]
  ];

  static List<List<String>> advanced = [
    [
      "controversial",
      "representative",
      "comprehensive",
      "significant",
      "premature"
    ],
    ["hypothesis", "extraordinary", "monastery", "inertia", "dimension"],
    ["committee", "arithmetic", "soldier", "psychology", "derivative"],
    ["ineffectual", "phenomena", "electronically", "contemporary", "monarchy"],
    [
      "sociological",
      "campaign",
      "incomprehensible",
      "circumstance",
      "charismatic"
    ]
  ];
}
