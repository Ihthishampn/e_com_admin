import 'package:e_com_admin/features/users/data/model/user_model.dart';
import 'package:e_com_admin/features/users/data/user_case/users_use_case.dart';
import 'package:e_com_admin/general/utils/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserProvider with ChangeNotifier {
  final UsersUseCase useCase;
  UserProvider(this.useCase);
  AppState state = AppState.initial;
  String? error;

  Future<List<UserModel>> fetchUserModel() async {
    return await useCase.fetchUser();
  }

  Future<List<UserModel>> searchUserModel(String query) async {
    return await useCase.searchUser(query);
  }
}
