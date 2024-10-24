import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/order.dart';
import '../cubit/order/order_cubit.dart';

class OrderActions extends StatelessWidget {
  final OrderModel order;

  const OrderActions({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionButtons(context),
          if (_showNotes) ...[
            const SizedBox(height: 16),
            _buildNotes(context),
          ],
        ],
      ),
    );
  }

  bool get _showNotes => order.status != OrderStatus.completed && order.status != OrderStatus.cancelled;

  Widget _buildActionButtons(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (order.status == OrderStatus.new_ || order.status == OrderStatus.inProgress) ...[
            _ActionButton(
              icon: Icons.print,
              label: 'Печать',
              onPressed: () => _handlePrint(context),
            ),
            const SizedBox(width: 8),
            _ActionButton(
              icon: Icons.edit,
              label: 'Изменить',
              onPressed: () => _handleEdit(context),
            ),
            const SizedBox(width: 8),
            _ActionButton(
              icon: Icons.cancel,
              label: 'Отменить',
              color: AppColors.error,
              onPressed: () => _handleCancel(context),
            ),
          ],
          if (order.status == OrderStatus.inProgress) ...[
            const SizedBox(width: 8),
            _ActionButton(
              icon: Icons.check_circle,
              label: 'Завершить',
              color: AppColors.success,
              onPressed: () => _handleComplete(context),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotes(BuildContext context) {
    return TextField(
      maxLines: 2,
      decoration: InputDecoration(
        labelText: 'Примечания к заказу',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      ),
      onChanged: (value) {},
    );
  }

  void _handlePrint(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Печать заказа...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleEdit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _EditOrderDialog(order: order),
    );
  }

  void _handleCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отменить заказ'),
        content: const Text(
          'Вы уверены, что хотите отменить этот заказ? Это действие нельзя отменить.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Нет'),
          ),
          TextButton(
            onPressed: () {
              context.read<OrderCubit>().updateOrderStatus(
                    order,
                    OrderStatus.cancelled,
                  );
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Да, отменить'),
          ),
        ],
      ),
    );
  }

  void _handleComplete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Завершить заказ'),
        content: const Text(
          'Вы уверены, что хотите завершить этот заказ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Нет'),
          ),
          TextButton(
            onPressed: () {
              context.read<OrderCubit>().updateOrderStatus(
                    order,
                    OrderStatus.completed,
                  );
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.success,
            ),
            child: const Text('Да, завершить'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const _ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: color,
        size: 20,
      ),
      label: Text(
        label,
        style: TextStyle(color: color),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      ),
    );
  }
}

class _EditOrderDialog extends StatefulWidget {
  final OrderModel order;

  const _EditOrderDialog({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<_EditOrderDialog> createState() => _EditOrderDialogState();
}

class _EditOrderDialogState extends State<_EditOrderDialog> {
  late List<OrderItem> items;

  @override
  void initState() {
    super.initState();
    items = List.from(widget.order.items);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Редактировать заказ',
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Состав заказа:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    // leading: Image.asset(
                    //   item.product.imageUrl,
                    //   width: 30,
                    //   height: 30,
                    //   fit: BoxFit.cover,
                    // ),
                    title: Text(item.product.name),
                    subtitle: Text(
                      '${item.product.price.toStringAsFixed(2)} \$',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (item.quantity > 1) {
                                items[index] = OrderItem(
                                  product: item.product,
                                  quantity: item.quantity - 1,
                                );
                              } else {
                                items.removeAt(index);
                              }
                            });
                          },
                        ),
                        Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              items[index] = OrderItem(
                                product: item.product,
                                quantity: item.quantity + 1,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                final updatedOrder = OrderModel(
                  id: widget.order.id,
                  tableId: widget.order.tableId,
                  items: items,
                  status: widget.order.status,
                  createdAt: widget.order.createdAt,
                  totalAmount: items.fold(
                    0,
                    (sum, item) => sum + (item.product.price * item.quantity),
                  ),
                );

                context.read<OrderCubit>().updateOrder(updatedOrder);
                Navigator.pop(context);
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ],
    );
  }
}
