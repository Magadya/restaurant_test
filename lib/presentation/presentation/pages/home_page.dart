import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_texts.dart';
import '../../../domain/entities/order.dart';
import '../cubit/order/order_cubit.dart';
import '../cubit/order/order_state.dart';
import '../widgets/order_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexts.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.table_restaurant),
            onPressed: () => context.go('/tables'),
            tooltip: AppTexts.tables,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<OrderCubit>().loadOrders(),
            tooltip: 'Обновить',
          ),
        ],
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderLoaded) {
            if (state.orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppTexts.noOrders,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.go('/tables'),
                      icon: const Icon(Icons.add),
                      label: const Text(AppTexts.newOrder),
                    ),
                  ],
                ),
              );
            }


            final Map<OrderStatus, List<OrderModel>> groupedOrders = {
              OrderStatus.new_: [],
              OrderStatus.inProgress: [],
              OrderStatus.completed: [],
              OrderStatus.cancelled: [],
            };

            for (var order in state.orders) {
              groupedOrders[order.status]?.add(order);
            }

            return DefaultTabController(
              length: OrderStatus.values.length,
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    tabs: OrderStatus.values.map((status) {
                      final count = groupedOrders[status]?.length ?? 0;
                      return Tab(
                        child: Row(
                          children: [
                            Text(AppTexts.orderStatuses[status.name] ?? ''),
                            if (count > 0) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.orderStatusColors[status.name],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  count.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: OrderStatus.values.map((status) {
                        final orders = groupedOrders[status] ?? [];
                        if (orders.isEmpty) {
                          return Center(
                            child: Text(
                              'Нет ${AppTexts.orderStatuses[status.name]?.toLowerCase()} заказов',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return OrderCard(
                              order: orders[index],
                              onStatusUpdate: (newStatus) {
                                context.read<OrderCubit>().updateOrderStatus(
                                  orders[index],
                                  newStatus,
                                );
                              },
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is OrderError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.read<OrderCubit>().loadOrders(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}