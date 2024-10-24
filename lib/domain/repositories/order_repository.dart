import 'package:dartz/dartz.dart';
import '../entities/order.dart';
import '../../core/errors/failures.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderModel>>> getOrders();
  Future<Either<Failure, Unit>> addOrder(OrderModel order);
  Future<Either<Failure, Unit>> updateOrder(OrderModel order);
  Future<Either<Failure, Unit>> deleteOrder(int id);
}