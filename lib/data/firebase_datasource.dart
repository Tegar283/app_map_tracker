import 'package:cloud_firestore/cloud_firestore.dart';

import 'location_model.dart';

class FirebaseDataSource {
  final FirebaseFirestore firestore;

  FirebaseDataSource(this.firestore);

  Future<void> syncLocation(LocationModel location) async {
    await firestore
        .collection('users')
        .doc(location.userId)
        .collection('locations')
        .add(location.toJson());
  }
}
