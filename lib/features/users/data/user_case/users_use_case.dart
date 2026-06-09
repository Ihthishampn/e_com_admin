import 'package:e_com_admin/features/users/data/model/user_model.dart';
import 'package:e_com_admin/features/users/domain/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UsersUseCase {
  final UserRepository repo;
  UsersUseCase(this.repo);

  Future<List<UserModel>> fetchUser() async {
    return await repo.fetchUsers();
  }

  Future<List<UserModel>> searchUser(String query) async {
    return await repo.searchUsers(query);
  }
}
