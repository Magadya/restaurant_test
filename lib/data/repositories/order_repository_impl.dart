import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/local/database_helper.dart';

class OrderRepositoryImpl implements OrderRepository {
  final DatabaseHelper databaseHelper;

  OrderRepositoryImpl(this.databaseHelper);

  @override
  Future<Either<Failure, List<OrderModel>>> getOrders() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> orderMaps = await db.query('orders');
      final List<OrderModel> orders = [];

      for (var orderMap in orderMaps) {
        final List<Map<String, dynamic>> itemMaps = await db.query(
          'order_items',
          where: 'orderId = ?',
          whereArgs: [orderMap['id'] as int],
        );

        final items = await Future.wait(itemMaps.map((itemMap) async {
          final List<Map<String, dynamic>> productMaps = await db.query(
            'products',
            where: 'id = ?',
            whereArgs: [itemMap['productId'] as int],
          );

          if (productMaps.isEmpty) {
            throw Exception('Product not found');
          }

          final productMap = productMaps.first;
          final product = Product(
            id: productMap['id'] as int,
            name: productMap['name'] as String,
            price: (productMap['price'] as num).toDouble(),
            imageUrl: productMap['imageUrl'] as String,
            type: productMap['type'] == 'pizza' ? ProductType.pizza : ProductType.drink,
            description: productMap['description'] as String,
          );

          return OrderItem(
            product: product,
            quantity: itemMap['quantity'] as int,
          );
        }));

        orders.add(OrderModel(
          id: orderMap['id'] as int,
          tableId: orderMap['tableId'] as int,
          items: items,
          status: OrderStatus.values.firstWhere(
            (e) => e.toString() == 'OrderStatus.${orderMap['status']}',
          ),
          createdAt: DateTime.parse(orderMap['createdAt'] as String),
          totalAmount: (orderMap['totalAmount'] as num).toDouble(),
        ));
      }

      return Right(orders);
    } catch (e) {
      print('Error in getOrders: $e'); // Для отладки
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addOrder(OrderModel order) async {
    try {
      final db = await databaseHelper.database;
      final orderId = await db.insert('orders', {
        'tableId': order.tableId,
        'status': order.status.toString().split('.').last,
        'createdAt': order.createdAt.toIso8601String(),
        'totalAmount': order.totalAmount,
      });

      for (var item in order.items) {
        await db.insert('order_items', {
          'orderId': orderId,
          'productId': item.product.id,
          'quantity': item.quantity,
        });
      }

      return const Right(unit);
    } catch (e) {
      print('Error in addOrder: $e'); // Для отладки
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateOrder(OrderModel order) async {
    try {
      final db = await databaseHelper.database;
      await db.update(
        'orders',
        {
          'status': order.status.toString().split('.').last,
          'totalAmount': order.totalAmount,
        },
        where: 'id = ?',
        whereArgs: [order.id],
      );

      // Обновляем order_items
      await db.delete(
        'order_items',
        where: 'orderId = ?',
        whereArgs: [order.id],
      );

      for (var item in order.items) {
        await db.insert('order_items', {
          'orderId': order.id,
          'productId': item.product.id,
          'quantity': item.quantity,
        });
      }

      return const Right(unit);
    } catch (e) {
      print('Error in updateOrder: $e'); // Для отладки
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteOrder(int id) async {
    try {
      final db = await databaseHelper.database;

      // Сначала удаляем связанные order_items
      await db.delete(
        'order_items',
        where: 'orderId = ?',
        whereArgs: [id],
      );

      // Затем удаляем сам заказ
      await db.delete(
        'orders',
        where: 'id = ?',
        whereArgs: [id],
      );

      return const Right(unit);
    } catch (e) {
      print('Error in deleteOrder: $e'); // Для отладки
      return Left(DatabaseFailure());
    }
  }
}
