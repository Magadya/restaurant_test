// lib/core/errors/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List<dynamic> properties;

  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object?> get props => [properties];
}

class DatabaseFailure extends Failure {
  @override
  String toString() => 'Ошибка базы данных';
}

class CacheFailure extends Failure {
  @override
  String toString() => 'Ошибка кэширования';
}

class ValidationFailure extends Failure {
  final String message;

  const ValidationFailure(this.message);

  @override
  String toString() => message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  @override
  String toString() => 'Ошибка сервера';
}

class NetworkFailure extends Failure {
  @override
  String toString() => 'Ошибка сети';
}