import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/order.dart';
import '../../repositories/order_repository.dart';

class GetOrders {
  final OrderRepository repository;

  GetOrders(this.repository);

  Future<Either<Failure, List<OrderModel>>> call() async {
    return await repository.getOrders();
  }
}