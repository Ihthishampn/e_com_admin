import 'package:e_com_admin/features/users/data/model/user_model.dart';

abstract class UserRepository {
  /// Fetch all users.
  Future<List<UserModel>> fetchUsers();

  /// Search users on server side using [query]. Returns matching users.
  Future<List<UserModel>> searchUsers(String query);
}
