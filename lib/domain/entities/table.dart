import 'package:equatable/equatable.dart';

class RestaurantTable extends Equatable {
  final int id;
  final String number;
  final bool isOccupied;

  const RestaurantTable({
    required this.id,
    required this.number,
    required this.isOccupied,
  });

  @override
  List<Object?> get props => [id, number, isOccupied];
}