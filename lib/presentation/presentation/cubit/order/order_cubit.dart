import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/orders/get_orders.dart';
import '../../../../domain/entities/order.dart';
import '../../../../domain/usecases/orders/add_order.dart';
import '../../../../domain/usecases/orders/update_order.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final GetOrders getOrders;
  final AddOrder addOrder;
  final UpdateOrder updateOrder;

  OrderCubit({
    required this.getOrders,
    required this.addOrder,
    required this.updateOrder,
  }) : super(OrderInitial());

  Future<void> loadOrders() async {
    emit(OrderLoading());
    final result = await getOrders();
    result.fold(
      (failure) => emit(OrderError(failure.toString())),
      (orders) => emit(OrderLoaded(orders)),
    );
  }

  Future<void> createOrder(OrderModel order) async {
    final result = await addOrder(order);
    result.fold(
      (failure) => emit(OrderError(failure.toString())),
      (_) => loadOrders(),
    );
  }

  Future<void> updateOrderStatus(OrderModel order, OrderStatus newStatus) async {
    final updatedOrder = OrderModel(
      id: order.id,
      tableId: order.tableId,
      items: order.items,
      status: newStatus,
      createdAt: order.createdAt,
      totalAmount: order.totalAmount,
    );

    final result = await updateOrder(updatedOrder);
    result.fold(
      (failure) => emit(OrderError(failure.toString())),
      (_) => loadOrders(),
    );
  }
}
