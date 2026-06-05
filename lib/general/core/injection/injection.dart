import 'package:e_com_admin/general/core/injection/injection.config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:e_com_admin/features/products/data/repo_impl/repo_impl.dart';
import 'package:e_com_admin/features/products/data/use_case/product_use_case.dart';
import 'package:e_com_admin/features/products/domain/products_repo.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> confirugationDependency() async {
  getIt.init();
  if (!getIt.isRegistered<ProductsRepo>()) {
    getIt.registerLazySingleton<ProductsRepo>(
      () => ProductRepoImpl(getIt<FirebaseFirestore>()),
    );
  }
  if (!getIt.isRegistered<ProductsUseCase>()) {
    getIt.registerLazySingleton<ProductsUseCase>(
      () => ProductsUseCase(getIt<ProductsRepo>()),
    );
  }
}
