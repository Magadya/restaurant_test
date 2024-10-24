import 'package:dartz/dartz.dart';
import '../entities/table.dart';
import '../../core/errors/failures.dart';

abstract class TableRepository {
  Future<Either<Failure, List<RestaurantTable>>> getTables();
  Future<Either<Failure, Unit>> addTable(String number);
  Future<Either<Failure, Unit>> deleteTable(int id);
  Future<Either<Failure, Unit>> updateTableStatus(int id, bool isOccupied);
}