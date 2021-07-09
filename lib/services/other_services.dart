import 'package:cloud_firestore/cloud_firestore.dart';

class OtherServices {
  CollectionReference _readingWords =
      FirebaseFirestore.instance.collection("readingWords");

  CollectionReference _feedbackAndIssues =
      FirebaseFirestore.instance.collection("feedbackAndIssues");
  Future<bool> reportIssue(Map<String, String> box) {
    return _feedbackAndIssues.add(box).then((value) => true);
  }

  Future<void> uploadReadingWord(Map<String, String> data) async {
    _readingWords.add(data).then((value) => print("done"));
  }

  Future<QuerySnapshot> getAllReadingWords() {
    return _readingWords.limit(10).get();
  }
}
