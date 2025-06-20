import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final String message;

  const Failure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

/// Failure related to local database (e.g., Hive) operations.
class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure({required super.message});
}

/// Failure related to remote database operations.
class RemoteDatabaseFailure extends Failure {
  const RemoteDatabaseFailure({required super.message});
}

/// Failure related to HTTP/API errors (e.g., REST, GraphQL).
class ApiFailure extends Failure {
  final int statusCode;
  const ApiFailure({required this.statusCode, required super.message});
}
