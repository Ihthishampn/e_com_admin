// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:e_com_admin/features/categories/data/repo_impl/category_repo_impl.dart'
    as _i658;
import 'package:e_com_admin/features/categories/data/use_case/categories_use_case.dart'
    as _i25;
import 'package:e_com_admin/features/categories/domain/repo/categories_repo.dart'
    as _i722;
import 'package:e_com_admin/features/categories/presentation/provider/category_provider.dart'
    as _i329;
import 'package:e_com_admin/features/products/data/repo_impl/repo_impl.dart'
    as _i494;
import 'package:e_com_admin/features/products/data/use_case/product_use_case.dart'
    as _i673;
import 'package:e_com_admin/features/products/domain/products_repo.dart'
    as _i128;
import 'package:e_com_admin/features/products/presentation/provider/add_product_provider.dart'
    as _i261;
import 'package:e_com_admin/features/products/presentation/provider/product_provider.dart'
    as _i426;
import 'package:e_com_admin/features/users/data/repo_impl/user_repo_impl.dart'
    as _i73;
import 'package:e_com_admin/features/users/data/user_case/users_use_case.dart'
    as _i743;
import 'package:e_com_admin/features/users/domain/repository/user_repository.dart'
    as _i480;
import 'package:e_com_admin/features/users/presentation/provider/user_provider.dart'
    as _i135;
import 'package:e_com_admin/general/firebase/firebase_service.dart' as _i53;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseService = _$FirebaseService();
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseService.firestore);
    gh.lazySingleton<_i722.CategoriesRepo>(
        () => _i658.CategoryRepoImpl(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i25.CategoriesUseCase>(
        () => _i25.CategoriesUseCase(gh<_i722.CategoriesRepo>()));
    gh.factory<_i329.CategoryProvider>(
        () => _i329.CategoryProvider(gh<_i25.CategoriesUseCase>()));
    gh.lazySingleton<_i480.UserRepository>(
        () => _i73.UserRepoImpl(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i128.ProductsRepo>(
        () => _i494.ProductRepoImpl(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i743.UsersUseCase>(
        () => _i743.UsersUseCase(gh<_i480.UserRepository>()));
    gh.lazySingleton<_i673.ProductsUseCase>(
        () => _i673.ProductsUseCase(gh<_i128.ProductsRepo>()));
    gh.factory<_i135.UserProvider>(
        () => _i135.UserProvider(gh<_i743.UsersUseCase>()));
    gh.factory<_i426.ProductProvider>(
        () => _i426.ProductProvider(gh<_i673.ProductsUseCase>()));
    gh.factory<_i261.AddProductProvider>(
        () => _i261.AddProductProvider(gh<_i426.ProductProvider>()));
    return this;
  }
}

class _$FirebaseService extends _i53.FirebaseService {}
