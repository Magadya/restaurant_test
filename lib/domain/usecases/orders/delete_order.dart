import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/order_repository.dart';

class DeleteOrder {
  final OrderRepository repository;

  DeleteOrder(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteOrder(id);
  }
}