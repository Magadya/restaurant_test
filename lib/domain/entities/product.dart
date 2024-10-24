import 'package:equatable/equatable.dart';

enum ProductType { pizza, drink }

class Product extends Equatable {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final ProductType type;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.type,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, price, imageUrl, type, description];
}
