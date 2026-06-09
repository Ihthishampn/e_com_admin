import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_admin/features/users/data/model/user_model.dart';
import 'package:e_com_admin/features/users/domain/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRepository)
class UserRepoImpl implements UserRepository {
  final FirebaseFirestore firestore;
  UserRepoImpl(this.firestore);
  @override
  Future<List<UserModel>> fetchUsers() async {
    try {
      final res = await firestore.collection("users").get();
      return res.docs.map((e) => UserModel.fromMap(e.data(), e.id)).toList();
    } catch (e, st) {
      log("error from users repo $e");
      log('error', error: e, stackTrace: st);
      throw Exception("error from user repo impl $e");
    }
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final q = query.trim();
      if (q.isEmpty) return fetchUsers();

      // Perform prefix searches on `name` and `number` and merge results.
      final nameQuery = await firestore
          .collection('users')
          .orderBy('name')
          .startAt([q]).endAt([q + '\uf8ff']).get();

      final numberQuery = await firestore
          .collection('users')
          .orderBy('number')
          .startAt([q]).endAt([q + '\uf8ff']).get();

      final Map<String, UserModel> results = {};

      for (final d in nameQuery.docs) {
        results[d.id] = UserModel.fromMap(d.data(), d.id);
      }
      for (final d in numberQuery.docs) {
        results[d.id] = UserModel.fromMap(d.data(), d.id);
      }

      return results.values.toList();
    } catch (e, st) {
      log("error from users repo search $e");
      log('error', error: e, stackTrace: st);
      throw Exception("error from user repo impl search $e");
    }
  }
}
