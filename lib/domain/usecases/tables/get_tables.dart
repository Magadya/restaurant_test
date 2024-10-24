import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/table.dart';
import '../../repositories/table_repository.dart';

class GetTables {
  final TableRepository repository;

  GetTables(this.repository);

  Future<Either<Failure, List<RestaurantTable>>> call() async {
    return await repository.getTables();
  }
}