
import 'package:flutter/material.dart';

import '../../../domain/entities/order.dart';

class OrderStatusDropdown extends StatelessWidget {
  final OrderStatus currentStatus;
  final Function(OrderStatus) onChanged;

  const OrderStatusDropdown({
    Key? key,
    required this.currentStatus,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentStatus == OrderStatus.completed ||
        currentStatus == OrderStatus.cancelled) {
      return const SizedBox.shrink();
    }

    final availableStatuses = _getAvailableStatuses(currentStatus);

    return SizedBox(
      height: 48,
      width: 48,
      child: PopupMenuButton<OrderStatus>(
        initialValue: currentStatus,
        icon: const Icon(Icons.more_vert),
        onSelected: onChanged,
        itemBuilder: (context) => availableStatuses.map((status) {
          final statusData = _getStatusData(status);
          return PopupMenuItem<OrderStatus>(
            value: status,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  statusData.icon,
                  size: 18,
                  color: statusData.color,
                ),
                const SizedBox(width: 8),
                Text(statusData.text),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  List<OrderStatus> _getAvailableStatuses(OrderStatus currentStatus) {
    switch (currentStatus) {
      case OrderStatus.new_:
        return [
          OrderStatus.new_,
          OrderStatus.inProgress,
          OrderStatus.cancelled,
        ];
      case OrderStatus.inProgress:
        return [
          OrderStatus.inProgress,
          OrderStatus.completed,
          OrderStatus.cancelled,
        ];
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        return [currentStatus];
    }
  }

  StatusData _getStatusData(OrderStatus status) {
    switch (status) {
      case OrderStatus.new_:
        return StatusData(
          color: Colors.blue,
          text: 'Новый',
          icon: Icons.fiber_new,
        );
      case OrderStatus.inProgress:
        return StatusData(
          color: Colors.orange,
          text: 'В процессе',
          icon: Icons.pending,
        );
      case OrderStatus.completed:
        return StatusData(
          color: Colors.green,
          text: 'Завершён',
          icon: Icons.check_circle,
        );
      case OrderStatus.cancelled:
        return StatusData(
          color: Colors.red,
          text: 'Отменён',
          icon: Icons.cancel,
        );
    }
  }
}

class StatusData {
  final Color color;
  final String text;
  final IconData icon;

  StatusData({
    required this.color,
    required this.text,
    required this.icon,
  });
}