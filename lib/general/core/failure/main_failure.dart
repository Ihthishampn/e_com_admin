/// Simple replacement for a freezed union type used across the project.
///
/// This implementation provides `const` named constructors so existing call
/// sites that use `const MainFailure.serverFailure(errorMsg: ...)` continue to
/// work without requiring `freezed` code generation.
class MainFailure {
  final String errorMsg;
  final MainFailureType type;

  const MainFailure._(this.type, this.errorMsg);

  const MainFailure.serverFailure({required String errorMsg})
    : this._(MainFailureType.serverFailure, errorMsg);

  const MainFailure.alreadyExists({required String errorMsg})
    : this._(MainFailureType.alreadyExists, errorMsg);

  const MainFailure.dataNotFound({required String errorMsg})
    : this._(MainFailureType.dataNotFound, errorMsg);

  const MainFailure.locationFailure({required String errorMsg})
    : this._(MainFailureType.locationFailure, errorMsg);

  const MainFailure.permissionDenied({required String errorMsg})
    : this._(MainFailureType.permissionDenied, errorMsg);

  const MainFailure.pickFailed({required String errorMsg})
    : this._(MainFailureType.pickFailed, errorMsg);

  const MainFailure.authenticationFailure({required String errorMsg})
    : this._(MainFailureType.authenticationFailure, errorMsg);

  @override
  String toString() => 'MainFailure(type: $type, errorMsg: $errorMsg)';
}

enum MainFailureType {
  serverFailure,
  alreadyExists,
  dataNotFound,
  locationFailure,
  permissionDenied,
  pickFailed,
  authenticationFailure,
}
