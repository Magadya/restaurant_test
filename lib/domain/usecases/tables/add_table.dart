import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/table_repository.dart';

class AddTable {
  final TableRepository repository;

  AddTable(this.repository);

  Future<Either<Failure, Unit>> call(String number) async {
    return await repository.addTable(number);
  }
}