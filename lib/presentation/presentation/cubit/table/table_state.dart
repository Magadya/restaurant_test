import 'package:equatable/equatable.dart';
import '../../../../domain/entities/table.dart';

abstract class TableState extends Equatable {
  const TableState();

  @override
  List<Object> get props => [];
}

class TableInitial extends TableState {}

class TableLoading extends TableState {}

class TableLoaded extends TableState {
  final List<RestaurantTable> tables;

  const TableLoaded(this.tables);

  @override
  List<Object> get props => [tables];
}

class TableError extends TableState {
  final String message;

  const TableError(this.message);

  @override
  List<Object> get props => [message];
}
