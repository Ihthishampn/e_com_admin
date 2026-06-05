import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FirebaseService {
  @lazySingleton
  FirebaseFirestore get firestore {
    return FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: 'ihthisham',
    );
  }
}
