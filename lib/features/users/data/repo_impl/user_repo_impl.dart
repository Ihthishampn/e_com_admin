import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_admin/features/users/data/model/user_model.dart';
import 'package:e_com_admin/features/users/domain/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRepository)
class UserRepoImpl implements UserRepository {
  final FirebaseFirestore firestore;
  UserRepoImpl(this.firestore);

  List<UserModel>? _cachedUsers;

  @override
  Future<List<UserModel>> fetchUsers() async {
    try {
      final res = await firestore.collection("users").get();
      final list =
          res.docs.map((e) => UserModel.fromMap(e.data(), e.id)).toList();
      _cachedUsers = list;
      return list;
    } catch (e, st) {
      log("error from users repo $e");
      log('error', error: e, stackTrace: st);
      throw Exception("error from user repo impl $e");
    }
  }

  @override
  Future<UserModel?> fetchUserById(String id) async {
    try {
      final doc = await firestore.collection('users').doc(id).get();
      if (!doc.exists) return null;
      final user = UserModel.fromMap(doc.data() ?? {}, doc.id);
      // Update cache for consistency
      if (_cachedUsers != null) {
        final idx = _cachedUsers!.indexWhere((u) => u.id == user.id);
        if (idx >= 0) {
          _cachedUsers![idx] = user;
        } else {
          _cachedUsers = [..._cachedUsers!, user];
        }
      }
      return user;
    } catch (e, st) {
      log('error fetching user by id $e');
      log('error', error: e, stackTrace: st);
      throw Exception('error fetching user by id $e');
    }
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final raw = query.trim();
      if (raw.isEmpty) {
        return _cachedUsers ?? await fetchUsers();
      }

      // Attempt server-side prefix queries for phone and name for better accuracy.
      final results = <UserModel>[];

      // Phone prefix query (phones are usually numeric and consistent)
      try {
        final phoneQuery = await firestore
            .collection('users')
            .where('phone', isGreaterThanOrEqualTo: raw)
            .where('phone', isLessThanOrEqualTo: raw + '\uf8ff')
            .get();
        results.addAll(
            phoneQuery.docs.map((d) => UserModel.fromMap(d.data(), d.id)));
      } catch (_) {
        // ignore server-side phone query errors and fallback
      }

      // Name prefix query (best-effort; Firestore string comparisons are case-sensitive)
      try {
        final nameQuery = await firestore
            .collection('users')
            .where('name', isGreaterThanOrEqualTo: raw)
            .where('name', isLessThanOrEqualTo: raw + '\uf8ff')
            .get();
        results.addAll(
            nameQuery.docs.map((d) => UserModel.fromMap(d.data(), d.id)));
      } catch (_) {
        // ignore
      }

      // Remove duplicates by id
      final unique = <String, UserModel>{};
      for (final u in results) {
        unique[u.id] = u;
      }

      // If no server-side matches, fallback to cached/full local search (case-insensitive substring)
      if (unique.isEmpty) {
        final all = _cachedUsers ?? await fetchUsers();
        final q = raw.toLowerCase();
        return all.where((user) {
          final nameMatch = user.name.toLowerCase().contains(q);
          final phoneMatch = user.number.toLowerCase().contains(q);
          return nameMatch || phoneMatch;
        }).toList();
      }

      return unique.values.toList();
    } catch (e, st) {
      log("error from users repo search $e");
      log('error', error: e, stackTrace: st);
      throw Exception("error from user repo impl search $e");
    }
  }
}
