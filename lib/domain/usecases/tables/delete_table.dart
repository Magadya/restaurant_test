import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/table_repository.dart';

class DeleteTable {
  final TableRepository repository;

  DeleteTable(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteTable(id);
  }
}