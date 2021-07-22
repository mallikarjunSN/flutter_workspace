import 'package:cloud_firestore/cloud_firestore.dart';

class OtherServices {
  CollectionReference _readingWords =
      FirebaseFirestore.instance.collection("readingWords");
  CollectionReference _typingWords =
      FirebaseFirestore.instance.collection("typingWords");
  CollectionReference _wfd = FirebaseFirestore.instance.collection("wfd");

  CollectionReference _feedbackAndIssues =
      FirebaseFirestore.instance.collection("feedbackAndIssues");
  Future<bool> reportIssue(Map<String, String> box) {
    return _feedbackAndIssues.add(box).then((value) => true);
  }

  Stream<DocumentSnapshot> getWfdAsStream() {
    return _wfd.doc("icmzbaUsl4hNwlKDLemc").snapshots();
  }

  Future<void> uploadReadingWord(Map<String, String> data) async {
    _readingWords.add(data).then((value) => print("done"));
  }

  Future<void> uploadTypingWord(Map<String, String> data) async {
    _typingWords.add(data).then((value) => print("done"));
  }

  Future<QuerySnapshot> getAllReadingWords() async {
    return await _readingWords.limit(100).get();
  }

  Future<QuerySnapshot> getAllTypingWords() async {
    return await _typingWords.limit(100).get();
  }
}
