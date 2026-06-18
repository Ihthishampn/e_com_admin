import 'package:e_com_admin/features/users/data/model/user_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> fetchUsers();

  Future<List<UserModel>> searchUsers(String query);

  Future<UserModel?> fetchUserById(String id);
}
