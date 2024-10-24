import 'package:equatable/equatable.dart';
import 'package:restaurant_test/domain/entities/product.dart';

enum OrderStatus { new_, inProgress, completed, cancelled }

class OrderModel extends Equatable {
  final int id;
  final int tableId;
  final List<OrderItem> items;
  final OrderStatus status;
  final DateTime createdAt;
  final double totalAmount;

  const OrderModel({
    required this.id,
    required this.tableId,
    required this.items,
    required this.status,
    required this.createdAt,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [id, tableId, items, status, createdAt, totalAmount];
}
class OrderItem extends Equatable {
  final Product product;
  final int quantity;

  const OrderItem({
    required this.product,
    required this.quantity,
  });

  double get subtotal => product.price * quantity;

  @override
  List<Object?> get props => [product, quantity];
}