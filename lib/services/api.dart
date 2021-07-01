import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Api {
  String collectionName;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _cr;
  Api({@required this.collectionName}) {
    _cr = _db.collection(this.collectionName);
  }

  Stream<QuerySnapshot> getDocStream() {
    return _cr.snapshots();
  }

  CollectionReference getCollectionReference() {
    return _cr;
  }

  Future<DocumentSnapshot> getDocById(String id) {
    return _cr.doc(id).get();
  }
}
