import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/table_repository.dart';

class UpdateTableStatus {
  final TableRepository repository;

  UpdateTableStatus(this.repository);

  Future<Either<Failure, Unit>> call(int id, bool isOccupied) async {
    return await repository.updateTableStatus(id, isOccupied);
  }
}